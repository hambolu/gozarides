import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/custom_button.dart';
import '../../components/custom_text_field.dart';
import '../../theme/colors.dart';
import '../../providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BusinessDetailsScreen extends StatefulWidget {
  const BusinessDetailsScreen({Key? key}) : super(key: key);

  @override
  State<BusinessDetailsScreen> createState() => _BusinessDetailsScreenState();
}

class _BusinessDetailsScreenState extends State<BusinessDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _businessNameController = TextEditingController();
  final _businessAddressController = TextEditingController();
  final _businessDescriptionController = TextEditingController();
  String? _selectedCategory;
  bool _isLoading = false;
  String? _errorMessage;

  final List<String> _categories = [
    'Retail',
    'Food & Beverages',
    'Fashion & Apparel',
    'Electronics',
    'Health & Beauty',
    'Other'
  ];

  @override
  void dispose() {
    _businessNameController.dispose();
    _businessAddressController.dispose();
    _businessDescriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate() || _selectedCategory == null) {
      if (_selectedCategory == null) {
        setState(() {
          _errorMessage = 'Please select a business category';
        });
      }
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final provider = context.read<AuthProvider>();
      
      // Update the business details in Firestore
      await provider.updateUserProfile({
        'businessName': _businessNameController.text.trim(),
        'businessAddress': _businessAddressController.text.trim(),
        'businessDescription': _businessDescriptionController.text.trim(),
        'businessCategory': _selectedCategory,
        'userType': 'seller',
        'isVerified': false,
      });

      // Start phone verification process
      final user = provider.firebaseUser;
      if (user != null) {
        await provider.verifyPhoneNumber(
          phoneNumber: user.phoneNumber ?? '',
        );

        if (mounted) {
          Navigator.pushNamed(
            context, 
            '/otp-verification',
            arguments: {
              'phoneNumber': user.phoneNumber ?? '',
              'verificationId': provider.verificationId!,
            },
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'Failed to update business details';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Tell us about your business',
                        style: TextStyle(
                          color: AppColors.text,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  CustomTextField(
                    label: 'Business Name',
                    controller: _businessNameController,
                    hint: 'Enter your business name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your business name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Business Category',
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: ShapeDecoration(
                      color: AppColors.background,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: AppColors.divider),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCategory,
                        hint: const Text(
                          'Select your business category',
                          style: TextStyle(
                            color: Color(0xFFAAAAAA),
                            fontSize: 14,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        items: _categories.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    label: 'Business Address',
                    controller: _businessAddressController,
                    hint: 'Enter your business address',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your business address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    label: 'Business Description',
                    controller: _businessDescriptionController,
                    hint: 'Tell us a little about your business',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your business description';
                      }
                      return null;
                    },
                  ),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage!,
                      style: const TextStyle(
                        color: AppColors.error,
                        fontSize: 14,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Create Account',
                    onPressed: _isLoading ? null : _handleSubmit,
                    isLoading: _isLoading,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}