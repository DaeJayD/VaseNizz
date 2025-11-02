import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'generate_report_page.dart';
import 'package:vasenizzpos/dashboard/home_screen.dart';
import 'package:vasenizzpos/sales/sales_screen.dart';
import 'package:vasenizzpos/inventory/inventory_screen.dart';
import 'package:vasenizzpos/users/users_page.dart';
import 'logs.dart';

class ViewReportsPage extends StatefulWidget {
  final String fullName;
  final String role;
  final String userId;
  final String location;
  final int initialIndex;

  const ViewReportsPage({
    required this.fullName,
    required this.role,
    required this.userId,
    required this.location,
    this.initialIndex = 3,
    super.key,
  });

  @override
  State<ViewReportsPage> createState() => _ViewReportsPageState();
}

class _ViewReportsPageState extends State<ViewReportsPage> {
  late int _selectedIndex;
  String selectedRange = "1W";

  List<Map<String, String>> logs = [
    {
      'action': 'Product Added',
      'description': 'SPF 50+++ sunscreen added to inventory',
      'time': '2 hours ago',
      'user': 'Thofia Concepcion'
    },
    {
      'action': 'Sale Completed',
      'description': 'Online order #12345 completed',
      'time': '5 hours ago',
      'user': 'System'
    },
    {
      'action': 'Low Stock Alert',
      'description': 'Beauty Wise foundation running low',
      'time': '1 day ago',
      'user': 'Inventory System'
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onNavTapped(int index) {
    if (index == _selectedIndex) return;

    Widget target;
    switch (index) {
      case 0:
        target = HomeScreen(
          fullName: widget.fullName,
          role: widget.role,
          userId: widget.userId,
          location: widget.location,
          initialIndex: 0,
        );
        break;
      case 1:
        target = SalesScreen(
          fullName: widget.fullName,
          role: widget.role,
          userId: widget.userId,
          location: widget.location,
        );
        break;
      case 2:
        target = InventoryPage(
          fullName: widget.fullName,
          role: widget.role,
          userId: widget.userId,
          location: widget.location,
        );
        break;
      case 3:
        target = ViewReportsPage(
          fullName: widget.fullName,
          role: widget.role,
          userId: widget.userId,
          location: widget.location,
        );
        break;
      case 4:
        target = UsersPage(
          fullName: widget.fullName,
          role: widget.role,
          userId: widget.userId,
          location: widget.location,
        );
        break;
      default:
        target = ViewReportsPage(
          fullName: widget.fullName,
          role: widget.role,
          userId: widget.userId,
          location: widget.location,
        );
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => target,
        transitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8E4EC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8C8D9),
        elevation: 0,
        toolbarHeight: 90,
        title: Row(
          children: [
            Container(
              width: 55,
              height: 55,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text("LOGO", style: TextStyle(fontSize: 12)),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.fullName,
                    style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(widget.role,
                    style: const TextStyle(fontSize: 13, color: Colors.black54)),
              ],
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ActivityLogsPage(logs: logs),
                  ),
                );
              },
              icon: const Icon(Icons.article_outlined,
                  size: 16, color: Colors.black),
              label: const Text("Logs",
                  style: TextStyle(color: Colors.black, fontSize: 13)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.notifications_none_rounded,
                color: Colors.white, size: 28),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _tabButton("Analytics Dashboard", true),
                const SizedBox(width: 8),
                _tabButton("Generate Report", false, onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GenerateReportPage()),
                  );
                }),
              ],
            ),
            const SizedBox(height: 20),
            const Text("Sales Overview",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins")),
            const Divider(thickness: 1),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _statCard(Icons.store, "1,100", "In-Store Orders",
                    const Color(0xFFFAC7D0)),
                _statCard(Icons.shopping_bag, "578", "Online Orders",
                    const Color(0xFFD2C6FC)),
              ],
            ),
            const SizedBox(height: 25),
            Center(
              child: Wrap(
                spacing: 6,
                children: ["1D", "1W", "1M", "3M", "6M", "1Yr"]
                    .map((r) => ChoiceChip(
                  label: Text(r),
                  selected: selectedRange == r,
                  selectedColor: const Color(0xFFD2C6FC),
                  onSelected: (_) =>
                      setState(() => selectedRange = r),
                ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 25),
            const Text("Revenue",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 5),
            Row(
              children: const [
                Text("₱21,452.57",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)),
                SizedBox(width: 10),
                Chip(
                    label: Text("+7.6%"),
                    backgroundColor: Color(0xFFD8F9D4),
                    labelStyle: TextStyle(color: Colors.green)),
              ],
            ),
            const SizedBox(height: 20),
            _buildLineChart(),
            const SizedBox(height: 30),
            const Text("Inventory by Brand",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins")),
            const Divider(thickness: 1),
            const SizedBox(height: 15),
            _buildBrandInventory("Beauty Wise", "70 Products * 2",
                hasLowStock: true),
            const SizedBox(height: 12),
            _buildBrandInventory("Brand2", "Total Prod. * Recently added prod.",
                showLow: true),
            const SizedBox(height: 12),
            _buildBrandInventory("Brand3", "Total Prod. * Recently added prod.",
                showLow: true),
            const SizedBox(height: 30),
            const Text("Top Selling Products",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins")),
            const Divider(thickness: 1),
            const SizedBox(height: 15),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _topSellingProductCard("SPF 50+++", "267"),
                _topSellingProductCard("Product1", "124"),
                _topSellingProductCard("Product2", "88"),
                _topSellingProductCard("Product3", "450"),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.black54,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Sales"),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: "Inventory"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Report"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget _buildLineChart() {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const days = ["M", "T", "W", "T", "F", "S", "S"];
                  return Text(days[value.toInt() % days.length]);
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 2),
                FlSpot(1, 3),
                FlSpot(2, 2.5),
                FlSpot(3, 3.5),
                FlSpot(4, 4.5),
                FlSpot(5, 2),
                FlSpot(6, 1.8),
              ],
              color: const Color(0xFF9C89E9),
              barWidth: 3,
              isCurved: true,
              belowBarData: BarAreaData(
                show: true,
                color: const Color(0xFF9C89E9).withOpacity(0.2),
              ),
              dotData: const FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandInventory(String brandName, String details,
      {bool hasLowStock = false, bool showLow = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(brandName,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(details,
                    style:
                    const TextStyle(fontSize: 14, color: Colors.black54)),
              ],
            ),
          ),
          if (hasLowStock || showLow)
            Row(
              children: [
                Checkbox(
                    value: false,
                    onChanged: (value) {},
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
                Text(
                  hasLowStock ? "a low stock" : "show low *",
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _topSellingProductCard(String productName, String salesCount) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFF8C8D9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.image, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(productName,
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.arrow_upward, color: Colors.green, size: 16),
              Text(salesCount,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tabButton(String label, bool active, {VoidCallback? onTap}) {
    return ElevatedButton(
      onPressed: onTap ?? () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: active ? const Color(0xFFD8D0D0) : Colors.grey.shade200,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: active ? Colors.black : Colors.grey,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _statCard(IconData icon, String value, String label, Color bgColor) {
    return Container(
      width: 150,
      height: 100,
      decoration:
      BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.black54, size: 28),
          const SizedBox(height: 8),
          Text(value,
              style:
              const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
