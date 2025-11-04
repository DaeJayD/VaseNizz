import 'package:flutter/material.dart';
import 'package:vasenizzpos/employees/employee_branch_sales_content.dart';
import 'package:vasenizzpos/branches/carmen_branch.dart';
import 'package:vasenizzpos/employees/employee_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmployeeHomeScreen extends StatefulWidget {
  final String fullName;
  final String role;
  final String userId;
  final String location;
  final int initialIndex;

  const EmployeeHomeScreen({
    required this.fullName,
    required this.role,
    required this.location,
    required this.userId,
    this.initialIndex = 0,
    super.key,
  });

  @override
  State<EmployeeHomeScreen> createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {
  int _selectedIndex = 0;
  String? _userBranchLocation;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _fetchUserBranch();
  }

  Future<void> _fetchUserBranch() async {
    try {
      final response = await Supabase.instance.client
          .from('employees')
          .select('branch')
          .eq('user_id', widget.userId)
          .maybeSingle();

      if (response != null && response['branch'] != null) {
        setState(() {
          _userBranchLocation = response['branch'];
        });
      }
    } catch (e) {
      print('Error fetching user branch: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the respective screen
    switch (index) {
      case 0: // Sales
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmployeeBranchSalesContent(
              fullName: widget.fullName,
              role: widget.role,
              userId: widget.userId,
              location: _userBranchLocation ?? widget.location,
            ),
          ),
        );
        break;
      case 1: // Inventory
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CarmenScreen(
              fullName: widget.fullName,
              role: widget.role,
              userId: widget.userId,
              location: _userBranchLocation ?? widget.location,
            ),
          ),
        );
        break;
      case 2: // Profile
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserProfileScreen(
              userId: widget.userId,
              fullName: widget.fullName,
              role: widget.role,
            ),
          ),
        );
        break;
    }
  }

  // Home Dashboard Content
  Widget _buildDashboard() {
    return Scaffold(
      backgroundColor: const Color(0xFFF8EDF3),
      body: SafeArea(
        child: Column(
          children: [
            // Welcome Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF5C6D3),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage('assets/logo.png'),
                    radius: 30,
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome, ${widget.fullName}!",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${_userBranchLocation ?? widget.location} Branch • ${widget.role}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Quick Actions Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Sales Card
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EmployeeBranchSalesContent(
                              fullName: widget.fullName,
                              role: widget.role,
                              userId: widget.userId,
                              location: _userBranchLocation ?? widget.location,
                            ),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(15),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.pink.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.shopping_cart,
                                color: Colors.pink,
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Sales",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Process sales and view history",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Inventory Card
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CarmenScreen(
                              fullName: widget.fullName,
                              role: widget.role,
                              userId: widget.userId,
                              location: _userBranchLocation ?? widget.location,
                            ),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(15),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.inventory,
                                color: Colors.blue,
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Inventory",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "View ${_userBranchLocation ?? widget.location} stock",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Profile Card
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserProfileScreen(
                              userId: widget.userId,
                              fullName: widget.fullName,
                              role: widget.role,
                            ),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(15),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.person,
                                color: Colors.green,
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Profile",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Manage your account settings",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Branch Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.store,
                      color: Colors.pink,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Current Branch",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            _userBranchLocation ?? widget.location,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildDashboard();
  }
}