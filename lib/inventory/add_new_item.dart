import 'package:flutter/material.dart';

class AddNewItemPage extends StatefulWidget {
  const AddNewItemPage({super.key});

  @override
  State<AddNewItemPage> createState() => _AddNewItemPageState();
}

class _AddNewItemPageState extends State<AddNewItemPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5C6D3),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Add New Item",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Product Name"),
            const SizedBox(height: 8),
            TextField(decoration: InputDecoration(border: OutlineInputBorder())),
            const SizedBox(height: 16),
            const Text("Stock ID"),
            const SizedBox(height: 8),
            TextField(decoration: InputDecoration(border: OutlineInputBorder())),
            const SizedBox(height: 16),
            const Text("Category"),
            const SizedBox(height: 8),
            TextField(decoration: InputDecoration(border: OutlineInputBorder())),
            const SizedBox(height: 16),
            const Text("Price"),
            const SizedBox(height: 8),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            const Text("Quantity"),
            const SizedBox(height: 8),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Item added successfully!")),
                  );
                },
                child: const Text("Add Item"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
