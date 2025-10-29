import 'package:flutter/material.dart';
import 'package:vasenizzpos/sales/checkout_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BrandProductsPage extends StatefulWidget {
  final Map<String, dynamic> brand;
  final String fullName;
  final String role;
  final List<Map<String, dynamic>>? existingCart;

  const BrandProductsPage({
    Key? key,
    required this.brand,
    required this.fullName,
    required this.role,
    this.existingCart,
  }) : super(key: key);

  @override
  _BrandProductsPageState createState() => _BrandProductsPageState();
}

class _BrandProductsPageState extends State<BrandProductsPage> {
  final List<Map<String, dynamic>> cart = [];
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _filteredProducts = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  bool _hasError = false;
  int _currentPage = 0;
  final int _pageSize = 10;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingCart != null) {
      cart.addAll(widget.existingCart!);
    }
    _loadProducts();
    _searchController.addListener(_filterProducts);
  }

  Future<void> _loadProducts({bool loadMore = false}) async {
    if (_isLoadingMore) return;

    try {
      if (!loadMore) {
        setState(() {
          _isLoading = true;
          _hasError = false;
          _currentPage = 0;
        });
      } else {
        setState(() {
          _isLoadingMore = true;
        });
      }

      final from = _currentPage * _pageSize;
      final to = from + _pageSize - 1;

      final response = await Supabase.instance.client
          .from('products')
          .select('''
            *,
            categories(name)
          ''')
          .eq('brand_id', widget.brand['id'])
          .range(from, to)
          .order('name');

      setState(() {
        if (loadMore) {
          _products.addAll(List<Map<String, dynamic>>.from(response));
        } else {
          _products = List<Map<String, dynamic>>.from(response);
        }
        _filteredProducts = _products;
        _hasMore = response.length == _pageSize;
        _isLoading = false;
        _isLoadingMore = false;
        if (loadMore) _currentPage++;
      });
    } catch (e) {
      print('Error loading products: $e');
      setState(() {
        _isLoading = false;
        _hasError = true;
        _isLoadingMore = false;
      });
    }
  }

  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _products.where((product) {
        final productName = product['name']?.toString().toLowerCase() ?? '';
        final productSku = product['sku']?.toString().toLowerCase() ?? '';
        final categoryName = product['categories']?['name']?.toString().toLowerCase() ?? '';
        return productName.contains(query) ||
            productSku.contains(query) ||
            categoryName.contains(query);
      }).toList();
    });
  }

  void addToCart(Map<String, dynamic> product) {
    if (product['stock'] <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${product['name']} is out of stock')),
      );
      return;
    }

    final existingItem = cart.firstWhere(
          (item) => item['id'] == product['id'],
      orElse: () => {},
    );

    final currentCartQty = (existingItem['cart_quantity'] as int?) ?? 0;
    if (currentCartQty >= product['stock']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot add more than available stock')),
      );
      return;
    }

    setState(() {
      if (existingItem.isEmpty) {
        // Add new item to cart
        cart.add({
          ...product,
          'cart_quantity': 1,
        });
      } else {
        // Update existing item quantity
        final index = cart.indexWhere((item) => item['id'] == product['id']);
        cart[index]['cart_quantity'] = (cart[index]['cart_quantity'] as int) + 1;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product['name']} added to cart')),
    );
  }

  void _loadNextPage() {
    if (_hasMore && !_isLoadingMore) {
      _loadProducts(loadMore: true);
    }
  }

  int get _totalCartItems {
    return cart.fold<int>(0, (sum, item) => sum + (item['cart_quantity'] as int));
  }

  String _getBrandInitial(String brandName) {
    if (brandName.isEmpty) return 'B';
    return brandName[0].toUpperCase();
  }

  Color _getBrandColor(String brandName) {
    final colors = [
      Color(0xFF7FC8F8), // Blue
      Color(0xFFF5C6D3), // Pink
      Color(0xFFC6F5D3), // Green
      Color(0xFFF5E6C6), // Yellow
      Color(0xFFD3C6F5), // Purple
    ];
    final index = brandName.hashCode % colors.length;
    return colors[index];
  }

  void _goToCheckout() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutPage(
          cartItems: cart,
          fullName: widget.fullName,
          role: widget.role,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8EDF3),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7FC8F8),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: _getBrandColor(widget.brand['name']),
              radius: 20,
              child: Text(
                _getBrandInitial(widget.brand['name']),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.brand['name'],
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  if (widget.brand['description'] != null)
                    Text(
                      widget.brand['description'],
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                onPressed: cart.isEmpty ? null : _goToCheckout,
              ),
              if (cart.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      _totalCartItems.toString(),
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadProducts,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search products by name, SKU, or category",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: _buildProductGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading products...'),
          ],
        ),
      );
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text('Failed to load products'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadProducts,
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_filteredProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              _searchController.text.isEmpty
                  ? 'No products available for ${widget.brand['name']}'
                  : 'No products found for "${_searchController.text}"',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent && _hasMore) {
          _loadNextPage();
        }
        return false;
      },
      child: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemCount: _filteredProducts.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _filteredProducts.length && _isLoadingMore) {
            return Center(child: CircularProgressIndicator());
          }

          final product = _filteredProducts[index];
          final inCart = cart.any((item) => item['id'] == product['id']);
          final cartQuantity = inCart
              ? (cart.firstWhere((item) => item['id'] == product['id'])['cart_quantity'] as int)
              : 0;

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Product Image/Icon
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.shopping_bag,
                        size: 40,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Product Name
                  Text(
                    product['name'] ?? 'Unnamed Product',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),

                  // SKU
                  if (product['sku'] != null)
                    Text(
                      'SKU: ${product['sku']}',
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    ),

                  // Category
                  if (product['categories'] != null)
                    Text(
                      product['categories']['name'],
                      style: TextStyle(fontSize: 10, color: Colors.blue[600]),
                    ),

                  // Price and Stock
                  Text(
                    '₱${(product['price'] ?? 0).toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),

                  Text(
                    'Stock: ${product['stock'] ?? 0}',
                    style: TextStyle(
                      fontSize: 10,
                      color: product['stock'] > 0 ? Colors.grey[600] : Colors.red,
                    ),
                  ),

                  // Add to Cart Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (inCart)
                        Text(
                          'In cart: $cartQuantity',
                          style: TextStyle(fontSize: 10, color: Colors.green),
                        ),
                      IconButton(
                        icon: Icon(
                          Icons.add_circle_outline,
                          color: product['stock'] > 0 ? Colors.pink : Colors.grey,
                        ),
                        onPressed: product['stock'] > 0
                            ? () => addToCart(product)
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}