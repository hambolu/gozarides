import 'package:flutter/foundation.dart';
import '../services/firebase_service.dart';

class WalletProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  double _balance = 0.0;
  List<Map<String, dynamic>> _transactions = [];
  bool _isLoading = false;

  double get balance => _balance;
  List<Map<String, dynamic>> get transactions => _transactions;
  bool get isLoading => _isLoading;

  Future<void> loadWallet(String uid) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Get wallet balance
      final walletDoc = await _firebaseService.getWalletBalance(uid);
      _balance = walletDoc['balance'] ?? 0.0;

      // Get transactions
      _transactions = await _firebaseService.getTransactions(uid);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> addFunds(String uid, double amount) async {
    try {
      await _firebaseService.addFunds(uid, amount);
      await loadWallet(uid); // Reload wallet after adding funds
    } catch (e) {
      rethrow;
    }
  }

  Future<void> withdrawFunds(String uid, double amount, Map<String, dynamic> bankDetails) async {
    try {
      await _firebaseService.withdrawFunds(uid, amount, bankDetails);
      await loadWallet(uid); // Reload wallet after withdrawal
    } catch (e) {
      rethrow;
    }
  }

  Future<void> recordPendingTransfer(String userId, double amount) async {
    try {
      await _firebaseService.addTransaction(userId, {
        'type': 'pending_transfer',
        'amount': amount,
        'status': 'pending',
        'paymentMethod': 'bank_transfer',
        'description': 'Bank transfer pending confirmation',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }
}
