import 'package:flutter/material.dart';
import 'sales_screen.dart'; // make sure this file exists in /lib

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({required this.username, Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Mock Data
  final salesData = {
    'itemsSold': 23,
    'salesAmount': '₱48,999',
    'salesChange': '-13%',
  };

  final shipmentData = [
    {'count': 12, 'label': 'Packages to be Shipped', 'icon': Icons.local_shipping},
    {'count': 21, 'label': 'Packages to be Delivered', 'icon': Icons.delivery_dining},
    {'count': 101, 'label': 'Items to be Invoiced', 'icon': Icons.receipt_long},
  ];

  final inventoryData = {'inStock': 5000, 'reStock': 150};

  final topSelling = [
    {'name': 'Concealer', 'sold': 24, 'price': '₱199'},
    {'name': 'SPF 50+++', 'sold': 70, 'price': '₱349'},
    {'name': 'Rejuvenating Set', 'sold': 12, 'price': '₱499'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8EDF3),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFF5C6D3),
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: const AssetImage('assets/logo.png'),
              radius: 22,
              backgroundColor: Colors.white,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Dashboard",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                Text(
                  "Welcome Back!\n${widget.username} (03085)",
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Colors.black54),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sectionTitle("Sales Activity"),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: dashboardCard(
                    icon: Icons.trending_up,
                    title: "${salesData['itemsSold']}",
                    subtitle: "Items Sold Today",
                    extra: "+N/A%",
                    color: Colors.pink.shade50,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to SalesScreen when tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SalesScreen()),
                      );
                    },
                    child: dashboardCard(
                      icon: Icons.attach_money_rounded,
                      title: salesData['salesAmount'].toString(),
                      subtitle: "Sales",
                      extra: salesData['salesChange'].toString(),
                      color: Colors.orange.shade50,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            for (var data in shipmentData)
              shipmentCard(
                data['count'].toString(),
                data['label'].toString(),
                data['icon'] as IconData,
              ),
            const SizedBox(height: 25),
            sectionTitle("Inventory Summary (In Quantity)"),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: inventoryBox("In-stock", inventoryData['inStock'].toString(), Colors.redAccent)),
                const SizedBox(width: 10),
                Expanded(child: inventoryBox("Re-stock", inventoryData['reStock'].toString(), Colors.green)),
              ],
            ),
            const SizedBox(height: 25),
            sectionTitle("Top Selling"),
            const SizedBox(height: 10),
            buildTopSellingTable(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFF8EDF3),
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.black54,
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 0) {
            // Already on Dashboard — just stay here
            setState(() => _selectedIndex = 0);
          } else if (index == 1) {
            setState(() => _selectedIndex = 1);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SalesScreen()),
            ).then((_) {
              // When returning from SalesScreen, re-highlight Dashboard
              setState(() => _selectedIndex = 0);
            });
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Sales"),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: "Inventory"),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: "Report"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  // ─── UI HELPERS ───────────────────────────────────────────────

  Widget sectionTitle(String title) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3)],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }

  Widget dashboardCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String extra,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.pink.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.pinkAccent),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Colors.black54)),
          Text(extra, style: const TextStyle(color: Colors.green)),
        ],
      ),
    );
  }

  Widget shipmentCard(String count, String label, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3)],
      ),
      child: Row(
        children: [
          Text(count,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 20, color: Colors.pink)),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
          Icon(icon, color: Colors.teal, size: 26),
        ],
      ),
    );
  }

  Widget inventoryBox(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Center(
              child: Text(value,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget buildTopSellingTable() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3)],
      ),
      child: Column(
        children: [
          Row(
            children: const [
              Expanded(child: Text("Name", style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(child: Text("Sold", style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(child: Text("Price", style: TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
          const Divider(),
          for (var item in topSelling)
            Row(
              children: [
                Expanded(child: Text(item['name'].toString())),
                Expanded(child: Text(item['sold'].toString())),
                Expanded(child: Text(item['price'].toString())),
              ],
            ),
        ],
      ),
    );
  }
}
