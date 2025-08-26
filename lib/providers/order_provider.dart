import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/order.dart' as app_order;

class OrderProvider with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<app_order.Order> getOrderDetails(String orderId) async {
    try {
      setLoading(true);
      final doc = await _firestore.collection('orders').doc(orderId).get();
      if (!doc.exists) {
        throw Exception('Order not found');
      }
      return app_order.Order.fromMap(doc.data()!, doc.id);
    } catch (e) {
      throw Exception('Failed to get order details: $e');
    } finally {
      setLoading(false);
    }
  }

  Stream<List<app_order.Order>> getUserOrders(String userId) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => 
            snapshot.docs.map((doc) => app_order.Order.fromMap(doc.data(), doc.id)).toList());
  }

  Future<void> cancelOrder(String orderId, String reason) async {
    try {
      setLoading(true);
      await _firestore.collection('orders').doc(orderId).update({
        'status': 'cancelled',
        'cancellationReason': reason,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to cancel order: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> createOrder(Map<String, dynamic> orderData) async {
    try {
      setLoading(true);
      await _firestore.collection('orders').add({
        ...orderData,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to create order: $e');
    } finally {
      setLoading(false);
    }
  }
}
