import 'package:flutter/material.dart';
import 'package:vasenizzpos/dashboard/employee_homescreen.dart';
import 'package:vasenizzpos/dashboard/home_screen.dart';
import 'package:vasenizzpos/main.dart';
import 'emp_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vasenizzpos/sales/sales_screen.dart';
import 'package:vasenizzpos/inventory/inventory_screen.dart';


class UsersPage extends StatefulWidget {
  final String fullName;
  final String role;
  final int initialIndex;

  const UsersPage({
    Key? key,
    required this.fullName,
    required this.role,
    this.initialIndex = 4,
  }) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  int _selectedIndex = 4;
  List<Map<String, dynamic>> employees = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  String? selectedBranch;
  String? selectedRole;

  bool showEmployeeList = false;

  @override
  void initState() {
    super.initState();
    _fetchEmployees();
  }

  Future<String> _generateUserId() async {
    try {
      final response = await Supabase.instance.client
          .from('employees')
          .select('user_id')
          .order('user_id', ascending: false)
          .limit(1)
          .select();

      if (response != null && response.isNotEmpty) {
        String lastId = response[0]['user_id']; // e.g., "E003"
        int number = int.parse(lastId.substring(1));
        number += 1;
        return 'E${number.toString().padLeft(3, '0')}';
      } else {
        return 'E001';
      }
    } catch (e) {
      print('Error generating user_id: $e');
      return 'E001';
    }
  }

  Future<void> _createUser() async {
    final userId = await _generateUserId();
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final dob = dobController.text.trim();
    final username = usernameController.text.trim();

    if (name.isEmpty ||
        phone.isEmpty ||
        dob.isEmpty ||
        username.isEmpty ||
        selectedBranch == null ||
        selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields.')),
      );
      return;
    }

    try {
      final response = await Supabase.instance.client
          .from('employees')
          .insert({
        'name': name,
        'phone': phone,
        'dob': dob,
        'username': username,
        'user_id': userId,
        'branch': selectedBranch,
        'role': selectedRole,
        'password': '',
      })
          .select();

      if (response != null && response.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User $userId created successfully!')),
        );
        _fetchEmployees();
        nameController.clear();
        phoneController.clear();
        dobController.clear();
        usernameController.clear();
        setState(() {
          selectedBranch = null;
          selectedRole = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error creating user.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _fetchEmployees() async {
    try {
      final response = await Supabase.instance.client
          .from('employees')
          .select();

      setState(() {
        employees = response != null
            ? List<Map<String, dynamic>>.from(response)
            : [];
      });
    } catch (e) {
      print('Error fetching employees: $e');
      setState(() {
        employees = [];
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8E9EE),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFFFB6C1),
        elevation: 0,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage('assets/logo.png'),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Manage Users",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87),
                ),
                Text(
                  widget.fullName,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Icon(Icons.notifications_none,
                color: Colors.black54, size: 26),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Show the employee list in a modal
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => DraggableScrollableSheet(
                      initialChildSize: 0.5, // half screen
                      minChildSize: 0.3,
                      maxChildSize: 0.9,
                      expand: false,
                      builder: (context, scrollController) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              const Text(
                                "Employee List",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black87),
                              ),
                              const SizedBox(height: 10),
                              Expanded(
                                child: employees.isEmpty
                                    ? const Center(child: Text("No employees found"))
                                    : ListView.builder(
                                  controller: scrollController,
                                  itemCount: employees.length,
                                  itemBuilder: (context, index) {
                                    final employee = employees[index];
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[50],
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: Colors.grey.shade300),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(employee['name'] ?? '',
                                                    style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16)),
                                                const SizedBox(height: 2),
                                                Text(
                                                    "${employee['user_id'] ?? ''}  ${employee['role'] ?? ''}",
                                                    style: const TextStyle(
                                                        color: Colors.black54)),
                                                const SizedBox(height: 2),
                                                Text(employee['phone'] ?? '',
                                                    style: const TextStyle(
                                                        color: Colors.black54)),
                                              ],
                                            ),
                                          ),
                                          TextButton.icon(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => EmployeeProfilePage(
                                                    userId: employee['user_id'],
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: const Icon(Icons.edit, color: Colors.redAccent, size: 18),
                                            label: const Text(
                                              "Edit",
                                              style: TextStyle(color: Colors.redAccent),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
                child: const Text(
                  "MANAGE USERS",
                  style: TextStyle(
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            if (showEmployeeList)
              Column(
                children: employees.map((employee) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        // Edit button
                        TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EmployeeProfilePage(
                                  userId: employee['user_id'], // employee from ListView.builder
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit, color: Colors.redAccent, size: 18),
                          label: const Text(
                            "Edit",
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Delete button
                        TextButton.icon(
                          onPressed: () async {
                            bool confirmed = await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Confirm Delete"),
                                content: Text(
                                    "Are you sure you want to delete ${employee['name']}?"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text(
                                        "Delete",
                                        style: TextStyle(color: Colors.red)
                                    ),
                                  ),
                                ],
                              ),
                            );

                            if (confirmed) {
                              try {
                                await Supabase.instance.client
                                    .from('employees')
                                    .delete()
                                    .eq('user_id', employee['user_id']);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("${employee['name']} deleted.")),
                                );
                                _fetchEmployees();
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Error deleting user: $e")),
                                );
                              }
                            }
                          },
                          icon: const Icon(Icons.delete, color: Colors.red, size: 18),
                          label: const Text(
                            "Delete",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            const SizedBox(height: 24),
            const Text(
              "Create New User",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  buildTextField("Name", "Employee Name",
                      controller: nameController),
                  buildTextField("Phone Number", "Ex. 09123456789",
                      controller: phoneController),
                  buildTextField("Date of Birth", "yyyy/mm/dd",
                      controller: dobController),
                  buildTextField("Username", "Username",
                      controller: usernameController),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6)),
                          ),
                          hint: const Text("Assign Branch"),
                          items: ["Branch 1", "Branch 2"]
                              .map((val) => DropdownMenuItem(
                            value: val,
                            child: Text(val),
                          ))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              selectedBranch = val;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6)),
                          ),
                          hint: const Text("Assign Role"),
                          items: ["Cashier", "Staff", "Manager"]
                              .map((val) => DropdownMenuItem(
                            value: val,
                            child: Text(val),
                          ))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              selectedRole = val;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent.shade100,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: _createUser,
                    icon: const Icon(Icons.add, color: Colors.green),
                    label: const Text(
                      "Create User",
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => VasenizzApp()),
                          (route) => false);
                },
                child: const Text(
                  "Log Out",
                  style: TextStyle(
                      color: Colors.redAccent, fontWeight: FontWeight.bold),
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
              icon: Icon(Icons.inventory), label: "Inventory"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Report"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  static Widget buildTextField(String label, String hint,
      {TextEditingController? controller}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
    );
  }
}
