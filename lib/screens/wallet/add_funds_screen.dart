import 'package:flutter/material.dart';

class AddFundsScreen extends StatefulWidget {
  const AddFundsScreen({Key? key}) : super(key: key);

  @override
  State<AddFundsScreen> createState() => _AddFundsScreenState();
}

class _AddFundsScreenState extends State<AddFundsScreen> {
  bool _isDebitCardSelected = true;
  final TextEditingController _amountController = TextEditingController(text: '₦15,000.00');

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
          child: Wrap(
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 12,
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
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Color(0xFF212121),
                  fontSize: 16,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: 145,
                child: Text(
                  'Account Number',
                  style: TextStyle(
                    color: Color(0xFF444444),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(
                width: 93.90,
                child: Text(
                  '0123456789',
                  style: TextStyle(
                    color: Color(0xFF212121),
                    fontSize: 16,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
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
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Color(0xFF212121),
                  fontSize: 16,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w500,
                ),
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
          child: const Text(
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
    );
  }

  Widget _buildDebitCardSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          'Select a Bank Card',
          style: TextStyle(
            color: Color(0xFF212121),
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Column(
            children: [
              // Mastercard
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        border: Border.all(),
                      ),
                      child: Image.network(
                        "https://placehold.co/54x36",
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Mastercard',
                            style: TextStyle(
                              color: Color(0xFF212121),
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            '**** **** **** 3456',
                            style: TextStyle(
                              color: Color(0xFF212121),
                              fontSize: 14,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Radio<bool>(
                      value: true,
                      groupValue: true,
                      onChanged: (value) {},
                      activeColor: const Color(0xFFE63946),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFFEAEAEA)),
              // Visa Card
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        border: Border.all(),
                      ),
                      child: Image.network(
                        "https://placehold.co/54x36",
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Visa',
                            style: TextStyle(
                              color: Color(0xFF212121),
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            '**** **** **** 3456',
                            style: TextStyle(
                              color: Color(0xFF212121),
                              fontSize: 14,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Radio<bool>(
                      value: false,
                      groupValue: true,
                      onChanged: (value) {},
                      activeColor: const Color(0xFFE63946),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Add Card Button
        Container(
          width: double.infinity,
          height: 63,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Color(0xFFE63946)),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Center(
            child: Text(
              'Add Bank Card',
              style: TextStyle(
                color: Color(0xFFE63946),
                fontSize: 14,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Amount',
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
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: TextField(
            controller: _amountController,
            style: const TextStyle(
              color: Color(0xFF444444),
              fontSize: 16,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w600,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: const Text(
          'Add Funds',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF212121),
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Payment Method Selector
                  Container(
                    width: double.infinity,
                    height: 36,
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _isDebitCardSelected = true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 1),
                              decoration: ShapeDecoration(
                                color: _isDebitCardSelected ? const Color(0xFFE63946) : Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 1,
                                    color: _isDebitCardSelected ? const Color(0xFFE63946) : const Color(0xFF777777),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Debit Card',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: _isDebitCardSelected ? Colors.white : const Color(0xFF777777),
                                    fontSize: 14,
                                    fontFamily: 'Lato',
                                    fontWeight: _isDebitCardSelected ? FontWeight.w600 : FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _isDebitCardSelected = false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 1),
                              decoration: ShapeDecoration(
                                color: !_isDebitCardSelected ? const Color(0xFFE63946) : Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 1,
                                    color: !_isDebitCardSelected ? const Color(0xFFE63946) : const Color(0xFF777777),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Bank Transfer',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: !_isDebitCardSelected ? Colors.white : const Color(0xFF777777),
                                    fontSize: 14,
                                    fontFamily: 'Lato',
                                    fontWeight: !_isDebitCardSelected ? FontWeight.w600 : FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Main Content Section
                  _isDebitCardSelected ? _buildDebitCardSection() : _buildBankTransferSection(),
                ],
              ),
            ),
          ),
          // Continue Button at bottom
          Positioned(
            left: 16,
            right: 16,
            bottom: 30,
            child: GestureDetector(
              onTap: () {
                // TODO: Implement continue action
              },
              child: Container(
                height: 56,
                decoration: ShapeDecoration(
                  color: const Color(0xFFE63946),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Center(
                  child: Text(
                    _isDebitCardSelected ? 'Continue' : "I've made the transfer",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}