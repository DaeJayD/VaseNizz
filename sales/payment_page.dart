import 'package:flutter/material.dart';
import 'receipt_page.dart';

class PaymentPage extends StatelessWidget {
  final double subtotal;
  final double tax;
  final double discount;
  final double total;

  const PaymentPage({
    super.key,
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
            Container(
              width: double.infinity,
              color: Colors.pink[200],
              padding: const EdgeInsets.all(20),
              child: const Text(
                "Select Payment Method",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(15),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _paymentCard(context, "CASH", Icons.payments, "Cash"),
                  _paymentCard(context, "GCASH", Icons.account_balance_wallet, "GCash"),
                  _paymentCard(context, "BANK", Icons.account_balance, "Bank"),
                  _paymentCard(context, "CARD", Icons.credit_card, "Card"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentCard(
      BuildContext context, String label, IconData icon, String method) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ReceiptPage(
              paymentMethod: method,
              subtotal: subtotal,
              tax: tax,
              discount: discount,
              total: total,
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: Colors.pinkAccent),
              const SizedBox(height: 10),
              Text(label,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
