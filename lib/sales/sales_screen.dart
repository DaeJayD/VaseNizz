import 'package:flutter/material.dart';
import 'package:vasenizzpos/dashboard/home_screen.dart';
import 'package:vasenizzpos/inventory/inventory_screen.dart';
import 'package:vasenizzpos/reports/reports_page.dart';
import 'package:vasenizzpos/users/users_page.dart';
import 'make_a_sale.dart';
import 'sales_history_page.dart';

class SalesScreen extends StatefulWidget {
  final String fullName;
  final String role;
  final int initialIndex;

  const SalesScreen({
    required this.fullName,
    required this.role,
    this.initialIndex = 1,
    super.key,
  });

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  late int _selectedIndex;

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
          initialIndex: 1
        );
        break;
      case 2:
        nextPage = InventoryPage(
          fullName: widget.fullName,
          role: widget.role,
        );
        break;
      case 3:
        nextPage = ViewReportsPage(
          fullName: widget.fullName,
          role: widget.role,
        );
        break;
      case 4:
        nextPage = UsersPage(
          fullName: widget.fullName,
          role: widget.role,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8EDF3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5C6D3),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Sales Manager",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/logo.png'),
                  radius: 25,
                  backgroundColor: Colors.white,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.fullName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(widget.role,
                        style: const TextStyle(color: Colors.black54, fontSize: 13)),
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_none_rounded, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search Sales',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black26),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SalesScreen(
                            fullName: widget.fullName,
                            role: widget.role,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_cart_outlined, size: 35, color: Colors.pink),
                          SizedBox(height: 10),
                          Text(
                            "Make a Sale",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SalesScreen(
                            fullName: widget.fullName,
                            role: widget.role,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.history, size: 35, color: Colors.black87),
                          SizedBox(height: 10),
                          Text(
                            "Sales History",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Recent Sales",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const Divider(),
                  saleItem("123456", "Example Product", "Sep 12, 2023", "10:23 AM"),
                  saleItem("123457", "Example Product", "Sep 13, 2023", "1:15 PM"),
                  saleItem("123458", "Example Product", "Sep 14, 2023", "4:47 PM"),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.black54,
        currentIndex: _selectedIndex,
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

  Widget saleItem(String orderId, String product, String date, String time) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            color: Colors.grey[300],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Order Id : $orderId",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(product),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(date, style: const TextStyle(color: Colors.black54)),
              Text(time, style: const TextStyle(color: Colors.black54)),
            ],
          )
        ],
      ),
    );
  }
}
