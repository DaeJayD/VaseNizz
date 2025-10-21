import 'package:flutter/material.dart';
import 'checkout_page.dart';

class BrandProductsPage extends StatefulWidget {
  final String brandName;

  const BrandProductsPage({Key? key, required this.brandName}) : super(key: key);

  @override
  _BrandProductsPageState createState() => _BrandProductsPageState();
}

class _BrandProductsPageState extends State<BrandProductsPage> {
  final List<Map<String, dynamic>> products = [
    {'name': 'Ex. Product 1', 'price': 5.99, 'id': 'P001', 'image': 'assets/img1.png'},
    {'name': 'Ex. Product 2', 'price': 5.99, 'id': 'P002', 'image': 'assets/img2.png'},
    {'name': 'Ex. Product 3', 'price': 5.99, 'id': 'P003', 'image': 'assets/img3.png'},
    {'name': 'Ex. Product 4', 'price': 5.99, 'id': 'P004', 'image': 'assets/img4.png'},
  ];

  final List<Map<String, dynamic>> cart = [];

  void addToCart(Map<String, dynamic> product) {
    setState(() {
      cart.add(product);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product['name']} added to cart')),
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
              backgroundImage: const AssetImage('assets/beautywise.png'),
              radius: 20,
            ),
            const SizedBox(width: 10),
            Text(
              widget.brandName,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutPage(),
                    ),
                  );
                },

              ),
              if (cart.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: Text(
                      cart.length.toString(),
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.9,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
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
                    Expanded(
                      child: Image.asset(
                        product['image'],
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(product['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('Ex. Prod Id ${product['id']}'),
                    Text('₱${product['price']}'),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, color: Colors.pink),
                      onPressed: () => addToCart(product),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
