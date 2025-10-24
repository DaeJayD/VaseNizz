import 'package:flutter/material.dart';
import 'package:vasenizzpos/dashboard/HomeScreen.dart';
import 'package:vasenizzpos/inventory/inventory_screen.dart';
import 'package:vasenizzpos/reports/view_reports.dart';
import 'package:vasenizzpos/users/users_page.dart';
import 'package:vasenizzpos/products/brand_products_page.dart';

class MakeASale extends StatefulWidget {
  final String username;
  final int initialIndex;

  const MakeASale({
    required this.username,
    this.initialIndex = 1,
    Key? key,
  }) : super(key: key);

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

  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8EDF3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5C6D3),
        elevation: 0,
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.black54,
        onTap: (index) {
          setState(() => _selectedIndex = index);

          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(username: widget.username),
              ),
            );
          } else if (index == 1) {
            // Already on Sales
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const InventoryPage()),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ViewReportsPage()),
            );
          } else if (index == 4) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const UsersPage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Sales"),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: "Inventory"),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: "Report"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
