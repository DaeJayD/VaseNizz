import 'package:flutter/material.dart';
import 'payment_page.dart';

class CheckoutPage extends StatelessWidget {
  final double subtotal = 17.97;
  final double tax = 17.97;
  final double discount = -9.97;
  final double grandTotal = 17.00;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4E7EC),
      bottomNavigationBar: _buildBottomNavBar(),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.pink[200],
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                children: [
                  const Text(
                    "Checkout",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text("Thofia Concepcion (03085)",
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _buildItemCard("Ex Product 1", 1, 5.99),
            _buildItemCard("Ex Product 2", 2, 5.99),
            const SizedBox(height: 15),
            _buildTotals(context),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(15),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 50)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PaymentPage(
                        subtotal: subtotal,
                        tax: tax,
                        discount: discount,
                        total: grandTotal,
                      ),
                    ),
                  );
                },
                child: const Text("CHARGE"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(String name, int qty, double price) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: ListTile(
        title: Text(name),
        subtitle: Text("${qty}x ₱${price.toStringAsFixed(2)}"),
        trailing: Text(
          "₱${(qty * price).toStringAsFixed(2)}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildTotals(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            _buildRow("Subtotal", subtotal),
            _buildRow("Tax @ ?", tax),
            _buildRow("Discount", discount, color: Colors.red),
            const Divider(),
            _buildRow("Grand Total", grandTotal, isBold: true),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, double value,
      {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
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

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.redAccent,
      unselectedItemColor: Colors.black54,
      currentIndex: 1,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Sales"),
        BottomNavigationBarItem(icon: Icon(Icons.inventory), label: "Inventory"),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Report"),
        BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: "More"),
      ],
    );
  }
}
