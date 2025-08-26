import 'package:cloud_firestore/cloud_firestore.dart';
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

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> fetchBalance(String uid) async {
    try {
      setLoading(true);
      final walletDoc = await _firebaseService.getWalletBalance(uid);
      if (walletDoc.exists) {
        _balance = (walletDoc.data() as Map<String, dynamic>)['amount']?.toDouble() ?? 0.0;
      } else {
        _balance = 0.0;
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching balance: $e');
      _balance = 0.0;
    } finally {
      setLoading(false);
    }
  }

  Stream<QuerySnapshot> getTransactionsStream(String uid) {
    return _firebaseService.getTransactions(uid);
  }

  void updateTransactions(List<QueryDocumentSnapshot> docs) {
    _transactions = docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'id': doc.id,
        ...data,
        'timestamp': (data['timestamp'] as Timestamp).toDate(),
      };
    }).toList();
    notifyListeners();
  }

  Future<void> addFunds(String uid, double amount) async {
    try {
      setLoading(true);
      await _firebaseService.addFunds(uid, amount);
      await fetchBalance(uid);
    } finally {
      setLoading(false);
    }
  }

  Future<void> withdrawFunds(String uid, double amount, Map<String, String> bankDetails) async {
    try {
      setLoading(true);
      await _firebaseService.withdrawFunds(uid, amount, bankDetails);
      await fetchBalance(uid);
    } finally {
      setLoading(false);
    }
  }
}
