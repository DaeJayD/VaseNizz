import 'package:flutter/material.dart';
import 'package:vasenizzpos/dashboard/home_screen.dart';
import 'package:vasenizzpos/sales/make_a_sale.dart';

class ReceiptPage extends StatelessWidget {
  final String paymentMethod;
  final double subtotal;
  final double tax;
  final double discount;
  final double total;

  const ReceiptPage({
    super.key,
    required this.paymentMethod,
    required this.subtotal,
    required this.tax,
    required this.discount,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4E7EC),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: Colors.pink[200],
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              child: const Text(
                "Transaction Complete!!",
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Receipt details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "VASENIZZ BEAUTY SHOP",
                          style: TextStyle(
                            color: Colors.pink,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text("Payment Mode: $paymentMethod"),
                        const Divider(),
                        _row("Subtotal", subtotal),
                        _row("Tax", tax),
                        _row("Discount", discount, color: Colors.red),
                        const Divider(),
                        _row("Grand Total", total, isBold: true),
                        const Spacer(),

                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MakeASale(
                                  username: 'Cashier', // or use your logged-in name
                                ),
                              ),
                                  (route) => false,
                            );

                            // ✅ Optional success toast/snackbar
                            Future.delayed(const Duration(milliseconds: 300), () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Transaction completed successfully!",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  backgroundColor: Colors.green,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 80, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "PROCEED",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, double value,
      {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            "₱${value.toStringAsFixed(2)}",
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
