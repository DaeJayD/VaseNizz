import 'package:flutter/material.dart';

class ActivityLogsPage extends StatelessWidget {
  final List<Map<String, String>> logs;

  ActivityLogsPage({Key? key, required this.logs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 50, bottom: 20, left: 20, right: 20),
            decoration: BoxDecoration(
              color: Colors.pink[200],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage('assets/logo.png'), // Replace with your logo
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Activity Logs",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Thofia Concepcion (03085)",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.notifications_none, size: 28),
              ],
            ),
          ),

          // Search & Filters
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: "Search by user, activity, product, branch, date",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        items: ["All activity", "Ex.Sold", "Ex.Updated"]
                            .map((e) => DropdownMenuItem(child: Text(e), value: e))
                            .toList(),
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        hint: Text("All activity"),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        items: ["All Products", "Lipgloss", "Foundation"]
                            .map((e) => DropdownMenuItem(child: Text(e), value: e))
                            .toList(),
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        hint: Text("All Products"),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        items: ["All Time", "Today", "This Week", "This Month"]
                            .map((e) => DropdownMenuItem(child: Text(e), value: e))
                            .toList(),
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        hint: Text("All Time"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Logs Table
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Timestamp')),
                    DataColumn(label: Text('User')),
                    DataColumn(label: Text('Activity')),
                    DataColumn(label: Text('Branch')),
                    DataColumn(label: Text('Product')),
                  ],
                  rows: logs
                      .map(
                        (log) => DataRow(cells: [
                      DataCell(Text(log['timestamp'] ?? "")),
                      DataCell(Text(log['user'] ?? "")),
                      DataCell(Text(log['activity'] ?? "")),
                      DataCell(Text(log['branch'] ?? "")),
                      DataCell(Text(log['product'] ?? "")),
                    ]),
                  )
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),

      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Sales"),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: "Inventory"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Report"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        currentIndex: 3,
        onTap: (index) {},
      ),
    );
  }
}
