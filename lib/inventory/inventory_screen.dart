import 'package:flutter/material.dart';
import 'package:vasenizzpos/dashboard/home_screen.dart';
import 'package:vasenizzpos/sales/sales_screen.dart';
import 'package:vasenizzpos/reports/reports_page.dart';
import 'package:vasenizzpos/users/users_page.dart';
import 'inventory_history.dart';

class InventoryPage extends StatefulWidget {
  final String fullName;
  final String role;
  final int initialIndex;

  const InventoryPage({
    required this.fullName,
    required this.role,
    this.initialIndex = 2,
    super.key,
  });

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  late int _selectedIndex;

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

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    Widget nextPage;
    switch (index) {
      case 0:
        nextPage = HomeScreen(
          fullName: widget.fullName,
          role: widget.role,
          initialIndex: 0,
        );
        break;
      case 1:
        nextPage = SalesScreen(
          fullName: widget.fullName,
          role: widget.role,
          initialIndex: 1,

        );
        break;
      case 2:
        nextPage = InventoryPage(
          fullName: widget.fullName,
          role: widget.role,
          initialIndex: 2,
        );
      case 3:
        nextPage = SalesScreen(
          fullName: widget.fullName,
          role: widget.role,
          initialIndex: 1,
        );
      case 4:
        nextPage = UsersPage(
          fullName: widget.fullName,
          role: widget.role,
          initialIndex: 4,
        );
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => nextPage,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

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
                  fontSize: 16,
                ),
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
                    MaterialPageRoute(builder: (_) => HomeScreen(
                      fullName: widget.fullName,
                      role: widget.role,),
                    )
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
                    MaterialPageRoute(builder: (_) =>  HomeScreen(
                      fullName: widget.fullName,
                      role: widget.role,),
                    )
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _branchButton(
      BuildContext context, {
        required IconData icon,
        required String label,
        required Color color,
        required VoidCallback onTap,
      }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        label,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.fullName,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                Text(
                  widget.role,
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
                    label: const Text(
                      "📊 Inventory Monitor",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
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
                              HomeScreen(
                                fullName: widget.fullName,
                                role: widget.role,
                        ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.history, size: 26),
                    label: const Text(
                      "📜 Inventory History",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
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
            // Stock summary header and sort dropdown here...
            // Stock list
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3)],
                ),
                child: ListView.builder(
                  itemCount: stockData.length,
                  itemBuilder: (context, index) {
                    final item = stockData[index];
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
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
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Sales"),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: "Inventory"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Report"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
