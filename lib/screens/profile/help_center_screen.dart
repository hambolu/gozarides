import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({Key? key}) : super(key: key);

  Widget _buildFAQSection({
    required String title,
    required List<FAQItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            fontFamily: 'Lato',
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        ...items.map((item) => _FAQExpansionTile(item: item)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        centerTitle: true,
        title: const Text(
          'Help Center',
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contact Support Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0C000000),
                      blurRadius: 12,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Need help with something?',
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Our support team is here to help',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        fontFamily: 'Lato',
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Implement contact support
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Contact Support',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // FAQ Sections
              _buildFAQSection(
                title: 'Account & Profile',
                items: [
                  FAQItem(
                    question: 'How do I change my password?',
                    answer: 'Go to Profile > Privacy & Security > Change Password. Follow the prompts to set a new password.',
                  ),
                  FAQItem(
                    question: 'How do I get verified as a seller?',
                    answer: 'Navigate to Profile > Get Verified and follow the verification process by providing the required documents.',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildFAQSection(
                title: 'Orders & Payments',
                items: [
                  FAQItem(
                    question: 'How do I track my order?',
                    answer: 'Go to Orders tab and select the order you want to track. You\'ll see real-time updates on your order status.',
                  ),
                  FAQItem(
                    question: 'What payment methods are accepted?',
                    answer: 'We accept debit cards, credit cards, and wallet balance for all transactions.',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildFAQSection(
                title: 'Technical Support',
                items: [
                  FAQItem(
                    question: 'App is not working properly',
                    answer: 'Try clearing the app cache or reinstalling the app. If the issue persists, contact our support team.',
                  ),
                  FAQItem(
                    question: 'How do I update the app?',
                    answer: 'Visit your device\'s app store and check for updates. Enable auto-updates to always have the latest version.',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}

class _FAQExpansionTile extends StatelessWidget {
  final FAQItem item;

  const _FAQExpansionTile({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        title: Text(
          item.question,
          style: const TextStyle(
            color: AppColors.text,
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              item.answer,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontFamily: 'Lato',
              ),
            ),
          ),
        ],
      ),
    );
  }
}