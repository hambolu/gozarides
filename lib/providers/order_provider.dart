import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase_service.dart';

class OrderProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  List<Map<String, dynamic>> _orders = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get orders => _orders;
  bool get isLoading => _isLoading;

  Future<void> createOrder(Map<String, dynamic> orderData) async {
    try {
      await _firebaseService.createOrder(orderData);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  void listenToOrders(String uid) {
    _firebaseService.getUserOrders(uid).listen((QuerySnapshot snapshot) {
      _orders = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {'id': doc.id, ...data};
      }).toList();
      notifyListeners();
    });
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await _firebaseService.updateOrderStatus(orderId, status);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cancelOrder(String orderId, String reason) async {
    try {
      await _firebaseService.cancelOrder(orderId, reason);
    } catch (e) {
      rethrow;
    }
  }
}
