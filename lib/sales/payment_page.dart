import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'receipt_page.dart';

class PaymentPage extends StatefulWidget {
  final String fullName;
  final String role;
  final List<Map<String, dynamic>> cartItems;
  final double subtotal;
  final double tax;
  final double discount;
  final double total;
  final String change;
  final String cashGiven;
  final String userId;
  final String location;

  const PaymentPage({
    super.key,
    required this.cashGiven,
    required this.change,
    required this.fullName,
    required this.role,
    required this.cartItems,
    required this.subtotal,
    required this.tax,
    required this.discount,
    required this.total,
    required this.userId,
    required this.location,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController _cashController = TextEditingController();
  double _cashGiven = 0.0;
  double _change = 0.0;

  void _calculateChange() {
    setState(() {
      _cashGiven = double.tryParse(_cashController.text) ?? 0.0;
      _change = _cashGiven - widget.total;
    });
  }

  Future<void> _processPayment(BuildContext context, String paymentMethod) async {
    try {
      if (paymentMethod == "Cash" && _cashGiven < widget.total) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Insufficient cash given!"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      final saleResponse = await Supabase.instance.client
          .from('sales')
          .insert({
        'total_amount': widget.total,
        'subtotal_amount': widget.subtotal,
        'tax_amount': widget.tax,
        'discount_amount': widget.discount,
        'payment_method': paymentMethod.toLowerCase(),
        'created_at': DateTime.now().toIso8601String(),
        'status': 'completed',
        'cashier_name': widget.fullName,
        'cashier_role': widget.role,
        'cash_given': _cashGiven,
        'change': _change,
      }).select().single();

      final saleId = saleResponse['id'];

      final saleItems = widget.cartItems.map((item) => {
        'sale_id': saleId,
        'product_id': item['id'],
        'quantity': item['cart_quantity'],
        'unit_price': item['price'],
        'total_price': item['price'] * item['cart_quantity'],
      }).toList();

      await Supabase.instance.client.from('sale_items').insert(saleItems);

      // Update branch stock for each item
      for (final item in widget.cartItems) {
        // Get the current stock from branch_stock
        final stockResponse = await Supabase.instance.client
            .from('branch_stock')
            .select('current_stock, id')
            .eq('product_id', item['id'])
            .single();

        final currentStock = stockResponse['current_stock'] as int;
        final branchStockId = stockResponse['id'];

        // Update branch_stock with new quantity
        await Supabase.instance.client
            .from('branch_stock')
            .update({'current_stock': currentStock - item['cart_quantity']})
            .eq('id', branchStockId);
      }

      Navigator.pop(context);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => ReceiptPage(
            saleId: saleId,
            paymentMethod: paymentMethod,
            subtotal: widget.subtotal,
            tax: widget.tax,
            discount: widget.discount,
            total: widget.total,
            cartItems: widget.cartItems,
            fullName: widget.fullName,
            role: widget.role,
            cashGiven: _cashGiven,
            change: _change,
            userId: widget.userId,
            location: widget.location,
          ),
        ),
            (route) => false,
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildSummaryRow(String label, String value,
      {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
              )),
          Text(
            value,
            style: TextStyle(
              fontSize: isBold ? 16 : 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _paymentCard(BuildContext context, String label, IconData icon, String method) {
    return InkWell(
      onTap: () => _processPayment(context, method),
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 42, color: Colors.pinkAccent),
              const SizedBox(height: 12),
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                method,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalText = "₱${widget.total.toStringAsFixed(2)}";
    return Scaffold(
      backgroundColor: const Color(0xFFF9F4F6),
      appBar: AppBar(
        backgroundColor: Colors.pink[200],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Payment Method",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Order Summary",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _buildSummaryRow("Items", widget.cartItems.length.toString()),
                  _buildSummaryRow("Subtotal", "₱${widget.subtotal.toStringAsFixed(2)}"),
                  _buildSummaryRow("Tax", "₱${widget.tax.toStringAsFixed(2)}"),
                  if (widget.discount > 0)
                    _buildSummaryRow("Discount", "-₱${widget.discount.toStringAsFixed(2)}"),
                  const Divider(),
                  _buildSummaryRow("Total", totalText,
                      isBold: true, color: Colors.pinkAccent),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _cashController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Cash Given",
                      prefixIcon: const Icon(Icons.money, color: Colors.pinkAccent),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (_) => _calculateChange(),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Change: ${_change >= 0 ? '₱${_change.toStringAsFixed(2)}' : '₱0.00'}",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.pinkAccent),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Select Payment Method",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              _paymentCard(context, "CASH", Icons.payments, "Cash"),
              _paymentCard(context, "GCASH", Icons.account_balance_wallet, "Gcash"),
              _paymentCard(context, "BANK", Icons.account_balance, "Bank"),
              _paymentCard(context, "CARD", Icons.credit_card, "Card"),
            ],
          ),
        ],
      ),
    );
  }
}