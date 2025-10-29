import 'package:flutter/material.dart';
import 'package:vasenizzpos/users/employee_page.dart';

class EmployeeHomeScreen extends StatefulWidget {
  final String fullName;
  final String userId;
  final String role;


  const EmployeeHomeScreen({
    required this.fullName,
    required this.userId,
    required this.role,
    Key? key,
  }) : super(key: key);

  @override
  State<EmployeeHomeScreen> createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {
  int _selectedIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      SalesPage(),
      UserProfileScreen(
        userId: widget.userId,
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
                  "Sales",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                Text(
                  "${widget.fullName} (${widget.role})",
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
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.black54,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Sales"),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: "Inventory"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

// Placeholder pages for Sales and Inventory
class SalesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Sales Page Content"));
  }
}

