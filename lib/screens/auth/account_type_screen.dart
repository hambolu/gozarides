import 'package:flutter/material.dart';
import '../../components/custom_button.dart';
import '../../theme/colors.dart';
import 'business_details_screen.dart';

class AccountTypeScreen extends StatefulWidget {
  const AccountTypeScreen({Key? key}) : super(key: key);

  @override
  State<AccountTypeScreen> createState() => _AccountTypeScreenState();
}

class _AccountTypeScreenState extends State<AccountTypeScreen> {
  String? selectedType;

  void _handleTypeSelection(String type) {
    setState(() {
      selectedType = type;
    });
  }

  void _handleContinue() {
    if (selectedType != null) {
      if (selectedType == 'seller') {
        // Navigate to signup screen with seller type
        Navigator.pushNamed(
          context,
          '/signup',
          arguments: {
            'accountType': 'seller',
          },
        );
      } else {
        // For regular users
        Navigator.pushNamed(
          context,
          '/signup',
          arguments: {
            'accountType': 'buyer',
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Select your account type',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 48),
              _AccountTypeCard(
                title: 'Buyer',
                description: 'Get items delivered to you from a seller',
                isSelected: selectedType == 'buyer',
                onTap: () => _handleTypeSelection('buyer'),
              ),
              const SizedBox(height: 24),
              _AccountTypeCard(
                title: 'Seller',
                description: 'Fulfill orders and get items delivered to buyers',
                isSelected: selectedType == 'seller',
                onTap: () => _handleTypeSelection('seller'),
              ),
              const Spacer(),
              CustomButton(
                text: 'Continue',
                onPressed: selectedType != null ? () => _handleContinue() : () {},
                isSecondary: selectedType == null,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    child: const Text('Login'),
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

class _AccountTypeCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onTap;
  final bool isSelected;

  const _AccountTypeCard({
    Key? key,
    required this.title,
    required this.description,
    required this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.divider),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? AppColors.primary : AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}