import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../components/custom_button.dart';
import '../../services/payment_service.dart';

enum PaymentMethod { debitCard, bankTransfer }

class AddFundsScreen extends StatefulWidget {
  const AddFundsScreen({Key? key}) : super(key: key);

  @override
  State<AddFundsScreen> createState() => _AddFundsScreenState();
}

class _AddFundsScreenState extends State<AddFundsScreen> {
  PaymentMethod _selectedPaymentMethod = PaymentMethod.debitCard;
  final TextEditingController _amountController = TextEditingController(text: '15,000.00');

  void _processPayment() async {
    try {
      final paymentService = Provider.of<PaymentService>(context, listen: false);
      final amount = double.parse(_amountController.text.replaceAll(',', ''));
      
      await paymentService.initializePayment(
        context: context,
        amount: amount,
        paymentMethod: _selectedPaymentMethod.toString().split('.').last,
        paymentDetails: {}, // Add any additional payment details here
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to process payment: $e')),
      );
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Widget _buildBankTransferSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          'Transfer to the account below to fund your wallet.',
          style: TextStyle(
            color: Color(0xFF212121),
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 25),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Bank Name',
                    style: TextStyle(
                      color: Color(0xFF444444),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    'Wema Bank',
                    style: TextStyle(
                      color: Color(0xFF212121),
                      fontSize: 16,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Account Number',
                    style: TextStyle(
                      color: Color(0xFF444444),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Row(
                    children: [
                      const Text(
                        '0123456789',
                        style: TextStyle(
                          color: Color(0xFF212121),
                          fontSize: 16,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          // TODO: Implement copy functionality
                        },
                        child: const Icon(
                          Icons.copy_rounded,
                          size: 20,
                          color: Color(0xFFF42B4E),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Account Name',
                    style: TextStyle(
                      color: Color(0xFF444444),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    'QUIKRIDE',
                    style: TextStyle(
                      color: Color(0xFF212121),
                      fontSize: 16,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
          decoration: ShapeDecoration(
            color: const Color(0xFFFDEEEF),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Expanded(
                child: Text(
                  'Make sure the name on the sending account matches your profile. Your wallet will be credited automatically within a few minutes after the transfer.',
                  style: TextStyle(
                    color: Color(0xFF444444),
                    fontSize: 12,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDebitCardSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          'Choose a card or add a new one',
          style: TextStyle(
            color: Color(0xFF212121),
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Color(0xFFE0E0E0)),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            children: const [
              Icon(Icons.add_circle_outline, color: Color(0xFFF42B4E)),
              SizedBox(width: 12),
              Text(
                'Add New Card',
                style: TextStyle(
                  color: Color(0xFF212121),
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method',
          style: TextStyle(
            color: Color(0xFF212121),
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 48,
          padding: const EdgeInsets.all(4),
          decoration: ShapeDecoration(
            color: const Color(0xFFF5F5F5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() {
                    _selectedPaymentMethod = PaymentMethod.debitCard;
                  }),
                  child: Container(
                    height: double.infinity,
                    decoration: ShapeDecoration(
                      color: _selectedPaymentMethod == PaymentMethod.debitCard ? Colors.white : Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      shadows: _selectedPaymentMethod == PaymentMethod.debitCard
                          ? [
                              const BoxShadow(
                                color: Color(0x0C000000),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                                spreadRadius: 0,
                              )
                            ]
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Debit Card',
                      style: TextStyle(
                        color: _selectedPaymentMethod == PaymentMethod.debitCard ? const Color(0xFF212121) : const Color(0xFF757575),
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() {
                    _selectedPaymentMethod = PaymentMethod.bankTransfer;
                  }),
                  child: Container(
                    height: double.infinity,
                    decoration: ShapeDecoration(
                      color: _selectedPaymentMethod == PaymentMethod.bankTransfer ? Colors.white : Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      shadows: _selectedPaymentMethod == PaymentMethod.bankTransfer
                          ? [
                              const BoxShadow(
                                color: Color(0x0C000000),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                                spreadRadius: 0,
                              )
                            ]
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Bank Transfer',
                      style: TextStyle(
                        color: _selectedPaymentMethod == PaymentMethod.bankTransfer ? const Color(0xFF212121) : const Color(0xFF757575),
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleCardPayment() async {
    try {
      final amount = double.tryParse(_amountController.text.replaceAll(',', '')) ?? 0.0;

      if (amount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid amount')),
        );
        return;
      }

      // Get the current user's ID from auth provider
      final user = context.read<AuthProvider>().firebaseUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in to add funds')),
        );
        return;
      }

      // Add funds to wallet using WalletProvider
      await context.read<WalletProvider>().addFunds(
        user.uid,
        amount,
      );

      // Show success message and navigate back
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment successful')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  void _handleBankTransfer() async {
    // For bank transfer, we can just show a success message since the actual credit
    // will happen when the bank transfer is confirmed
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Your wallet will be credited once the transfer is confirmed'),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Funds',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  // Amount Input
                  Row(
                    children: [
                      const Text(
                        'Amount',
                        style: TextStyle(
                          color: Color(0xFF212121),
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          // TODO: Implement pasting functionality
                        },
                        child: const Icon(
                          Icons.paste_rounded,
                          size: 20,
                          color: Color(0xFFF42B4E),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Color(0xFFE0E0E0)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        color: Color(0xFF212121),
                        fontSize: 16,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: InputBorder.none,
                        hintText: 'Enter amount',
                        hintStyle: TextStyle(
                          color: Color(0xFF9E9E9E),
                          fontSize: 16,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w400,
                        ),
                        prefixText: '₦ ',
                        prefixStyle: TextStyle(
                          color: Color(0xFF212121),
                          fontSize: 16,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Payment Method Selector
                  _buildPaymentMethodSelector(),

                  // Main Content Section
                  _selectedPaymentMethod == PaymentMethod.debitCard ? _buildDebitCardSection() : _buildBankTransferSection(),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x0C000000),
                  blurRadius: 24,
                  offset: Offset(0, -4),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: CustomButton(
              text: _selectedPaymentMethod == PaymentMethod.debitCard 
                  ? 'Continue' 
                  : "I've made the transfer",
              onPressed: () {
                if (_selectedPaymentMethod == PaymentMethod.debitCard) {
                  _handleCardPayment();
                } else {
                  _handleBankTransfer();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}