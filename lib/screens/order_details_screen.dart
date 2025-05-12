import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../components/custom_button.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String orderId;
  
  const OrderDetailsScreen({
    Key? key,
    required this.orderId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mock order data - In production, this would be fetched using the orderId
    final order = {
      'id': orderId,
      'productDetails': 'iPhone 13 Pro Max',
      'amount': '₦950,000',
      'status': 'Delivered',
      'date': '10 May, 2025',
      'sellerName': 'John\'s Electronics',
      'deliveryAddress': '123 Main Street, Lagos',
      'paymentMethod': 'Wallet Balance',
    };

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        centerTitle: true,
        title: const Text(
          'Order Details',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailCard(
              order: order,
              onMessageSeller: () {
                // TODO: Navigate to chat with seller
              },
            ),
            const SizedBox(height: 16),
            _buildStatusCard(),
            const SizedBox(height: 16),
            _buildDeliveryDetails(order),
            const SizedBox(height: 16),
            _buildPaymentDetails(order),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required Map<String, String> order,
    required VoidCallback onMessageSeller,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order #${order['id']}',
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: order['status'] == 'Delivered'
                      ? const Color(0xFFDFF5E3)
                      : const Color(0xFFFFF8E5),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  order['status']!,
                  style: TextStyle(
                    color: order['status'] == 'Delivered'
                        ? const Color(0xFF2F855A)
                        : const Color(0xFFB7791F),
                    fontSize: 12,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            order['productDetails']!,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            order['amount']!,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 14,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Seller',
                    style: TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 12,
                      fontFamily: 'Lato',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order['sellerName']!,
                    style: const TextStyle(
                      color: AppColors.text,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: onMessageSeller,
                child: Row(
                  children: const [
                    Icon(Icons.message, size: 16, color: AppColors.primary),
                    SizedBox(width: 4),
                    Text(
                      'Message',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 14,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Status',
            style: TextStyle(
              color: AppColors.text,
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          _buildStatusStep(
            title: 'Order Placed',
            time: '10:30 AM',
            isCompleted: true,
            isLast: false,
          ),
          _buildStatusStep(
            title: 'Order Confirmed',
            time: '11:00 AM',
            isCompleted: true,
            isLast: false,
          ),
          _buildStatusStep(
            title: 'Order Shipped',
            time: '2:30 PM',
            isCompleted: true,
            isLast: false,
          ),
          _buildStatusStep(
            title: 'Order Delivered',
            time: '5:45 PM',
            isCompleted: true,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusStep({
    required String title,
    required String time,
    required bool isCompleted,
    required bool isLast,
  }) {
    return Row(
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted ? AppColors.primary : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted ? AppColors.primary : const Color(0xFFE5E5E5),
                ),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 32,
                color: isCompleted ? AppColors.primary : const Color(0xFFE5E5E5),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isCompleted ? AppColors.text : const Color(0xFF666666),
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                time,
                style: const TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 12,
                  fontFamily: 'Lato',
                ),
              ),
              if (!isLast) const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryDetails(Map<String, String> order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Delivery Details',
            style: TextStyle(
              color: AppColors.text,
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            order['deliveryAddress']!,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 14,
              fontFamily: 'Lato',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDetails(Map<String, String> order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Details',
            style: TextStyle(
              color: AppColors.text,
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Payment Method',
                style: TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 14,
                  fontFamily: 'Lato',
                ),
              ),
              Text(
                order['paymentMethod']!,
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 14,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Amount',
                style: TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 14,
                  fontFamily: 'Lato',
                ),
              ),
              Text(
                order['amount']!,
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 14,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}