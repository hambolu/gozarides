import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../services/auth_bloc.dart';
import 'buyer_wallet_screen.dart';
import 'seller_wallet_screen.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthBloc>(
      builder: (context, authBloc, _) {
        final user = authBloc.currentUser;
        if (user == null) return const Center(child: CircularProgressIndicator());
    
    if (user.isSeller) {
      return SellerWalletScreen();
    } else {
      return BuyerWalletScreen();
    }
      },
    );
  }
}