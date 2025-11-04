import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmployeeProfilePage extends StatefulWidget {
  final String userId;

  const EmployeeProfilePage({super.key, required this.userId});

  @override
  State<EmployeeProfilePage> createState() => _EmployeeProfilePageState();
}

class _EmployeeProfilePageState extends State<EmployeeProfilePage> {
  Map<String, dynamic>? employeeData;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController branchController = TextEditingController();
  final TextEditingController roleController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEmployee();
  }

  Future<void> _fetchEmployee() async {
    try {
      final response = await Supabase.instance.client
          .from('employees')
          .select()
          .eq('user_id', widget.userId)
          .single();

      if (response != null) {
        setState(() {
          employeeData = Map<String, dynamic>.from(response);
          nameController.text = employeeData!['name'] ?? '';
          phoneController.text = employeeData!['phone'] ?? '';
          dobController.text = employeeData!['dob'] ?? '';
          usernameController.text = employeeData!['username'] ?? '';
          branchController.text = employeeData!['branch'] ?? '';
          roleController.text = employeeData!['role'] ?? '';
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching employee: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _updateEmployee() async {
    try {
      await Supabase.instance.client.from('employees').update({
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'dob': dobController.text.trim(),
        'username': usernameController.text.trim(),
        'branch': branchController.text.trim(),
        'role': roleController.text.trim(),
      }).eq('user_id', widget.userId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Employee updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating employee: $e')),
      );
    }
  }

  Future<void> _deleteEmployee() async {
    try {
      await Supabase.instance.client
          .from('employees')
          .delete()
          .eq('user_id', widget.userId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Employee deleted successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting employee: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8E4EC), // soft pink background
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8C8D9), // light pink appbar
        title: const Text(
          "Employee Profile",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildTextField("Full Name", nameController, icon: Icons.person),
            _buildTextField("Phone Number", phoneController, icon: Icons.phone),
            _buildTextField("Date of Birth", dobController, icon: Icons.cake),
            _buildTextField("Username", usernameController, icon: Icons.account_circle),
            _buildTextField("Branch Assigned", branchController, icon: Icons.location_city),
            _buildTextField("Role", roleController, icon: Icons.badge),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _updateEmployee,
                    icon: const Icon(Icons.save),
                    label: const Text("Update"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFA0C0), // medium pink
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _deleteEmployee,
                    icon: const Icon(Icons.delete),
                    label: const Text("Delete"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B8A), // darker pink
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null ? Icon(icon, color: Colors.pink.shade400) : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
        style: const TextStyle(fontSize: 16, color: Colors.black87),
      ),
    );
  }
}
