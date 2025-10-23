import 'package:flutter/material.dart';
import 'package:vasenizzpos/dashboard/HomeScreen.dart';
import 'package:vasenizzpos/sales/sales_screen.dart';
import 'package:vasenizzpos/branches/carmen_branch.dart';
import 'inventory_history.dart';

class ManageAllPage extends StatelessWidget {
  const ManageAllPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8EDF3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5C6D3),
        title: const Text(
          "Manage All Branches",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          "📦 Manage All Branches Page Placeholder",
          style: TextStyle(fontSize: 18, color: Colors.pink),
        ),
      ),
    );
  }
}

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  int _selectedIndex = 2; // Inventory tab index

  final List<Map<String, String>> stockData = List.generate(
    12,
        (index) => {
      'sid': 'EX-${index + 1}',
      'productId': 'PID${1000 + index}',
      'brand': 'Beauty Wise',
      'name': 'Product ${index + 1}',
      'in': '${20 + index}',
      'out': '${10 + index}',
      'qty': '${(20 + index) - (10 + index)}',
    },
  );

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen(username: 'User')),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SalesScreen()),
        );
        break;
      case 2:
        break; // Already in Inventory
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  // 🔹 Popup dialog function
  void _showBranchSelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "SELECT BRANCH",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                    fontSize: 16),
              ),
              const SizedBox(height: 20),
              _branchButton(
                context,
                icon: Icons.manage_accounts,
                label: "MANAGE ALL",
                color: Colors.pink.shade300,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ManageAllPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              _branchButton(
                context,
                icon: Icons.home,
                label: "JASAAN BRANCH",
                color: Colors.pink.shade200,
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Jasaan Branch Placeholder")),
                  );
                },
              ),
              const SizedBox(height: 10),
              _branchButton(
                context,
                icon: Icons.home,
                label: "PUERTO BRANCH",
                color: Colors.pink.shade200,
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Puerto Branch Placeholder")),
                  );
                },
              ),
              const SizedBox(height: 10),
              _branchButton(
                context,
                icon: Icons.home,
                label: "CARMEN BRANCH",
                color: Colors.pink.shade200,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CarmenScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _branchButton(BuildContext context,
      {required IconData icon,
        required String label,
        required Color color,
        required VoidCallback onTap}) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
      label: Text(label,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/logo.png'),
              radius: 20,
              backgroundColor: Colors.white,
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Inventory Manager",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                Text(
                  "Thofia Concepcion (03085)",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
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
                hintText: "Search by Name, Brand, or Product ID",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showBranchSelector(context),
                    icon: const Icon(Icons.bar_chart, size: 26),
                    label: const Text("📊 Inventory Monitor",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink[300],
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                            const InventoryHistoryScreen()),
                      );
                    },
                    icon: const Icon(Icons.history, size: 26),
                    label: const Text("📜 Inventory History",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink[200],
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Stock Summary",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87),
                ),
                Row(
                  children: [
                    const Text("Sort by:",
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500)),
                    const SizedBox(width: 6),
                    DropdownButton<String>(
                      items: const [
                        DropdownMenuItem(value: 'S.ID', child: Text('S.ID')),
                        DropdownMenuItem(
                            value: 'Product ID', child: Text('Product ID')),
                        DropdownMenuItem(value: 'Brand', child: Text('Brand')),
                      ],
                      onChanged: (_) {},
                      hint: const Text('S.ID'),
                      underline: const SizedBox(),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
              decoration: BoxDecoration(
                color: Colors.pink.shade100,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Row(
                children: [
                  Expanded(flex: 1, child: Center(child: Text("S.ID", style: TextStyle(fontWeight: FontWeight.bold)))),
                  Expanded(flex: 2, child: Center(child: Text("PRODUCT ID", style: TextStyle(fontWeight: FontWeight.bold)))),
                  Expanded(flex: 2, child: Center(child: Text("BRAND", style: TextStyle(fontWeight: FontWeight.bold)))),
                  Expanded(flex: 2, child: Center(child: Text("NAME", style: TextStyle(fontWeight: FontWeight.bold)))),
                  Expanded(flex: 1, child: Center(child: Text("IN", style: TextStyle(fontWeight: FontWeight.bold)))),
                  Expanded(flex: 1, child: Center(child: Text("OUT", style: TextStyle(fontWeight: FontWeight.bold)))),
                  Expanded(flex: 1, child: Center(child: Text("QTY.", style: TextStyle(fontWeight: FontWeight.bold)))),
                ],
              ),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 3)
                  ],
                ),
                child: ListView.builder(
                  itemCount: stockData.length,
                  itemBuilder: (context, index) {
                    final item = stockData[index];
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 6),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: Colors.grey.shade200, width: 1),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(flex: 1, child: Center(child: Text(item['sid']!))),
                          Expanded(flex: 2, child: Center(child: Text(item['productId']!))),
                          Expanded(flex: 2, child: Center(child: Text(item['brand']!))),
                          Expanded(flex: 2, child: Center(child: Text(item['name']!))),
                          Expanded(flex: 1, child: Center(child: Text(item['in']!))),
                          Expanded(flex: 1, child: Center(child: Text(item['out']!))),
                          Expanded(flex: 1, child: Center(child: Text(item['qty']!))),
                        ],
                      ),
                    );
                  },
                ),
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
        onTap: _onItemTapped,
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
}
