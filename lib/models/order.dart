import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String id;
  final String status;
  final double totalAmount;
  final String pickupAddress;
  final String dropoffAddress;
  final double distance;
  final DateTime createdAt;
  final String? driverId;
  final String? driverName;
  final String? driverPhone;
  final String userId;
  final String userPhone;

  Order({
    required this.id,
    required this.status,
    required this.totalAmount,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.distance,
    required this.createdAt,
    this.driverId,
    this.driverName,
    this.driverPhone,
    required this.userId,
    required this.userPhone,
  });

  factory Order.fromMap(Map<String, dynamic> map, String id) {
    return Order(
      id: id,
      status: map['status'] ?? 'pending',
      totalAmount: (map['totalAmount'] ?? 0.0).toDouble(),
      pickupAddress: map['pickupAddress'] ?? '',
      dropoffAddress: map['dropoffAddress'] ?? '',
      distance: (map['distance'] ?? 0.0).toDouble(),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      driverId: map['driverId'],
      driverName: map['driverName'],
      driverPhone: map['driverPhone'],
      userId: map['userId'] ?? '',
      userPhone: map['userPhone'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'totalAmount': totalAmount,
      'pickupAddress': pickupAddress,
      'dropoffAddress': dropoffAddress,
      'distance': distance,
      'createdAt': Timestamp.fromDate(createdAt),
      'driverId': driverId,
      'driverName': driverName,
      'driverPhone': driverPhone,
      'userId': userId,
      'userPhone': userPhone,
    };
  }
}
