import 'package:flutter/material.dart';
import 'package:vasenizzpos/products/brand_products_page.dart';

class MakeASale extends StatefulWidget {
  final String username;

  const MakeASale({required this.username, Key? key}) : super(key: key);

  @override
  State<MakeASale> createState() => _MakeASaleState();
}

class _MakeASaleState extends State<MakeASale> {
  final List<Map<String, String>> brands = [
    {'name': 'Beauty Wise', 'logo': 'assets/beautywise.png'},
    {'name': 'Beauty Vault', 'logo': 'assets/beautyvault.png'},
    {'name': 'Lumi', 'logo': 'assets/lumi.png'},
    {'name': 'Brilliant', 'logo': 'assets/brilliant.png'},
    {'name': 'Ex.', 'logo': 'assets/ex.png'},
  ];

  List<Map<String, dynamic>> cart = [];

  void _addToCart(String brand, String product, double price) {
    setState(() {
      cart.add({'brand': brand, 'product': product, 'price': price});
    });
  }

  void _completeSale() {
    if (cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No items in the sale")),
      );
      return;
    }

    double total = cart.fold(0, (sum, item) => sum + item['price']);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Complete Sale"),
        content: Text("Total amount: ₱${total.toStringAsFixed(2)}"),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => cart.clear());
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Sale completed!")),
              );
            },
            child: const Text("Confirm"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8EDF3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5C6D3),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: const AssetImage('assets/logo.png'),
              radius: 20,
              backgroundColor: Colors.white,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Sales Manager",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                Text(
                  "${widget.username} (03085)",
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: _completeSale,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Search by Name, Brand, Type, ID",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "All Brands",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: brands.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(brands[index]['name']!),
                      trailing: CircleAvatar(
                        backgroundImage: AssetImage(brands[index]['logo']!),
                        radius: 20,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BrandProductsPage(
                              brandName: brands[index]['name']!,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
