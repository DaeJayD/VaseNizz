import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vasenizzpos/inventory/add_new_item.dart';

class BrandInventoryPage extends StatefulWidget {
  final String brandName;
  final String fullName;
  final String role;
  final String branchManager;
  final String branchCode;
  final String branchName;
  final String? brandId;
  final String userId;

  const BrandInventoryPage({
    super.key,
    required this.brandName,
    required this.fullName,
    required this.role,
    required this.branchManager,
    required this.branchCode,
    required this.branchName,
    required this.userId,
    this.brandId,
  });

  @override
  State<BrandInventoryPage> createState() => _BrandInventoryPageState();
}

class _BrandInventoryPageState extends State<BrandInventoryPage> {
  final SupabaseClient _supabase = Supabase.instance.client;
  bool removeMode = false;
  bool _isLoading = true;
  List<dynamic> _products = [];
  String? _brandId;
  String? _branchId;
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
    _searchController.addListener(_filterProducts);
  }

  Future<void> _initializeData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Use provided brandId if available, otherwise query by name
      if (widget.brandId != null) {
        _brandId = widget.brandId;
      } else {
        final brandResult = await _supabase
            .from('brands')
            .select('id')
            .eq('name', widget.brandName)
            .single();
        _brandId = brandResult['id'];
      }

      // Get branch ID
      final branchResult = await _supabase
          .from('branches')
          .select('id')
          .eq('name', widget.branchName)
          .single();
      _branchId = branchResult['id'];

      await _loadProducts();
    } catch (e) {
      print('Error initializing data: $e');
      _showErrorSnackbar('Failed to load inventory data');
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadProducts() async {
    try {
      // Load products for this brand in the specific branch
      final result = await _supabase
          .from('products')
          .select('''
            *,
            categories(name),
            branch_stock!inner(
              current_stock,
              low_stock_threshold
            )
          ''')
          .eq('brand_id', _brandId!)
          .eq('branch_stock.branch_id', _branchId!)
          .order('name');

      setState(() {
        _products = result;
        _filteredProducts = result;
      });
    } catch (e) {
      print('Error loading products: $e');
      _showErrorSnackbar('Failed to load products');
    }
  }

  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = _products;
      } else {
        _filteredProducts = _products.where((product) {
          final productName = product['name']?.toString().toLowerCase() ?? '';
          final productSku = product['sku']?.toString().toLowerCase() ?? '';
          final categoryName = product['categories']?['name']?.toString().toLowerCase() ?? '';
          return productName.contains(query) ||
              productSku.contains(query) ||
              categoryName.contains(query);
        }).toList();
      }
    });
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showRemoveDialog(int index) {
    final TextEditingController qtyController = TextEditingController();
    final product = _filteredProducts[index];
    final currentStock = product['branch_stock'][0]['current_stock'] ?? 0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Remove from ${product['name']}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Available stock: $currentStock"),
              const SizedBox(height: 10),
              TextField(
                controller: qtyController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Quantity to remove",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                final int removeQty = int.tryParse(qtyController.text) ?? 0;
                if (removeQty > 0 && removeQty <= currentStock) {
                  try {
                    // Update stock in database
                    await _supabase
                        .from('branch_stock')
                        .update({
                      'current_stock': currentStock - removeQty,
                      'last_updated': DateTime.now().toIso8601String(),
                    })
                        .eq('product_id', product['id'])
                        .eq('branch_id', _branchId!);

                    // Record inventory movement
                    await _supabase
                        .from('inventory_movements')
                        .insert({
                      'product_id': product['id'],
                      'branch_id': _branchId!,
                      'movement_type': 'out',
                      'quantity': removeQty,
                      'previous_stock': currentStock,
                      'new_stock': currentStock - removeQty,
                      'username': widget.fullName,
                      'user_id': widget.userId,
                      'reason': 'Manual stock adjustment',
                    });

                    await _loadProducts(); // Refresh data
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Removed $removeQty from ${product['name']}'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error updating stock: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Invalid quantity entered")),
                  );
                }
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  void _addStock(int index) async {
    final product = _filteredProducts[index];
    final currentStock = product['branch_stock'][0]['current_stock'] ?? 0;

    try {
      // Update stock in database
      await _supabase
          .from('branch_stock')
          .update({
        'current_stock': currentStock + 1,
        'last_updated': DateTime.now().toIso8601String(),
      })
          .eq('product_id', product['id'])
          .eq('branch_id', _branchId!);

      // Record inventory movement
      await _supabase
          .from('inventory_movements')
          .insert({
        'product_id': product['id'],
        'branch_id': _branchId!,
        'movement_type': 'in',
        'quantity': 1,
        'previous_stock': currentStock,
        'new_stock': currentStock + 1,
        'user_id': widget.userId,
        'username': widget.fullName,
        'reason': 'Manual stock adjustment',
      });

      await _loadProducts(); // Refresh data

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added 1 to ${product['name']}'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating stock: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _tableRow(dynamic product, int index) {
    final branchStock = product['branch_stock'][0];
    final currentStock = branchStock['current_stock'] ?? 0;
    final lowStockThreshold = branchStock['low_stock_threshold'] ?? 10;
    final isLowStock = currentStock <= lowStockThreshold;

    return Container(
      color: isLowStock ? Colors.red[50] : (index % 2 == 0 ? Colors.pink[50] : Colors.white),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          _TableCell(product['name'] ?? 'Unknown'),
          _TableCell(product['sku'] ?? '—'),
          _TableCell(product['categories']?['name'] ?? '—'),
          _TableCell('₱${(product['price'] ?? 0).toStringAsFixed(2)}'),
          _TableCell('0'), // You might want to calculate "out" from sales data
          _TableCell(
            currentStock.toString(),
            textColor: isLowStock ? Colors.red : Colors.black87,
            isBold: isLowStock,
          ),
          Expanded(
            child: Center(
              child: IconButton(
                icon: Icon(
                  removeMode ? Icons.delete_outline : Icons.add_circle_outline,
                  color: removeMode ? Colors.redAccent : Colors.green,
                ),
                onPressed: () {
                  if (removeMode) {
                    _showRemoveDialog(index);
                  } else {
                    _addStock(index);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8EDF3),
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundColor: Colors.white,
              child: Icon(Icons.business, color: Colors.orangeAccent),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.brandName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white),
                ),
                Text(
                  "${widget.branchManager} (${widget.branchCode}) - ${widget.branchName}",
                  style: const TextStyle(fontSize: 13, color: Colors.white70),
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              children: [
                _smallButton(
                  "Refresh",
                  Colors.white,
                  Colors.orangeAccent,
                  _loadProducts,
                ),
                const SizedBox(width: 8),
                _smallButton(
                  removeMode ? "Done" : "Remove Stock",
                  Colors.white,
                  Colors.redAccent,
                      () {
                    setState(() {
                      removeMode = !removeMode;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orangeAccent))
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search and filter bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black26),
              ),
              child: Row(
                children: [
                  Text(
                    "${_filteredProducts.length} Products in ${widget.branchName}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const Spacer(),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: "Search products...",
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _actionButton("Filter"),
                  const SizedBox(width: 8),
                  _actionButton("Sort"),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _smallButton(
              "Add Item",
              Colors.white,
              Colors.green,
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddNewItemPage(
                      brandId: _brandId,
                      branchId: _branchId,
                      brandName: widget.brandName,
                      branchName: widget.branchName,
                    ),
                  ),
                );
              },
            ),

            // Products table
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    // Table header
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      color: Colors.pink[50],
                      child: const Row(
                        children: [
                          _TableHeaderCell("Name"),
                          _TableHeaderCell("SKU"),
                          _TableHeaderCell("Category"),
                          _TableHeaderCell("Price"),
                          _TableHeaderCell("Out"),
                          _TableHeaderCell("In stock"),
                          _TableHeaderCell("Action"),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: Colors.black26),

                    // Products list
                    Expanded(
                      child: _filteredProducts.isEmpty
                          ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
                            const SizedBox(height: 16),
                            const Text('No products found for this brand'),
                            Text('in ${widget.branchName}'),
                            if (_searchController.text.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                'Search: "${_searchController.text}"',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ],
                        ),
                      )
                          : ListView.builder(
                        itemCount: _filteredProducts.length,
                        itemBuilder: (context, index) =>
                            _tableRow(_filteredProducts[index], index),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _smallButton(
      String text, Color bg, Color borderColor, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: TextStyle(color: borderColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _actionButton(String text) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      onPressed: () {},
      child: Text(
        text,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class _TableHeaderCell extends StatelessWidget {
  final String text;
  const _TableHeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;
  final Color textColor;
  final bool isBold;

  const _TableCell(this.text, {this.textColor = Colors.black87, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: textColor,
          fontSize: 13,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}