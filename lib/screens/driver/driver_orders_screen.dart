import 'package:flutter/material.dart';
import 'package:gozarides/models/driver_order.dart';
import 'package:gozarides/models/order_status.dart';

class DriverOrdersScreen extends StatefulWidget {
  const DriverOrdersScreen({super.key});

  @override
  State<DriverOrdersScreen> createState() => _DriverOrdersScreenState();
}

class _DriverOrdersScreenState extends State<DriverOrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<DriverOrder> orders = []; // This will be populated from your backend

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // TODO: Fetch orders from backend
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<DriverOrder> get activeOrders => orders.where((order) => 
    order.status != OrderStatus.delivered && 
    order.status != OrderStatus.cancelled).toList();

  List<DriverOrder> get completedOrders => orders.where((order) => 
    order.status == OrderStatus.delivered || 
    order.status == OrderStatus.cancelled).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Active Orders'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrdersList(activeOrders),
          _buildOrdersList(completedOrders),
        ],
      ),
    );
  }

  Widget _buildOrdersList(List<DriverOrder> ordersList) {
    if (ordersList.isEmpty) {
      return const Center(
        child: Text('No orders found'),
      );
    }

    return ListView.builder(
      itemCount: ordersList.length,
      itemBuilder: (context, index) {
        final order = ordersList[index];
        return _OrderCard(
          order: order,
          onStatusUpdate: _updateOrderStatus,
        );
      },
    );
  }

  Future<void> _updateOrderStatus(DriverOrder order, OrderStatus newStatus) async {
    // TODO: Implement status update logic with backend
    setState(() {
      order.status = newStatus;
    });
  }
}

class _OrderCard extends StatelessWidget {
  final DriverOrder order;
  final Function(DriverOrder order, OrderStatus newStatus) onStatusUpdate;

  const _OrderCard({
    required this.order,
    required this.onStatusUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order.id}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                _buildStatusChip(),
              ],
            ),
            const SizedBox(height: 8),
            _buildAddressSection(
              icon: Icons.location_on,
              label: 'Pickup',
              address: order.pickupAddress,
            ),
            const SizedBox(height: 8),
            _buildAddressSection(
              icon: Icons.flag,
              label: 'Delivery',
              address: order.deliveryAddress,
            ),
            const SizedBox(height: 16),
            _buildCustomerInfo(),
            const SizedBox(height: 16),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    return Chip(
      label: Text(order.status.displayName),
      backgroundColor: _getStatusColor(),
    );
  }

  Color _getStatusColor() {
    switch (order.status) {
      case OrderStatus.newOrder:
        return Colors.blue.shade100;
      case OrderStatus.accepted:
        return Colors.green.shade100;
      case OrderStatus.delivered:
        return Colors.grey.shade100;
      case OrderStatus.cancelled:
        return Colors.red.shade100;
      default:
        return Colors.orange.shade100;
    }
  }

  Widget _buildAddressSection({
    required IconData icon,
    required String label,
    required String address,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Text(address),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerInfo() {
    return Row(
      children: [
        const Icon(Icons.person, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(order.customerName),
              Text(order.customerPhone),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    List<OrderStatus> nextPossibleStatuses = _getNextPossibleStatuses();

    if (nextPossibleStatuses.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            _showStatusUpdateDialog(context, nextPossibleStatuses);
          },
          child: const Text('Update Status'),
        ),
      ],
    );
  }

  List<OrderStatus> _getNextPossibleStatuses() {
    switch (order.status) {
      case OrderStatus.newOrder:
        return [OrderStatus.accepted, OrderStatus.cancelled];
      case OrderStatus.accepted:
        return [OrderStatus.headingToPickup, OrderStatus.cancelled];
      case OrderStatus.headingToPickup:
        return [OrderStatus.arrivedAtPickup, OrderStatus.issue];
      case OrderStatus.arrivedAtPickup:
        return [OrderStatus.pickedUp, OrderStatus.issue];
      case OrderStatus.pickedUp:
        return [OrderStatus.headingToDelivery, OrderStatus.issue];
      case OrderStatus.headingToDelivery:
        return [OrderStatus.arrivedAtDelivery, OrderStatus.issue];
      case OrderStatus.arrivedAtDelivery:
        return [OrderStatus.delivered, OrderStatus.incomplete, OrderStatus.returnToSender];
      default:
        return [];
    }
  }

  void _showStatusUpdateDialog(BuildContext context, List<OrderStatus> possibleStatuses) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Order Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: possibleStatuses.map((status) {
            return ListTile(
              title: Text(status.displayName),
              onTap: () {
                Navigator.of(context).pop();
                onStatusUpdate(order, status);
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
