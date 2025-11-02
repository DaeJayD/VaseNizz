import 'package:flutter/material.dart';
import 'package:vasenizzpos/products/brand_products_page.dart';
import 'payment_page.dart';
import 'make_a_sale.dart';

class CheckoutPage extends StatefulWidget {
  final String fullName;
  final String role;
  final List<Map<String, dynamic>> cartItems;
  final String? change;
  final String? cashGiven;
  final String userId;
  final String location;

  const CheckoutPage({
    Key? key,
    required this.cartItems,
    required this.role,
    required this.fullName,
    required this.userId,
    required this.location,
    this.cashGiven = '',
    this.change = '',
  }) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late List<Map<String, dynamic>> cartItems;
  double discountPercent = 0.0;

  @override
  void initState() {
    super.initState();
    cartItems = List<Map<String, dynamic>>.from(widget.cartItems);
  }

  double get subtotal =>
      cartItems.fold(0, (sum, item) => sum + (item['price'] * (item['cart_quantity'] ?? 1)));

  double get tax => subtotal * 0.12;
  double get discount => subtotal * (discountPercent / 100);
  double get grandTotal => subtotal + tax - discount;

  void _updateQuantity(Map<String, dynamic> item, int change) {
    final int currentQty = item['cart_quantity'] ?? 1;
    final int newQty = currentQty + change;

    if (newQty < 1) {
      setState(() => cartItems.removeWhere((cartItem) => cartItem['id'] == item['id']));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${item['name']} removed from cart'),
        backgroundColor: Colors.orange,
      ));
    } else if (newQty > (item['stock'] ?? 0)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Cannot add more than available stock (${item['stock']})'),
        backgroundColor: Colors.red,
      ));
    } else {
      setState(() {
        final index = cartItems.indexWhere((cartItem) => cartItem['id'] == item['id']);
        if (index != -1) {
          cartItems[index]['cart_quantity'] = newQty;
        }
      });
    }
  }

  void _showDiscountDialog() async {
    final controller = TextEditingController();
    final percent = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("Add Discount (%)"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: "Enter discount percentage",
            prefixText: "%",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pinkAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              final value = double.tryParse(controller.text.trim());
              if (value != null && value >= 0 && value <= 100) {
                Navigator.pop(context, value);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Enter a valid percentage (0–100)")),
                );
              }
            },
            child: const Text("Apply"),
          ),
        ],
      ),
    );

    if (percent != null) {
      setState(() => discountPercent = percent);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Discount of ${percent.toStringAsFixed(1)}% applied."),
        backgroundColor: Colors.green,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8E4EC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8C8D9),
        elevation: 0,
        toolbarHeight: 65,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Checkout",
              style: TextStyle(
                fontFamily: 'Cardo',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            Text(
              "${widget.fullName} (${widget.role})",
              style: const TextStyle(fontFamily: 'Cardo', fontSize: 13, color: Colors.white70),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: cartItems.isEmpty
                  ? _buildEmptyCart()
                  : SingleChildScrollView(
                child: Column(
                  children: [
                    ...cartItems.map((item) => _buildItemCard(item)),
                    _buildAddNewItemButton(),
                    const SizedBox(height: 15),
                    _buildTotals(),
                    _buildDiscountButton(),
                  ],
                ),
              ),
            ),
            if (cartItems.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(15),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade400,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PaymentPage(
                          cashGiven: 'cashGiven',
                          change: '',
                          fullName: widget.fullName,
                          role: widget.role,
                          cartItems: cartItems,
                          subtotal: subtotal,
                          tax: tax,
                          discount: discount,
                          total: grandTotal,
                          userId: widget.userId,
                          location: widget.location,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "Proceed to Payment",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
        const SizedBox(height: 16),
        const Text('Your cart is empty',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 18, color: Colors.grey)),
        const SizedBox(height: 8),
        const Text('Add products to proceed with checkout',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.grey)),
        const SizedBox(height: 30),
        _buildAddNewItemButton(),
      ],
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item) {
    final name = item['name'] ?? 'Unknown';
    final qty = item['cart_quantity'] ?? 1;
    final price = item['price'] ?? 0.0;
    final total = qty * price;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F2F6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.shopping_bag_outlined, size: 36, color: Colors.black54),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 4),
                Text("₱${price.toStringAsFixed(2)} each",
                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove, size: 18),
                onPressed: () => _updateQuantity(item, -1),
              ),
              Text(qty.toString(),
                  style: const TextStyle(
                      fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 14)),
              IconButton(
                icon: const Icon(Icons.add, size: 18),
                onPressed: () => _updateQuantity(item, 1),
              ),
            ],
          ),
          SizedBox(
            width: 70,
            child: Text("₱${total.toStringAsFixed(2)}",
                textAlign: TextAlign.right,
                style: const TextStyle(
                    fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Widget _buildAddNewItemButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => MakeASale(
                fullName: widget.fullName,
                role: widget.role,
                existingCart: cartItems,
                userId: widget.userId,
                location: widget.location,
              ),
            ),
                (route) => false,
          );
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "ADD NEW ITEM",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF8C8D9),
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildDiscountButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: ElevatedButton.icon(
        onPressed: _showDiscountDialog,
        icon: const Icon(Icons.percent_rounded, color: Colors.white),
        label: const Text(
          "ADD DISCOUNT (%)",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pinkAccent,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildTotals() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          _buildRow("Subtotal", subtotal),
          _buildRow("Tax (12%)", tax),
          if (discountPercent > 0)
            _buildRow("Discount (${discountPercent.toStringAsFixed(1)}%)", -discount,
                color: Colors.green),
          const Divider(),
          _buildRow("Total", grandTotal, isBold: true, color: Colors.pinkAccent),
        ],
      ),
    );
  }

  Widget _buildRow(String label, double value, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: isBold ? 15 : 14,
                fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
              )),
          Text("₱${value.toStringAsFixed(2)}",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: isBold ? 16 : 14,
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
                color: color ?? Colors.black87,
              )),
        ],
      ),
    );
  }
}
