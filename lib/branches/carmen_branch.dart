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


  List<String> _brands = ["Beauty Vault", "Lumi", "Brilliant", "VaseNizz", "NoBrand"];

  void _showUpdateBrandPopup() {
    final TextEditingController brandNameController = TextEditingController();
    final TextEditingController brandDescController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.pink[50],
              borderRadius: BorderRadius.circular(16),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Add Brand",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[300],
                    child: const Center(child: Text("IMG.BRAND")),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: brandNameController,
                    decoration: const InputDecoration(
                      labelText: "Brand Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: brandDescController,
                    decoration: const InputDecoration(
                      labelText: "Brand Description",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      String name = brandNameController.text.trim();
                      if (name.isNotEmpty) {
                        setState(() {
                          _brands.add(name);
                        });
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink[300],
                      minimumSize: const Size(double.infinity, 45),
                    ),
                    child: const Text("SAVE", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showRemoveBrandPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.pink[50],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Remove Brand",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 300,
                  child: ListView.builder(
                    itemCount: _brands.length,
                    itemBuilder: (context, index) {
                      final brand = _brands[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 3)
                          ],
                        ),
                        child: ListTile(
                          title: Text(brand),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _brands.removeAt(index);
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink[300],
                    minimumSize: const Size(double.infinity, 45),
                  ),
                  child: const Text("CLOSE", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8EDF3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5C6D3),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
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
                Text("Carmen Branch",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87)),
                Text("Thofia Concepcion (03085)",
                    style: TextStyle(fontSize: 13, color: Colors.black54)),
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
            // Search
            TextField(
              decoration: InputDecoration(
                hintText: "Search Inventory",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Buttons
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _branchButton("View Inventory", Icons.inventory_2_outlined,
                          Colors.pink[300]!, onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ViewInventory()),
                            );
                          }),
                      const SizedBox(height: 10),
                      _branchButton("Update Brands", Icons.edit_note,
                          Colors.pink[200]!, onPressed: _showUpdateBrandPopup),
                      const SizedBox(height: 10),
                      _branchButton("Remove Brand", Icons.delete_outline,
                          Colors.pink[100]!, onPressed: _showRemoveBrandPopup),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                // Low stock alert
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
                    child: const Column(
                      children: [
                        Text("LOW STOCK ALERT",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.red)),
                        SizedBox(height: 10),
                        Icon(Icons.inventory_rounded,
                            color: Colors.red, size: 40),
                        SizedBox(height: 5),
                        Text("2",
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 32,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text("1 lowproduct\n1 lowproduct",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black54, fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Calendar
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
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
                      titleTextStyle:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.pink)),
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                        color: Colors.pink.shade200, shape: BoxShape.circle),
                    selectedDecoration: BoxDecoration(
                        color: Colors.pink.shade400, shape: BoxShape.circle),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _branchButton(String label, IconData icon, Color color,
      {VoidCallback? onPressed}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(label,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
