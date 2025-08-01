import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import '../models/order_model.dart';
import '../models/wallet_model.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Email & Password Sign Up
  Future<UserCredential> signUpWithEmail(
    String email,
    String password,
    String name,
    String phone,
    String userType, // 'driver' or 'passenger'
  ) async {
    try {
      // Create user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user profile in Firestore
      await _createUserProfile(
        userCredential.user!.uid,
        name,
        email,
        phone,
        userType,
      );

      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  // Google Sign In
  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw 'Google Sign In was cancelled';

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);

      // Check if this is a new user
      bool isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
      if (isNewUser) {
        await _createUserProfile(
          userCredential.user!.uid,
          userCredential.user!.displayName ?? '',
          userCredential.user!.email ?? '',
          userCredential.user!.phoneNumber ?? '',
          'passenger', // Default type for Google Sign In
        );
      }

      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  // Phone Number Authentication
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(PhoneAuthCredential) onVerificationCompleted,
    required Function(FirebaseAuthException) onVerificationFailed,
    required Function(String, int?) onCodeSent,
    required Function(String) onCodeAutoRetrievalTimeout,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: onVerificationCompleted,
      verificationFailed: onVerificationFailed,
      codeSent: onCodeSent,
      codeAutoRetrievalTimeout: onCodeAutoRetrievalTimeout,
    );
  }

  // Create User Profile in Firestore
  Future<void> _createUserProfile(
    String uid,
    String name,
    String email,
    String phone,
    String userType,
  ) async {
    await _firestore.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'phone': phone,
      'userType': userType,
      'createdAt': FieldValue.serverTimestamp(),
      'isActive': true,
      'rating': 0.0,
      'totalRides': 0,
      'profileCompleted': false,
      'profilePicture': '',
      'vehicleInfo': userType == 'driver' ? {} : null,
      'location': null,
    });

    // Create wallet document for the user
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('wallet')
        .doc('balance')
        .set({
      'amount': 0.0,
      'lastUpdated': FieldValue.serverTimestamp(),
      'currency': 'USD',
    });
  }

  // Profile Picture Upload
  Future<String> uploadProfilePicture(String uid, String filePath) async {
    try {
      final ref = _storage.ref().child('profile_pictures/$uid/profile.jpg');
      await ref.putFile(File(filePath));
      final url = await ref.getDownloadURL();
      
      // Update user profile with new picture URL
      await _firestore.collection('users').doc(uid).update({
        'profilePicture': url,
      });
      
      return url;
    } catch (e) {
      rethrow;
    }
  }

  // Driver Document Upload
  Future<String> uploadDriverDocument(String uid, String filePath, String documentType) async {
    try {
      final ref = _storage.ref().child('vehicle_documents/$uid/$documentType.pdf');
      await ref.putFile(File(filePath));
      final url = await ref.getDownloadURL();
      
      // Update vehicle info in user profile
      await _firestore.collection('users').doc(uid).update({
        'vehicleInfo.documents.$documentType': url,
      });
      
      return url;
    } catch (e) {
      rethrow;
    }
  }

  // Ride Management
  Future<String> createRide(Map<String, dynamic> rideData) async {
    try {
      DocumentReference rideRef = await _firestore.collection('rides').add({
        ...rideData,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
      return rideRef.id;
    } catch (e) {
      rethrow;
    }
  }

  Stream<DocumentSnapshot> getRideStream(String rideId) {
    return _firestore.collection('rides').doc(rideId).snapshots();
  }

  // Chat Functions
  Future<String> createChat(String userId1, String userId2) async {
    try {
      DocumentReference chatRef = await _firestore.collection('chats').add({
        'participants': {
          userId1: true,
          userId2: true,
        },
        'lastMessage': null,
        'lastMessageTime': null,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return chatRef.id;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendMessage(String chatId, String senderId, String message) async {
    try {
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
        'senderId': senderId,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
        'read': false,
      });

      // Update last message in chat document
      await _firestore.collection('chats').doc(chatId).update({
        'lastMessage': message,
        'lastMessageTime': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  // Existing methods remain unchanged...
  // ...existing code...
}
