import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vasenizzpos/inventory/inventory_screen.dart';
import 'package:vasenizzpos/sales/sales_screen.dart';
import 'package:vasenizzpos/reports/reports_page.dart';
import 'package:vasenizzpos/users/users_page.dart';

class HomeScreen extends StatefulWidget {
  final String fullName;
  final String role;
  final int initialIndex;

  const HomeScreen({
    required this.fullName,
    required this.role,
    this.initialIndex = 0,
    Key? key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _selectedIndex;
  Map<String, dynamic> _salesData = {
    'itemsSoldToday': 0,
    'totalSalesToday': 0.0,
    'totalSalesYesterday': 0.0,
  };
  List<Map<String, dynamic>> _topSelling = [];
  bool _isLoading = true;

  final shipmentData = [
    {'count': 12, 'label': 'Packages to be Shipped', 'icon': Icons.local_shipping},
    {'count': 21, 'label': 'Packages to be Delivered', 'icon': Icons.delivery_dining},
    {'count': 101, 'label': 'Items to be Invoiced', 'icon': Icons.receipt_long},
  ];

  final inventoryData = {'inStock': 5000, 'reStock': 150};

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
      final today = DateTime.now();
      final todayStart = DateTime(today.year, today.month, today.day);
      final yesterdayStart = todayStart.subtract(const Duration(days: 1));
      final yesterdayEnd = todayStart.subtract(const Duration(seconds: 1));

      // Get today's sales
      final todaySalesResponse = await Supabase.instance.client
          .from('sales')
          .select('*')
          .gte('created_at', todayStart.toIso8601String());

      final todaySales = List<Map<String, dynamic>>.from(todaySalesResponse);

      // Get yesterday's sales for comparison
      final yesterdaySalesResponse = await Supabase.instance.client
          .from('sales')
          .select('*')
          .gte('created_at', yesterdayStart.toIso8601String())
          .lte('created_at', yesterdayEnd.toIso8601String());

      final yesterdaySales = List<Map<String, dynamic>>.from(yesterdaySalesResponse);

      // Get today's sale items to count items sold
      int itemsSoldToday = 0;
      double totalSalesToday = 0.0;
      double totalSalesYesterday = 0.0;

      // Calculate today's data
      for (final sale in todaySales) {
        totalSalesToday += (sale['total_amount'] ?? 0);

        // Get sale items for this sale to count quantities
        final saleItemsResponse = await Supabase.instance.client
            .from('sale_items')
            .select('quantity')
            .eq('sale_id', sale['id']);

        final saleItems = List<Map<String, dynamic>>.from(saleItemsResponse);
        for (final item in saleItems) {
          itemsSoldToday += (item['quantity'] as int? ?? 0);
        }
      }

      // Calculate yesterday's total
      for (final sale in yesterdaySales) {
        totalSalesYesterday += (sale['total_amount'] ?? 0);
      }

      // Get top selling products (last 7 days)
      final weekAgo = today.subtract(const Duration(days: 7));
      final topSellingResponse = await Supabase.instance.client
          .from('sale_items')
          .select('''
            product_id,
            quantity,
            products(name, price)
          ''')
          .gte('created_at', weekAgo.toIso8601String());

      final topSellingItems = List<Map<String, dynamic>>.from(topSellingResponse);

      // Aggregate product sales
      final productSales = <String, Map<String, dynamic>>{};
      for (final item in topSellingItems) {
        final productId = item['product_id'].toString();
        final product = item['products'] ?? {};
        final productName = product['name'] ?? 'Unknown Product';
        final productPrice = product['price'] ?? 0.0;
        final quantity = item['quantity'] ?? 0;

        if (productSales.containsKey(productId)) {
          productSales[productId]!['quantity'] += quantity;
        } else {
          productSales[productId] = {
            'name': productName,
            'quantity': quantity,
            'price': productPrice,
          };
        }
      }

      // Convert to list and sort by quantity
      final topSellingList = productSales.values.toList();
      topSellingList.sort((a, b) => (b['quantity'] ?? 0).compareTo(a['quantity'] ?? 0));

      setState(() {
        _salesData = {
          'itemsSoldToday': itemsSoldToday,
          'totalSalesToday': totalSalesToday,
          'totalSalesYesterday': totalSalesYesterday,
        };
        _topSelling = topSellingList.take(3).toList(); // Top 3 products
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading dashboard data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  String get _salesChange {
    final today = _salesData['totalSalesToday'] ?? 0.0;
    final yesterday = _salesData['totalSalesYesterday'] ?? 0.0;

    if (yesterday == 0) {
      return today > 0 ? '+100%' : '0%';
    }

    final change = ((today - yesterday) / yesterday) * 100;
    return '${change >= 0 ? '+' : ''}${change.toStringAsFixed(0)}%';
  }

  Color get _salesChangeColor {
    final today = _salesData['totalSalesToday'] ?? 0.0;
    final yesterday = _salesData['totalSalesYesterday'] ?? 0.0;
    return today >= yesterday ? Colors.green : Colors.red;
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() => _selectedIndex = index);

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
        );
        break;
      case 2:
        nextPage = InventoryPage(
          fullName: widget.fullName,
          role: widget.role,
        );
        break;
      case 3:
        nextPage = ViewReportsPage(
          fullName: widget.fullName,
          role: widget.role,
        );
        break;
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
      backgroundColor: const Color(0xFFF8EDF3),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFF5C6D3),
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: const AssetImage('assets/logo.png'),
              radius: 22,
              backgroundColor: Colors.white,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Dashboard",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                Text(
                  "Welcome Back!\n${widget.fullName} (${widget.role})",
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black54),
            onPressed: _loadDashboardData,
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Colors.black54),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sectionTitle("Sales Activity"),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: dashboardCard(
                    icon: Icons.shopping_cart,
                    title: _isLoading ? "..." : "${_salesData['itemsSoldToday']}",
                    subtitle: "Items Sold Today",
                    extra: "Today",
                    color: Colors.pink.shade50,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _onItemTapped(1),
                    child: dashboardCard(
                      icon: Icons.attach_money_rounded,
                      title: _isLoading ? "..." : "₱${_salesData['totalSalesToday'].toStringAsFixed(2)}",
                      subtitle: "Sales Today",
                      extra: _salesChange,
                      color: Colors.orange.shade50,
                      extraColor: _salesChangeColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            for (var data in shipmentData)
              shipmentCard(
                data['count'].toString(),
                data['label'].toString(),
                data['icon'] as IconData,
              ),
            const SizedBox(height: 25),
            sectionTitle("Inventory Summary (In Quantity)"),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                    child: inventoryBox(
                        "In-stock", inventoryData['inStock'].toString(), Colors.redAccent)),
                const SizedBox(width: 10),
                Expanded(
                    child: inventoryBox(
                        "Re-stock", inventoryData['reStock'].toString(), Colors.green)),
              ],
            ),
            const SizedBox(height: 25),
            sectionTitle("Top Selling (Last 7 Days)"),
            const SizedBox(height: 10),
            buildTopSellingTable(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.black54,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Sales"),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: "Inventory"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Report"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3)],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }

  Widget dashboardCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String extra,
    required Color color,
    Color? extraColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.pink.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.pinkAccent),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Colors.black54)),
          Text(
            extra,
            style: TextStyle(
              color: extraColor ?? (extra.contains('-') ? Colors.red : Colors.green),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget shipmentCard(String count, String label, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3)],
      ),
      child: Row(
        children: [
          Text(
            count,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.pink),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
          Icon(icon, color: Colors.teal, size: 26),
        ],
      ),
    );
  }

  Widget inventoryBox(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Center(
            child: Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTopSellingTable() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3)],
      ),
      child: Column(
        children: [
          Row(
            children: const [
              Expanded(flex: 2, child: Text("Name", style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(child: Text("Sold", style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(child: Text("Price", style: TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
          const Divider(),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_topSelling.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text('No sales data available', style: TextStyle(color: Colors.grey)),
            )
          else
            ..._topSelling.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      item['name']?.toString() ?? 'Unknown Product',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${item['quantity'] ?? 0}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '₱${(item['price'] ?? 0).toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            )).toList(),
        ],
      ),
    );
  }
}