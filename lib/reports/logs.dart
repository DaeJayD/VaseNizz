import 'package:flutter/material.dart';

class ActivityLogsPage extends StatelessWidget {
  final List<Map<String, String>> logs;

  const ActivityLogsPage({Key? key, required this.logs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          // Header with Back Button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 20, left: 20, right: 20),
            decoration: BoxDecoration(
              color: Colors.pink[200],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Back button
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 10),

                // Logo
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      "LOGO",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 15),

                // Title and Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Activity Logs",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        "Thofia Concepcion (03085)",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),

                const Icon(Icons.notifications_none, color: Colors.white, size: 28),
              ],
            ),
          ),

          // Search & Filters
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                // Search bar
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: "Search by user, activity, product, branch, date",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),

                // Dropdown filters
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        items: ["All activity", "Sold", "Updated"]
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        hint: const Text("All activity"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        items: ["All Products", "Lipgloss", "Foundation"]
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        hint: const Text("All Products"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        items: ["All Time", "Today", "This Week", "This Month"]
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        hint: const Text("All Time"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Logs Table
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(Colors.pink[100]),
                    columns: const [
                      DataColumn(label: Text('Time')),
                      DataColumn(label: Text('User')),
                      DataColumn(label: Text('Action')),
                      DataColumn(label: Text('Description')),
                    ],
                    rows: logs.asMap().entries.map(
                          (entry) {
                        final index = entry.key;
                        final log = entry.value;
                        return DataRow(
                          color: MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                              return index % 2 == 0 ? Colors.white : Colors.grey[100];
                            },
                          ),
                          cells: [
                            DataCell(Text(log['time'] ?? "")),
                            DataCell(Text(log['user'] ?? "")),
                            DataCell(Text(log['action'] ?? "")),
                            DataCell(Text(log['description'] ?? "")),
                          ],
                        );
                      },
                    ).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}