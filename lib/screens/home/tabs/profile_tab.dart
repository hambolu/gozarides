import 'package:flutter/material.dart';
import '../../../theme/colors.dart';
import '../../../screens/wallet/transaction_history_screen.dart';
import '../../../screens/profile/personal_data_screen.dart';
import '../../../screens/profile/get_verified_screen.dart';
import '../../../screens/profile/notification_preferences_screen.dart';
import '../../../screens/profile/privacy_security_screen.dart';
import '../../../screens/profile/help_center_screen.dart';
import '../../../screens/wallet/wallet_screen.dart';
import '../../../models/user_model.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({Key? key}) : super(key: key);

  // TODO: Replace with actual user data from state management
  UserModel get _mockUser => const UserModel(
    id: '24576353553',
    name: 'Johnny John',
    email: 'johnny@email.com',
    phone: '090213895748',
    userType: UserType.seller,
    verificationStatus: VerificationStatus.unverified,
    businessName: 'Johnny John Accessories'
  );

  Widget _buildVerificationCard(BuildContext context, UserModel user) {
    if (!user.isSeller) return const SizedBox.shrink();

    if (user.isVerified) {
      return _buildCard(
        title: 'Verified Seller',
        description: 'Your account has been successfully verified.',
        icon: Icons.verified_user,
      );
    } else if (user.isVerificationPending) {
      return _buildCard(
        title: 'Verification Pending',
        description: 'Your verification request is being processed.',
        icon: Icons.pending_outlined,
      );
    } else {
      return GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GetVerifiedScreen()),
        ),
        child: _buildCard(
          title: 'Get Verified',
          description: 'Verify your account to unlock more features',
          icon: Icons.verified_outlined,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _mockUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border(
                  bottom: BorderSide(
                    color: const Color(0xFFEAEAEA),
                    width: 0.5,
                  ),
                ),
              ),
              padding: const EdgeInsets.only(top: 60, bottom: 20),
              child: const Text(
                'Profile',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            
            // Profile Section
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Profile Info
                  Row(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 54,
                            height: 54,
                            decoration: const ShapeDecoration(
                              color: AppColors.surface,
                              shape: OvalBorder(),
                            ),
                          ),
                          Container(
                            width: 80,
                            height: 120,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage("https://placehold.co/80x120"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                              color: AppColors.text,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (user.isSeller) Text(
                            'Seller ID: ${user.id}',
                            style: const TextStyle(
                              color: Color(0xFF444444),
                              fontSize: 14,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          if (user.isSeller && user.isVerified) ...[
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                ...List.generate(5, (index) => Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: Icon(
                                    Icons.star,
                                    size: 14,
                                    color: AppColors.primary,
                                  ),
                                )),
                                const SizedBox(width: 8),
                                const Text(
                                  '(100 verified ratings)',
                                  style: TextStyle(
                                    color: Color(0xFF666666),
                                    fontSize: 10,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Verification Status Card (only for sellers)
                  _buildVerificationCard(context, user),

                  const SizedBox(height: 16),

                  // Personal Data Card
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PersonalDataScreen()),
                    ),
                    child: _buildCard(
                      title: 'Personal Data',
                      description: 'Edit Profile picture, DOB, and other Personal details',
                      icon: Icons.person_outline,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Financial Section
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(7),
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
                        _buildListTile(
                          title: 'My Wallet',
                          icon: Icons.account_balance_wallet_outlined,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WalletScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        if (user.isSeller) ...[
                          _buildListTile(
                            title: 'Payout Method',
                            icon: Icons.payment_outlined,
                          ),
                          _buildDivider(),
                        ],
                        _buildListTile(
                          title: 'Transaction History',
                          icon: Icons.history,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TransactionHistoryScreen(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Settings Section
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(7),
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
                        _buildListTile(
                          title: 'Notification Preferences',
                          icon: Icons.notifications_outlined,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationPreferencesScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildListTile(
                          title: 'Privacy and Security Settings',
                          icon: Icons.security_outlined,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PrivacySecurityScreen(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Support Section
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(7),
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
                        _buildListTile(
                          title: 'Help Center / Contact Support',
                          icon: Icons.help_outline,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HelpCenterScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildListTile(
                          title: 'Logout',
                          icon: Icons.logout,
                          onTap: () {
                            // TODO: Implement logout
                          },
                        ),
                      ],
                    ),
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

  Widget _buildCard({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(7),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.text),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required String title,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.text),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.text,
          fontSize: 14,
          fontFamily: 'Lato',
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppColors.textSecondary,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 50),
      child: Container(
        decoration: const ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 0.50,
              color: Color(0xFFEAEAEA),
            ),
          ),
        ),
      ),
    );
  }
}