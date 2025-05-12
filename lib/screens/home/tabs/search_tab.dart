import 'package:flutter/material.dart';
import '../../../theme/colors.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({Key? key}) : super(key: key);

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search orders or sellers...',
            hintStyle: const TextStyle(
              color: Color(0xFFAAAAAA),
              fontSize: 14,
              fontFamily: 'Lato',
            ),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.search, color: AppColors.primary),
              onPressed: () {
                // Implement search functionality
              },
            ),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: const Color(0xFF666666),
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Orders'),
            Tab(text: 'Sellers'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrdersList(),
          _buildSellersList(),
        ],
      ),
    );
  }

  Widget _buildOrdersList() {
    // Mock orders data
    final orders = [
      {
        'id': '1',
        'productDetails': 'iPhone 13 Pro Max',
        'amount': '₦950,000',
        'status': 'Delivered',
        'date': '10 May, 2025',
      },
      {
        'id': '2',
        'productDetails': 'MacBook Pro M1',
        'amount': '₦1,450,000',
        'status': 'Processing',
        'date': '9 May, 2025',
      },
    ];

    return ListView.builder(
      itemCount: orders.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final order = orders[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/order-details', arguments: order['id']);
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order['amount']!,
                      style: const TextStyle(
                        color: AppColors.text,
                        fontSize: 14,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w600,
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
                const SizedBox(height: 8),
                Text(
                  order['date']!,
                  style: const TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 12,
                    fontFamily: 'Lato',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSellersList() {
    // Mock sellers data
    final sellers = [
      {
        'id': '1',
        'name': 'John\'s Electronics',
        'rating': 4.8,
        'reviews': 120,
        'isVerified': true,
      },
      {
        'id': '2',
        'name': 'Fashion Hub',
        'rating': 4.5,
        'reviews': 85,
        'isVerified': true,
      },
    ];

    return ListView.builder(
      itemCount: sellers.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final seller = sellers[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
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
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(Icons.store, color: AppColors.text),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          seller['name'] as String,
                          style: const TextStyle(
                            color: AppColors.text,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (seller['isVerified'] as bool) ...[
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.verified,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 16,
                          color: Color(0xFFFBBF24),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${seller['rating']} (${seller['reviews']} reviews)',
                          style: const TextStyle(
                            color: Color(0xFF666666),
                            fontSize: 12,
                            fontFamily: 'Lato',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 16),
                onPressed: () {
                  Navigator.pushNamed(context, '/seller-details', arguments: seller['id']);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}