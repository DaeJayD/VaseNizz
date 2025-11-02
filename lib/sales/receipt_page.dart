import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vasenizzpos/sales/sales_screen.dart';

class ReceiptPage extends StatefulWidget {
  final String saleId;
  final String paymentMethod;
  final String location;
  final String userId;
  final double subtotal;
  final double tax;
  final double discount;
  final double total;
  final List<Map<String, dynamic>> cartItems;
  final String fullName;
  final String role;
  final double cashGiven;
  final double change;


  const ReceiptPage({
    super.key,
    required this.saleId,
    required this.userId,
    required this.location,
    required this.paymentMethod,
    required this.subtotal,
    required this.tax,
    required this.discount,
    required this.total,
    required this.cartItems,
    required this.fullName,
    required this.role,
    required this.cashGiven,
    required this.change,
  });

  @override
  State<ReceiptPage> createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  bool _isLoading = true;
  late String formattedDate;

  @override
  void initState() {
    super.initState();
    formattedDate = DateFormat("MM/dd/yyyy • hh:mm a").format(DateTime.now());
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() => _isLoading = false);
    });
  }

  void _copyReceipt() {
    final buffer = StringBuffer();
    buffer.writeln("VASENIZZ BEAUTY SHOP");
    buffer.writeln("Receipt ID: ${widget.saleId.substring(0, 8).toUpperCase()}");
    buffer.writeln("Date/Time: $formattedDate");
    buffer.writeln("Processed by: ${widget.fullName} (${widget.role})");
    buffer.writeln("Payment Method: ${widget.paymentMethod}");
    buffer.writeln("\nItems:");
    for (var item in widget.cartItems) {
      buffer.writeln(
          "- ${item['name']} x${item['cart_quantity']} @ ₱${item['price']}");
    }
    buffer.writeln("\nSubtotal: ₱${widget.subtotal.toStringAsFixed(2)}");
    buffer.writeln("Tax: ₱${widget.tax.toStringAsFixed(2)}");
    if (widget.discount > 0) {
      buffer.writeln("Discount: -₱${widget.discount.toStringAsFixed(2)}");
    }
    buffer.writeln("Total: ₱${widget.total.toStringAsFixed(2)}");
    buffer.writeln("Cash Given: ₱${widget.cashGiven.toStringAsFixed(2)}");
    buffer.writeln("Change: ₱${widget.change.toStringAsFixed(2)}");

    Clipboard.setData(ClipboardData(text: buffer.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Receipt copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F4F6),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.pink))
            : SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildHeader(),
              const SizedBox(height: 18),
              _buildReceiptCard(),
              const SizedBox(height: 24),
              _buildProceedButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFC7D2),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Transaction Complete",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          ElevatedButton(
            onPressed: _copyReceipt,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: Colors.black26, width: 0.5),
              ),
            ),
            child: const Text(
              "COPY",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Image.asset("assets/logo.png", height: 55),
          const SizedBox(height: 8),
          const Text(
            "VASENIZZ BEAUTY SHOP",
            style: TextStyle(
              fontSize: 18,
              color: Colors.pink,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "Receipt #${widget.saleId.substring(0, 8).toUpperCase()}",
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            formattedDate,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const Divider(thickness: 1, height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Payment Method",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text("Amount", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.paymentMethod),
              Text("₱${widget.total.toStringAsFixed(2)}"),
            ],
          ),
          const Divider(thickness: 1, height: 24),

          Column(
            children: widget.cartItems.map((item) {
              final name = item['name'] ?? 'Item';
              final qty = item['cart_quantity'] ?? 1;
              final price = (item['price'] ?? 0.0) as double;
              final total = price * qty;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(flex: 4, child: Text("$name x$qty")),
                    Expanded(
                      flex: 2,
                      child: Text(
                        "₱${total.toStringAsFixed(2)}",
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          const Divider(thickness: 1, height: 24),

          _buildTotalRow("Subtotal", widget.subtotal),
          _buildTotalRow("Tax (12%)", widget.tax),
          if (widget.discount > 0)
            _buildTotalRow("Discount", -widget.discount, color: Colors.red),
          const Divider(thickness: 1, height: 24),
          _buildTotalRow("Grand Total", widget.total, isBold: true, color: Colors.black),
          const Divider(thickness: 1, height: 24),
          _buildTotalRow("Cash Given", widget.cashGiven, color: Colors.black),
          _buildTotalRow("Change", widget.change, color: Colors.green, isBold: true),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, double value,
      {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 16 : 14,
            ),
          ),
          Text(
            "₱${value.toStringAsFixed(2)}",
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 16 : 14,
              color: color ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProceedButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => SalesScreen(
              fullName: widget.fullName,
              role: widget.role,
              userId: widget.userId,
              location: widget.location,
            ),
          ),
              (route) => false,
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Text(
        "PROCEED",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
