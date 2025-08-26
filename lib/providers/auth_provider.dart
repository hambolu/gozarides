import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/connectivity_service.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ConnectivityService _connectivityService = ConnectivityService();
  User? _user;
  bool _isLoading = false;
  String? _verificationId;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get verificationId => _verificationId;
  User? get firebaseUser => _user;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });

    // Listen to connectivity changes
    _connectivityService.onConnectivityChanged.listen((isConnected) {
      notifyListeners(); // Update UI when connectivity changes
    });
  }

  Future<void> _checkConnectivity() async {
    if (!await _connectivityService.isConnected()) {
      throw FirebaseAuthException(
        code: 'no-internet',
        message: 'No internet connection. Please check your connection and try again.',
      );
    }
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String userType,
  }) async {
    try {
      setLoading(true);
      
      await _checkConnectivity();
      
      // Validate email format
      if (!email.contains('@')) {
        throw FirebaseAuthException(
          code: 'invalid-email',
          message: 'The email address is invalid.'
        );
      }

      // Validate user type
      if (userType != 'buyer' && userType != 'seller') {
        throw FirebaseAuthException(
          code: 'invalid-user-type',
          message: 'User type must be either buyer or seller'
        );
      }
      
      // Create user with email and password
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      _user = userCredential.user;
      
      if (_user == null) {
        throw FirebaseAuthException(
          code: 'null-user',
          message: 'Failed to create user account'
        );
      }

      // Update display name
      try {
        await _user!.updateDisplayName(name);
      } catch (e) {
        print('Warning: Could not update display name: $e');
      }

      // Create user profile in Firestore
      try {
        final userData = {
          'uid': _user!.uid,
          'name': name,
          'email': email,
          'phone': phone,
          'userType': userType,
          'isPhoneVerified': false,
          'isEmailVerified': false,
          'isActive': true,
          'profilePicture': '',
          'profileCompleted': false,
          'rating': 0.0,
          'totalRides': 0,
          'wallet': {
            'balance': 0,
            'lastUpdated': FieldValue.serverTimestamp(),
          },
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        };
        
        await _firestore.collection('users').doc(_user!.uid).set(userData);
      } catch (e) {
        // If profile creation fails, delete the auth user
        await _user!.delete();
        throw FirebaseAuthException(
          code: 'profile-creation-failed',
          message: 'Failed to create user profile. Please try again.'
        );
      }

      notifyListeners();
    } catch (e) {
      if (e is FirebaseAuthException) {
        rethrow;
      }
      throw FirebaseAuthException(
        code: 'signup-failed',
        message: 'Failed to create account: $e'
      );
    } finally {
      setLoading(false);
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      setLoading(true);

      // Check for internet connectivity
      await _checkConnectivity();

      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;

      // Get user's data from Firestore
      final userDoc = await _firestore.collection('users').doc(_user!.uid).get();
      if (!userDoc.exists) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'User profile not found. Please try again or contact support.'
        );
      }

      notifyListeners();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw FirebaseAuthException(
            code: 'user-not-found',
            message: 'No user found with this email. Please check and try again.'
          );
        case 'wrong-password':
          throw FirebaseAuthException(
            code: 'wrong-password',
            message: 'Incorrect password. Please try again.'
          );
        case 'user-disabled':
          throw FirebaseAuthException(
            code: 'user-disabled',
            message: 'This account has been disabled. Please contact support.'
          );
        case 'invalid-email':
          throw FirebaseAuthException(
            code: 'invalid-email',
            message: 'The email address is not valid. Please check and try again.'
          );
        default:
          throw FirebaseAuthException(
            code: e.code,
            message: e.message ?? 'Failed to sign in. Please try again.'
          );
      }
    } finally {
      setLoading(false);
    }
  }

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String) onCodeSent,
    required Function(String) onError,
  }) async {
    try {
      setLoading(true);

      // Check for internet connectivity
      await _checkConnectivity();
      
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          onError(e.message ?? 'Verification failed');
        },
        codeSent: (String verId, int? resendToken) async {
          _verificationId = verId;
          onCodeSent(verId);
        },
        codeAutoRetrievalTimeout: (String verId) async {
          _verificationId = verId;
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      throw Exception('Failed to verify phone number: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      setLoading(true);

      await _checkConnectivity();
      
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      if (_user != null) {
        // Link phone credential to existing account
        await _user!.linkWithCredential(credential);
        
        // Update phone verification status
        await _firestore.collection('users').doc(_user!.uid).update({
          'isPhoneVerified': true,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        // This shouldn't happen in normal flow since user should be created first
        throw FirebaseAuthException(
          code: 'no-user',
          message: 'Please sign up before verifying phone number'
        );
      }

      notifyListeners();
    } catch (e) {
      if (e is FirebaseAuthException) {
        rethrow;
      }
      throw FirebaseAuthException(
        code: 'verification-failed',
        message: 'Failed to verify OTP: $e'
      );
    } finally {
      setLoading(false);
    }
  }

  Future<void> signUpAsSeller({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String businessName,
    required String businessAddress,
    required String businessCategory,
    required String businessDescription,
  }) async {
    try {
      setLoading(true);
      
      await _checkConnectivity();
      
      // Create user with email and password
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      _user = userCredential.user;
      
      if (_user == null) {
        throw FirebaseAuthException(
          code: 'null-user',
          message: 'Failed to create seller account'
        );
      }

      // Update display name
      try {
        await _user!.updateDisplayName(name);
      } catch (e) {
        // Continue anyway as this is not critical
      }

      // Create seller profile in Firestore
      try {
        await _firestore.collection('users').doc(_user!.uid).set({
          'name': name,
          'email': email,
          'phone': phone,
          'userType': 'seller',
          'businessName': businessName,
          'businessAddress': businessAddress,
          'businessCategory': businessCategory,
          'businessDescription': businessDescription,
          'isVerified': false,
          'isPhoneVerified': false,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } catch (e) {
        // Delete the auth user since profile creation failed
        await _user!.delete();
        throw FirebaseAuthException(
          code: 'profile-creation-failed',
          message: 'Failed to create seller profile. Please try again.'
        );
      }

      notifyListeners();
    } catch (e) {
      if (e is FirebaseAuthException) {
        rethrow;
      }
      throw FirebaseAuthException(
        code: 'signup-failed',
        message: 'Failed to create seller account: $e'
      );
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateUserProfile(Map<String, dynamic> data) async {
    try {
      setLoading(true);
      
      await _checkConnectivity();

      if (_user == null) {
        throw FirebaseAuthException(
          code: 'no-user',
          message: 'No authenticated user found'
        );
      }

      await _firestore.collection('users').doc(_user!.uid).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      notifyListeners();
    } catch (e) {
      if (e is FirebaseAuthException) {
        rethrow;
      }
      throw FirebaseAuthException(
        code: 'update-failed',
        message: 'Failed to update profile: $e'
      );
    } finally {
      setLoading(false);
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _user = null;
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }
}
