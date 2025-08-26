import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/order.dart';
import '../../models/order_status.dart';
import '../../providers/order_provider.dart';
import '../../screens/chat/chat_detail_screen.dart';
import '../../services/chat_service.dart';
import '../../widgets/loading_indicator.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailsScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          return FutureBuilder<Order>(
            future: orderProvider.getOrderDetails(widget.orderId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingIndicator();
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              final order = snapshot.data!;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Order Information'),
                    _buildInfoCard([
                      _buildInfoRow('Order ID', order.id),
                      _buildInfoRow('Status', order.status),
                      _buildInfoRow('Date', order.createdAt.toString()),
                      _buildInfoRow('Total Amount', '\$${order.totalAmount.toStringAsFixed(2)}'),
                    ]),
                    const SizedBox(height: 20),
                    _buildSectionTitle('Delivery Details'),
                    _buildInfoCard([
                      _buildInfoRow('Pickup', order.pickupAddress),
                      _buildInfoRow('Dropoff', order.dropoffAddress),
                      _buildInfoRow('Distance', '${order.distance.toStringAsFixed(1)} km'),
                    ]),
                    if (order.status == OrderStatus.accepted || 
                        order.status == OrderStatus.pickedUp || 
                        order.status == OrderStatus.arrivedAtPickup) ...[
                      const SizedBox(height: 20),
                      _buildSectionTitle('Driver Information'),
                      _buildInfoCard([
                        _buildInfoRow('Name', order.driverName ?? 'Not assigned'),
                        if (order.driverPhone != null)
                          _buildInfoRow('Phone', order.driverPhone!),
                      ]),
                    ],
                    const SizedBox(height: 20),
                    _buildActionButtons(context, order),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Order order) {
    return Row(
      children: [
        if (order.status == OrderStatus.newOrder)
          Expanded(
            child: ElevatedButton(
              onPressed: () async {
                try {
                  await context.read<OrderProvider>().cancelOrder(order.id, 'Cancelled by user');
                  if (mounted) {
                    Navigator.pop(context);
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to cancel order: $e')),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Cancel Order'),
            ),
          ),
        if (order.status == OrderStatus.accepted) ...[
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // TODO: Implement chat with driver
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatDetailScreen(
                      chatId: order.id,
                      businessName: order.driverName ?? '',
                      otherUserId: order.driverId ?? '',
                    ),
                  ),
                );
              },
              child: const Text('Chat with Driver'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // TODO: Implement track order
              },
              child: const Text('Track Order'),
            ),
          ),
        ],
      ],
    );
  }
}
