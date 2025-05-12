import 'package:flutter/material.dart';
import '../../components/custom_button.dart';

class WithdrawScreen extends StatelessWidget {
  const WithdrawScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: const Text(
          'Withdraw Funds',
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFEAEAEA),
                  width: 0.5,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    // Available Balance Card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x0C000000),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Available Balance',
                            style: TextStyle(
                              color: Color(0xFF212121),
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 9),
                          Text(
                            '₦10,000.00',
                            style: TextStyle(
                              color: Color(0xFF212121),
                              fontSize: 26,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Withdraw to section
                    const Text(
                      'Withdraw to',
                      style: TextStyle(
                        color: Color(0xFF212121),
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              color: Color(0xFFD9D9D9),
                              image: DecorationImage(
                                image: NetworkImage("https://via.placeholder.com/48"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 9),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  'ZENITH BANK',
                                  style: TextStyle(
                                    color: Color(0xFF212121),
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  '2345762467',
                                  style: TextStyle(
                                    color: Color(0xFF444444),
                                    fontSize: 14,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios, size: 16),
                            onPressed: () {
                              // TODO: Navigate to bank selection
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Amount to withdraw section
                    const Text(
                      'Amount to withdraw',
                      style: TextStyle(
                        color: Color(0xFF212121),
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 52,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                      child: const TextField(
                        style: TextStyle(
                          color: Color(0xFF444444),
                          fontSize: 16,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '₦10,000.00',
                          hintStyle: TextStyle(
                            color: Color(0xFF444444),
                            fontSize: 16,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: CustomButton(
                text: 'Withdraw Funds',
                onPressed: () {
                  // TODO: Implement withdrawal logic
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}