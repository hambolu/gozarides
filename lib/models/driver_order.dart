import 'package:gozarides/models/order_status.dart';

class DriverOrder {
  final String id;
  final String pickupAddress;
  final String deliveryAddress;
  final DateTime assignedTime;
  final String customerName;
  final String customerPhone;
  OrderStatus status;
  final double? pickupLatitude;
  final double? pickupLongitude;
  final double? deliveryLatitude;
  final double? deliveryLongitude;
  final String? notes;
  final List<String>? itemDetails;

  DriverOrder({
    required this.id,
    required this.pickupAddress,
    required this.deliveryAddress,
    required this.assignedTime,
    required this.customerName,
    required this.customerPhone,
    required this.status,
    this.pickupLatitude,
    this.pickupLongitude,
    this.deliveryLatitude,
    this.deliveryLongitude,
    this.notes,
    this.itemDetails,
  });

  factory DriverOrder.fromJson(Map<String, dynamic> json) {
    return DriverOrder(
      id: json['id'] as String,
      pickupAddress: json['pickupAddress'] as String,
      deliveryAddress: json['deliveryAddress'] as String,
      assignedTime: DateTime.parse(json['assignedTime'] as String),
      customerName: json['customerName'] as String,
      customerPhone: json['customerPhone'] as String,
      status: OrderStatus.fromString(json['status'] as String) ?? OrderStatus.newOrder,
      pickupLatitude: json['pickupLatitude'] as double?,
      pickupLongitude: json['pickupLongitude'] as double?,
      deliveryLatitude: json['deliveryLatitude'] as double?,
      deliveryLongitude: json['deliveryLongitude'] as double?,
      notes: json['notes'] as String?,
      itemDetails: (json['itemDetails'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pickupAddress': pickupAddress,
      'deliveryAddress': deliveryAddress,
      'assignedTime': assignedTime.toIso8601String(),
      'customerName': customerName,
      'customerPhone': customerPhone,
      'status': status.toString().split('.').last,
      'pickupLatitude': pickupLatitude,
      'pickupLongitude': pickupLongitude,
      'deliveryLatitude': deliveryLatitude,
      'deliveryLongitude': deliveryLongitude,
      'notes': notes,
      'itemDetails': itemDetails,
    };
  }
}
