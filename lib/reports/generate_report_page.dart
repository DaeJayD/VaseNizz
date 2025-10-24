import 'package:flutter/material.dart';

class GenerateReportPage extends StatelessWidget {
  const GenerateReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8E4EC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8C8D9),
        title: const Text("Generate Reports",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Report Configuration",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 4)
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _dropdownField("Date Range", "Last Week"),
                    const SizedBox(width: 10),
                    _dropdownField("Export Format", "PDF"),
                    const SizedBox(width: 10),
                    _dropdownField("Category", "By Branch"),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              _reportCard(Icons.inventory_2_rounded, "Inventory Summary Report",
                  "Overview of current stock levels."),
              _reportCard(Icons.list_alt, "Total Stock Report",
                  "Detailed analysis of stock movement."),
              _reportCard(Icons.group, "Employee Attendance",
                  "Logs of employee time-in records."),
              _reportCard(Icons.pie_chart_rounded, "Sales Report",
                  "Summary of sales analytics."),
              const SizedBox(height: 22),
              const Text("Recent Reports",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              _recentReportCard(
                  "Inventory Summary – January 2025", "2025-01-30", "PDF", "2.3 MB"),
              _recentReportCard(
                  "Sales Performance Q4 2024", "2025-01-28", "PDF", "4.1 MB"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dropdownField(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 12, color: Colors.black54)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black26),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                items: [value]
                    .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                    .toList(),
                onChanged: (_) {},
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _reportCard(IconData icon, String title, String desc) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3)],
      ),
      child: Row(
        children: [
          Icon(icon, size: 35, color: Colors.black54),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                Text(desc, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          Column(
            children: [
              _smallButton("Preview"),
              const SizedBox(height: 6),
              _smallButton("Generate", primary: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _smallButton(String text, {bool primary = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: primary ? const Color(0xFF1E88E5) : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text,
          style: TextStyle(
              color: primary ? Colors.white : Colors.black87, fontSize: 12)),
    );
  }

  Widget _recentReportCard(
      String title, String date, String format, String size) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3)],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                Text("Generated on $date • $format • $size",
                    style:
                    const TextStyle(color: Colors.black54, fontSize: 12)),
              ],
            ),
          ),
          _smallButton("Download", primary: true),
        ],
      ),
    );
  }
}
