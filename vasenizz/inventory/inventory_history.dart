import 'package:flutter/material.dart';

class InventoryHistoryScreen extends StatelessWidget {
  const InventoryHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> historyData = [
      {
        "date": "2025-10-20",
        "time": "09:30",
        "product": "Vasenizz Moisture Cream",
        "brand": "Vasenizz",
        "qty": "+15",
        "category": "Skincare",
        "sku": "VSN-001"
      },
      {
        "date": "2025-10-19",
        "time": "14:12",
        "product": "Vasenizz Toner",
        "brand": "Vasenizz",
        "qty": "-5",
        "category": "Toner",
        "sku": "VSN-002"
      },
      {
        "date": "2025-10-18",
        "time": "10:45",
        "product": "Vasenizz Sunscreen",
        "brand": "Vasenizz",
        "qty": "+30",
        "category": "Suncare",
        "sku": "VSN-003"
      },
      {
        "date": "2025-10-17",
        "time": "16:00",
        "product": "Vasenizz Cleanser",
        "brand": "Vasenizz",
        "qty": "-8",
        "category": "Cleansing",
        "sku": "VSN-004"
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8EDF3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5C6D3),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/logo.png'),
              radius: 22,
              backgroundColor: Colors.white,
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Inventory History",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                Text(
                  "Thofia Concepcion (03085)",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded,
                color: Colors.black54),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTimeHeader(),
            const SizedBox(height: 16),
            _buildInsertButton(),
            const SizedBox(height: 20),
            _buildSearchSection(),
            const SizedBox(height: 20),
            _buildHistoryTable(historyData),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.access_time, size: 16, color: Colors.pink),
          SizedBox(width: 8),
          Text(
            "9:41",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildInsertButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.pink.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.pink.shade200),
      ),
      child: const Column(
        children: [
          Icon(Icons.add_circle_outline, color: Colors.pink, size: 24),
          SizedBox(height: 6),
          Text(
            "[Insert]",
            style: TextStyle(
                fontSize: 12, color: Colors.pink, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Search Inventory History",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8EDF3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by product, brand, or date...',
                border: InputBorder.none,
                suffixIcon: Icon(Icons.search, color: Colors.pink.shade300),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTable(List<Map<String, dynamic>> data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Stock Change History",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const Divider(height: 20, color: Colors.black26),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 24,
              columns: const [
                DataColumn(label: Text("Date", style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text("Time", style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text("Product", style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text("Brand", style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text("Qty", style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text("Category", style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text("SKU", style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: data.map((item) {
                final bool isPositive = item["qty"].toString().startsWith("+");
                return DataRow(
                  cells: [
                    DataCell(Text(item["date"])),
                    DataCell(Text(item["time"])),
                    DataCell(Text(item["product"])),
                    DataCell(Text(item["brand"])),
                    DataCell(Text(
                      item["qty"],
                      style: TextStyle(
                          color: isPositive ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold),
                    )),
                    DataCell(Text(item["category"])),
                    DataCell(Text(item["sku"])),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
