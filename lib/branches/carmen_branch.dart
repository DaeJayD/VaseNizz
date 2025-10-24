import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vasenizzpos/inventory/view_inventory.dart';

class CarmenScreen extends StatefulWidget {
  const CarmenScreen({super.key});

  @override
  State<CarmenScreen> createState() => _CarmenScreenState();
}

class _CarmenScreenState extends State<CarmenScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8EDF3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5C6D3),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage("assets/logo.png"),
              backgroundColor: Colors.white,
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Carmen Branch",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87),
                ),
                Text(
                  "Thofia Concepcion (03085)",
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.notifications_none_rounded,
                  color: Colors.white, size: 26),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: "Search Inventory",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),

            // 🔹 Buttons + Low Stock Alert Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left buttons
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _branchButton(
                        "View Inventory",
                        Icons.inventory_2_outlined,
                        Colors.pink[300]!,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const InventoryPage()),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      _branchButton("Update Brands", Icons.edit_note,
                          Colors.pink[200]!),
                      const SizedBox(height: 10),
                      _branchButton("Remove Brand", Icons.delete_outline,
                          Colors.pink[100]!),
                    ],
                  ),
                ),
                const SizedBox(width: 10),

                // Right low stock alert card
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 4)
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "LOW STOCK ALERT",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                        const SizedBox(height: 10),
                        const Icon(Icons.inventory_rounded,
                            color: Colors.red, size: 40),
                        const SizedBox(height: 5),
                        const Text(
                          "2",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 32,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text("1 lowproduct\n1 lowproduct",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black54, fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 🔹 Product Summary
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 3)
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "PRODUCT SUMMARY",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      _SummaryItem(
                          label: "All Products",
                          value: "5000",
                          color: Colors.black87,
                          icon: Icons.widgets_outlined),
                      _SummaryItem(
                          label: "Available",
                          value: "4952",
                          color: Colors.green,
                          icon: Icons.check_circle_outline),
                      _SummaryItem(
                          label: "Unavailable",
                          value: "48",
                          color: Colors.red,
                          icon: Icons.cancel_outlined),
                      _SummaryItem(
                          label: "Low In-Stock",
                          value: "2",
                          color: Colors.orange,
                          icon: Icons.warning_amber_rounded),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 🔹 Upcoming Deliveries Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Upcoming Deliveries",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87),
                ),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.add_circle_outline,
                        color: Colors.pink)),
              ],
            ),

            // 🔹 Interactive Calendar
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 3)
                  ],
                ),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink),
                  ),
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.pink.shade200,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.pink.shade400,
                      shape: BoxShape.circle,
                    ),
                    weekendTextStyle:
                    const TextStyle(color: Colors.pinkAccent),
                    outsideDaysVisible: false,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // 🔹 Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 2,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.black54,
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

  // ✅ Modified to accept an onPressed callback
  Widget _branchButton(String label, IconData icon, Color color,
      {VoidCallback? onPressed}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(label,
          style:
          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _SummaryItem(
      {required this.label,
        required this.value,
        required this.color,
        required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(
          value,
          style:
          TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 15),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }
}
