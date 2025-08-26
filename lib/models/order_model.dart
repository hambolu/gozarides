import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String userId;
  final String driverId;
  final String status;
  final String pickupLocation;
  final String dropoffLocation;
  final double fare;
  final DateTime createdAt;
  final String paymentStatus;
  final String paymentMethod;

  OrderModel({
    required this.id,
    required this.userId,
    required this.driverId,
    required this.status,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.fare,
    required this.createdAt,
    required this.paymentStatus,
    required this.paymentMethod,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map, String id) {
    return OrderModel(
      id: id,
      userId: map['userId'] ?? '',
      driverId: map['driverId'] ?? '',
      status: map['status'] ?? '',
      pickupLocation: map['pickupLocation'] ?? '',
      dropoffLocation: map['dropoffLocation'] ?? '',
      fare: (map['fare'] ?? 0.0).toDouble(),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      paymentStatus: map['paymentStatus'] ?? '',
      paymentMethod: map['paymentMethod'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'driverId': driverId,
      'status': status,
      'pickupLocation': pickupLocation,
      'dropoffLocation': dropoffLocation,
      'fare': fare,
      'createdAt': Timestamp.fromDate(createdAt),
      'paymentStatus': paymentStatus,
      'paymentMethod': paymentMethod,
    };
  }
}
