import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EmployeeProfilePage extends StatefulWidget {
  const EmployeeProfilePage({super.key});

  @override
  State<EmployeeProfilePage> createState() => _EmployeeProfilePageState();
}

class _EmployeeProfilePageState extends State<EmployeeProfilePage> {
  bool isOnDuty = false;
  late String currentTime;
  late String currentDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    currentTime = DateFormat('HH:mm:ss').format(now);
    currentDate = DateFormat('yyyy-MM-dd').format(now);
  }

  void toggleDuty() {
    setState(() {
      isOnDuty = !isOnDuty;
      final now = DateTime.now();
      currentTime = DateFormat('HH:mm:ss').format(now);
      currentDate = DateFormat('yyyy-MM-dd').format(now);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8E4EC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8C8D9),
        elevation: 0,
        toolbarHeight: 100,
        title: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const Center(
                child: Text(
                  "LOGO",
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "User Profile",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "Employee (0.xxxx)",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Icon(
              Icons.notifications_none_rounded,
              color: Colors.white,
              size: 28,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F2F6),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person_outline,
                            size: 60, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Employee",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        isOnDuty ? "On Duty" : "Off Duty",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: isOnDuty ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Icon(Icons.camera_alt,
                          color: Colors.red.shade400, size: 20),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: toggleDuty,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isOnDuty
                              ? const Color(0xFFFFA8A8)
                              : const Color(0xFFB8F1B0),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          isOnDuty ? "Time Out" : "Time In",
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        currentTime,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        currentDate,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 25),
              _infoField("Name", "Employee 1"),
              _infoField("Phone Number", "Ex. No"),
              _infoField("Date of Birth", "yyyy/mm/dd"),
              _infoField("User ID", "0.xxxx"),
              _infoField("Branch Assigned", "Carmen"),
              const SizedBox(height: 25),
              SizedBox(
                width: 180,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: const BorderSide(color: Colors.redAccent),
                    ),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  ),
                  child: const Text(
                    "Log Out",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.black54,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: "Sales"),
          BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2_rounded), label: "Inventory"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget _infoField(String label, String placeholder) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        readOnly: true,
        style: const TextStyle(fontFamily: 'Poppins'),
        decoration: InputDecoration(
          labelText: label,
          hintText: placeholder,
          labelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
          hintStyle: const TextStyle(
              fontFamily: 'Poppins', fontSize: 14, color: Colors.black54),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black26),
          ),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),
    );
  }
}
