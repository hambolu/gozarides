import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import 'buyer_wallet_screen.dart';
import 'seller_wallet_screen.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    final user = _mockUser;
    
    if (user.isSeller) {
      return SellerWalletScreen();
    } else {
      return BuyerWalletScreen();
    }
  }
}