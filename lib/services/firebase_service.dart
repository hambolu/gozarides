import 'dart:io';
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
  // final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Email & Password Sign Up
  Future<UserCredential> signUpWithEmail(
    String email,
    String password,
    String name,
    String phone,
    String userType, // 'driver' or 'passenger'
  ) async {
    try {
      print('\n==========================================');
      print('📝 FIREBASE AUTH - SIGNUP ATTEMPT');
      print('==========================================');
      print('Email: $email');
      print('Name: $name');
      print('Phone: $phone');
      print('User Type: $userType');
      print('==========================================\n');

      // Create user with email and password
      UserCredential userCredential;
      try {
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        print('✅ User account created successfully');
        print('User ID: ${userCredential.user?.uid}');
      } on FirebaseAuthException catch (e) {
        print('❌ Firebase Auth Error: ${e.code}');
        switch (e.code) {
          case 'email-already-in-use':
            throw 'This email address is already registered. Please sign in or use a different email.';
          case 'invalid-email':
            throw 'The email address is not valid. Please check and try again.';
          case 'operation-not-allowed':
            throw 'Email/password accounts are not enabled. Please contact support.';
          case 'weak-password':
            throw 'The password is too weak. Please use a stronger password.';
          default:
            throw e.message ?? 'Failed to create account. Please try again.';
        }
      }

      // Create user profile in Firestore
      try {
        await _createUserProfile(
          userCredential.user!.uid,
          name,
          email,
          phone,
          userType,
        );
        print('✅ User profile created in Firestore');
      } catch (firestoreError) {
        print('❌ ERROR creating user profile in Firestore:');
        print(firestoreError);
        // Delete the auth user since profile creation failed
        await userCredential.user?.delete();
        if (firestoreError is FirebaseException) {
          switch (firestoreError.code) {
            case 'permission-denied':
              throw 'Unable to create user profile due to permission issues. Please try again or contact support.';
            default:
              throw 'Failed to create user profile: ${firestoreError.message}. Please try again.';
          }
        }
        throw 'Failed to create user profile. Please try again.';
      }

      return userCredential;
    } catch (e) {
      print('\n❌ ERROR during signup:');
      print(e);
      rethrow;
    }
  }

  // Google Sign In
  // Future<UserCredential> signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //     if (googleUser == null) throw 'Google Sign In was cancelled';
  //
  //     final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );
  //
  //     UserCredential userCredential = await _auth.signInWithCredential(credential);
  //
  //     // Check if this is a new user
  //     bool isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
  //     if (isNewUser) {
  //       await _createUserProfile(
  //         userCredential.user!.uid,
  //         userCredential.user!.displayName ?? '',
  //         userCredential.user!.email ?? '',
  //         userCredential.user!.phoneNumber ?? '',
  //         'passenger', // Default type for Google Sign In
  //       );
  //     }
  //
  //     return userCredential;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

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

  // Wallet Functions
  Future<DocumentSnapshot> getWalletBalance(String uid) async {
    try {
      return await _firestore
          .collection('users')
          .doc(uid)
          .collection('wallet')
          .doc('balance')
          .get();
    } catch (e) {
      throw Exception('Failed to get wallet balance: $e');
    }
  }

  Stream<QuerySnapshot> getTransactions(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('wallet')
        .doc('balance')
        .collection('transactions')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> addFunds(String uid, double amount) async {
    try {
      final walletRef = _firestore
          .collection('users')
          .doc(uid)
          .collection('wallet')
          .doc('balance');
      
      await _firestore.runTransaction((transaction) async {
        final wallet = await transaction.get(walletRef);
        final currentBalance = (wallet.data()?['amount'] ?? 0.0) as double;
        transaction.update(walletRef, {
          'amount': currentBalance + amount,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      });

      // Add transaction record
      await addTransaction(uid, {
        'type': 'credit',
        'amount': amount,
        'description': 'Added funds to wallet',
        'status': 'completed'
      });
    } catch (e) {
      throw Exception('Failed to add funds: $e');
    }
  }

  Future<void> withdrawFunds(String uid, double amount, Map<String, String> bankDetails) async {
    try {
      final walletRef = _firestore
          .collection('users')
          .doc(uid)
          .collection('wallet')
          .doc('balance');

      await _firestore.runTransaction((transaction) async {
        final wallet = await transaction.get(walletRef);
        final currentBalance = (wallet.data()?['amount'] ?? 0.0) as double;
        if (currentBalance < amount) {
          throw Exception('Insufficient funds');
        }
        transaction.update(walletRef, {
          'amount': currentBalance - amount,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      });

      // Add transaction record
      await addTransaction(uid, {
        'type': 'debit',
        'amount': amount,
        'description': 'Withdrawal to bank account',
        'bankDetails': bankDetails,
        'status': 'processing'
      });
    } catch (e) {
      throw Exception('Failed to withdraw funds: $e');
    }
  }

  Future<void> addTransaction(String userId, Map<String, dynamic> transactionData) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('wallet')
          .doc('balance')
          .collection('transactions')
          .add({
            ...transactionData,
            'timestamp': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      throw Exception('Failed to add transaction: $e');
    }
  }

  Future<DocumentReference> createOrder(Map<String, dynamic> orderData) async {
    try {
      return await _firestore.collection('orders').add({
        ...orderData,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  Stream<QuerySnapshot> getUserOrders(String uid) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }

  Future<void> cancelOrder(String orderId, String reason) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': 'cancelled',
        'cancelReason': reason,
        'cancelledAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to cancel order: $e');
    }
  }

  Stream<QuerySnapshot> getChats(String uid) {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: uid)
        .snapshots();
  }

  Stream<QuerySnapshot> getChatMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> markChatAsRead(String chatId) async {
    try {
      await _firestore.collection('chats').doc(chatId).update({
        'unread': false,
        'lastReadAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to mark chat as read: $e');
    }
  }
}
