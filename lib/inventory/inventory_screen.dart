import 'package:flutter/material.dart';
import 'package:vasenizzpos/dashboard/home_screen.dart';
import 'package:vasenizzpos/sales/sales_screen.dart';
import 'package:vasenizzpos/reports/reports_page.dart';
import 'package:vasenizzpos/users/users_page.dart';
import 'package:vasenizzpos/services/inventory_service.dart';
import 'inventory_history.dart';

class InventoryPage extends StatefulWidget {
  final String fullName;
  final String role;
  final int initialIndex;

  const InventoryPage({
    required this.fullName,
    required this.role,
    this.initialIndex = 2,
    super.key,
  });

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  late int _selectedIndex;
  final InventoryService _inventoryService = InventoryService();
  List<dynamic> _stockData = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _loadStockData();
  }

  Future<void> _loadStockData() async {
    setState(() {
      _isLoading = true;
    });

    // Load low stock items across all branches
    final result = await _inventoryService.getStockSummary();

    if (result['error'] == null) {
      setState(() {
        _stockData = result['data'] ?? [];
      });
    } else {
      // Fallback to mock data if API fails
      setState(() {
        _stockData = List.generate(12, (index) => {
          'sid': 'EX-${index + 1}',
          'productId': 'PID${1000 + index}',
          'brand': 'Beauty Wise',
          'name': 'Product ${index + 1}',
          'current_stock': 20 + index,
          'low_stock_threshold': 10,
          'products': {'name': 'Product ${index + 1}', 'sku': 'SKU${1000 + index}'},
          'branches': {'name': 'JASAAN BRANCH'},
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Using demo data: ${result['error']}')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

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
          initialIndex: 1,
        );
        break;
      case 2:
        nextPage = InventoryPage(
          fullName: widget.fullName,
          role: widget.role,
          initialIndex: 2,
        );
        break;
      case 3:
        nextPage = InventoryPage( // Changed from SalesScreen to ReportsPage
          fullName: widget.fullName,
          role: widget.role,
          initialIndex: 3,
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

  void _showBranchSelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "SELECT BRANCH",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              _branchButton(
                context,
                icon: Icons.manage_accounts,
                label: "MANAGE ALL",
                color: Colors.pink.shade300,
                onTap: () {
                  Navigator.pop(context);
                  _loadStockData(); // Reload all branches data
                },
              ),
              const SizedBox(height: 10),
              _branchButton(
                context,
                icon: Icons.home,
                label: "JASAAN BRANCH",
                color: Colors.pink.shade200,
                onTap: () {
                  Navigator.pop(context);
                  _loadBranchInventory("JASAAN");
                },
              ),
              const SizedBox(height: 10),
              _branchButton(
                context,
                icon: Icons.home,
                label: "PUERTO BRANCH",
                color: Colors.pink.shade200,
                onTap: () {
                  Navigator.pop(context);
                  _loadBranchInventory("PUERTO");
                },
              ),
              const SizedBox(height: 10),
              _branchButton(
                context,
                icon: Icons.home,
                label: "CARMEN BRANCH",
                color: Colors.pink.shade200,
                onTap: () {
                  Navigator.pop(context);
                  _loadBranchInventory("CARMEN");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadBranchInventory(String branchName) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _inventoryService.getBranchInventory(branchName);

      if (result['error'] == null) {
        setState(() {
          _stockData = result['data'] ?? [];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Loaded $branchName Branch Inventory')),
        );
      } else {
        // If branch doesn't exist, show all data with branch filter note
        await _loadStockData();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$branchName branch not found, showing all branches')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading branch: $e')),
      );
      await _loadStockData(); // Fallback to all data
    }

    setState(() {
      _isLoading = false;
    });
  }

  Widget _branchButton(
      BuildContext context, {
        required IconData icon,
        required String label,
        required Color color,
        required VoidCallback onTap,
      }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        label,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // Filter stock data based on search query
  List<dynamic> get _filteredStockData {
    if (_searchQuery.isEmpty) return _stockData;

    return _stockData.where((item) {
      final product = item['products'] ?? {};
      final productName = product['name']?.toString().toLowerCase() ?? '';
      final brand = product['brands']?['name']?.toString().toLowerCase() ?? '';
      final sku = product['sku']?.toString().toLowerCase() ?? '';
      final query = _searchQuery.toLowerCase();

      return productName.contains(query) ||
          brand.contains(query) ||
          sku.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8EDF3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5C6D3),
        elevation: 0,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/logo.png'),
              radius: 20,
              backgroundColor: Colors.white,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.fullName} (${widget.role})",
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Search by Name, Brand, or Product ID",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showBranchSelector(context),
                    icon: const Icon(Icons.bar_chart, size: 26),
                    label: const Text(
                      "📊 Inventory Monitor",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink[300],
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InventoryHistoryScreen(
                            fullName: widget.fullName,
                            role: widget.role,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.history, size: 26),
                    label: const Text(
                      "📜 Inventory History",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink[200],
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Stock list
      Expanded(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.pink))
            : RefreshIndicator(
          onRefresh: _loadStockData,
          color: Colors.pink,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3)],
            ),
            child: _filteredStockData.isEmpty
                ? const Center(
              child: Text(
                'No low stock items found',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
                : ListView.builder(
              itemCount: _filteredStockData.length,
              itemBuilder: (context, index) {
                    final item = _filteredStockData[index];
                    final product = item['products'] ?? {};
                    final branch = item['branches'] ?? {};
                    final currentStock = item['current_stock'] ?? 0;
                    final threshold = item['low_stock_threshold'] ?? 10;

                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
                        ),
                        color: currentStock <= threshold ? Colors.red.shade50 : null,
                      ),
                      child: Row(
                        children: [
                          Expanded(flex: 1, child: Center(child: Text('${index + 1}'))),
                          Expanded(flex: 2, child: Center(child: Text(product['sku']?.toString() ?? 'N/A'))),
                          Expanded(flex: 2, child: Center(child: Text(product['brands']?['name']?.toString() ?? 'N/A'))),
                          Expanded(flex: 2, child: Center(child: Text(product['name']?.toString() ?? 'N/A'))),
                          Expanded(flex: 1, child: Center(
                            child: Text(
                              currentStock.toString(),
                              style: TextStyle(
                                color: currentStock <= threshold ? Colors.red : Colors.black,
                                fontWeight: currentStock <= threshold ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          )),
                          Expanded(flex: 1, child: Center(child: Text(threshold.toString()))),
                          Expanded(flex: 2, child: Center(child: Text(branch['name']?.toString() ?? 'N/A'))),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
      )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.black54,
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
}