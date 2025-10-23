import 'package:flutter/material.dart';
import 'package:vasenizzpos/inventory/add_new_item.dart';

class BrandInventoryPage extends StatefulWidget {
  final String? brandName;
  final String? branchManager;
  final String? branchCode;
  final String? brandLogoPath;

  const BrandInventoryPage({
    super.key,
    this.brandName,
    this.branchManager,
    this.branchCode,
    this.brandLogoPath,
  });

  @override
  State<BrandInventoryPage> createState() => _BrandInventoryPageState();
}

class _BrandInventoryPageState extends State<BrandInventoryPage> {
  bool removeMode = false;

  final List<Map<String, dynamic>> items = List.generate(10, (i) {
    return {
      "name": "Product ${i + 1}",
      "sid": "00${i + 1}",
      "category": "Beauty",
      "price": "₱${200 + i * 10}",
      "out": i,
      "stock": 20 + i,
    };
  });

  void _showRemoveDialog(int index) {
    final TextEditingController qtyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Remove from ${items[index]['name']}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Available stock: ${items[index]['stock']}"),
              const SizedBox(height: 10),
              TextField(
                controller: qtyController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Quantity to remove",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                final int removeQty = int.tryParse(qtyController.text) ?? 0;
                if (removeQty > 0 && removeQty <= items[index]['stock']) {
                  setState(() {
                    items[index]['stock'] -= removeQty;
                  });
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Invalid quantity entered")),
                  );
                }
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  Widget _tableRow(Map<String, dynamic> item, int index) {
    return Container(
      color: index % 2 == 0 ? Colors.pink[50] : Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          _TableCell(item['name']),
          _TableCell(item['sid']),
          _TableCell(item['category']),
          _TableCell(item['price']),
          _TableCell(item['out'].toString()),
          _TableCell(item['stock'].toString()),
          Expanded(
            child: Center(
              child: IconButton(
                icon: Icon(
                  removeMode ? Icons.delete_outline : Icons.add_circle_outline,
                  color: removeMode ? Colors.redAccent : Colors.green,
                ),
                onPressed: () {
                  if (removeMode) {
                    _showRemoveDialog(index);
                  } else {
                    setState(() {
                      item['stock']++;
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final brandName = widget.brandName ?? "Beauty Vault";
    final branchManager = widget.branchManager ?? "Thofia Concepcion";
    final branchCode = widget.branchCode ?? "03085";
    final brandLogo = widget.brandLogoPath ?? "assets/beautyvault_logo.png";

    return Scaffold(
      backgroundColor: const Color(0xFFF8EDF3),
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage(brandLogo),
              backgroundColor: Colors.white,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  brandName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white),
                ),
                Text(
                  "$branchManager ($branchCode)",
                  style:
                  const TextStyle(fontSize: 13, color: Colors.white70),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.notifications_none_rounded,
                  color: Colors.white, size: 26),
              onPressed: () {},
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              children: [
                _smallButton(
                  "Add New",
                  Colors.white,
                  Colors.orangeAccent,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddNewItemPage()),
                    );
                  },
                ),
                const SizedBox(width: 8),
                _smallButton(
                  removeMode ? "Done" : "Remove Stock",
                  Colors.white,
                  Colors.redAccent,
                      () {
                    setState(() {
                      removeMode = !removeMode;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black26),
              ),
              child: Row(
                children: [
                  const Text(
                    "All Products",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const Spacer(),
                  _actionButton("Search"),
                  const SizedBox(width: 8),
                  _actionButton("Filter"),
                  const SizedBox(width: 8),
                  _actionButton("Sort"),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      color: Colors.pink[50],
                      child: const Row(
                        children: [
                          _TableHeaderCell("Name"),
                          _TableHeaderCell("S.ID"),
                          _TableHeaderCell("Category"),
                          _TableHeaderCell("Price"),
                          _TableHeaderCell("Out"),
                          _TableHeaderCell("In stock"),
                          _TableHeaderCell("+"),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: Colors.black26),
                    Expanded(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) =>
                            _tableRow(items[index], index),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.first_page_rounded)),
                for (int i = 1; i <= 8; i++)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: i == 1 ? Colors.pink[200] : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text("$i"),
                  ),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.last_page_rounded)),
              ],
            ),
            const Text("1 of 8 pages (64 items)",
                style: TextStyle(color: Colors.black54, fontSize: 12)),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 2,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.black54,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded), label: "Dashboard"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: "Sales"),
          BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2_outlined), label: "Inventory"),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long), label: "Report"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget _smallButton(
      String text, Color bg, Color borderColor, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: TextStyle(color: borderColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _actionButton(String text) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () {},
      child: Text(text),
    );
  }
}

class _TableHeaderCell extends StatelessWidget {
  final String text;
  const _TableHeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style:
        const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;
  const _TableCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.black87, fontSize: 13),
      ),
    );
  }
}
