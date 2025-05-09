import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class PersonalDataScreen extends StatelessWidget {
  const PersonalDataScreen({Key? key}) : super(key: key);

  Widget _buildInfoField({
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
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
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 13),
          decoration: ShapeDecoration(
            color: AppColors.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w400,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
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
        title: Text(
          'Personal Data',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            // Profile Image Section
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: const ShapeDecoration(
                      image: DecorationImage(
                        image: NetworkImage("https://placehold.co/120x120"),
                        fit: BoxFit.cover,
                      ),
                      shape: OvalBorder(),
                    ),
                  ),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: ShapeDecoration(
                      color: AppColors.primary,
                      shape: const OvalBorder(),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Personal Information Fields
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildInfoField(
                    label: 'Full Name',
                    value: 'Johnny John',
                  ),
                  const SizedBox(height: 35),
                  _buildInfoField(
                    label: 'Business Name',
                    value: 'Johnny John Accessories',
                  ),
                  const SizedBox(height: 35),
                  _buildInfoField(
                    label: 'Email',
                    value: 'johnny@email.com',
                  ),
                  const SizedBox(height: 35),
                  _buildInfoField(
                    label: 'Phone Number',
                    value: '090213895748',
                  ),
                  const SizedBox(height: 35),
                  _buildInfoField(
                    label: 'Date Of Birth',
                    value: '22/05',
                  ),
                  const SizedBox(height: 35),
                  _buildInfoField(
                    label: 'Business Address',
                    value: '18, Kanle Street, Ikeja, Lagos',
                  ),
                  const SizedBox(height: 35),
                  _buildInfoField(
                    label: 'Social Media link (Instagram)',
                    value: 'https://instagram.com/johnnyaccessories',
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}