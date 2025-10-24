import 'package:flutter/material.dart';
import 'package:vasenizzpos/products/brand_inventory.dart';

class ViewInventory extends StatefulWidget {
  const ViewInventory({super.key});

  @override
  State<ViewInventory> createState() => _ViewInventoryState();
}

class _ViewInventoryState extends State<ViewInventory> {
  int _currentPage = 1;
  final int _totalPages = 3;

  @override
  Widget build(BuildContext context) {
    final brands = [
      {'name': 'Beauty Wise', 'logo': 'assets/beautywise.png'},
      {'name': 'Beauty Vault', 'logo': 'assets/beautyvault.png'},
      {'name': 'Lumi', 'logo': 'assets/lumi.png'},
      {'name': 'Brilliant', 'logo': 'assets/brilliant.png'},
      {'name': 'VaseNizz', 'logo': 'assets/vasenizz.png'},
      {'name': 'NoBrand', 'logo': 'assets/nobrand.png'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F3F4),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: const BoxDecoration(
                color: Color(0xFFFFD9E1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
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
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Carmen Branch",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          "Thofia Concepcion (03085)",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none, size: 28),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // SEARCH BAR
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search Inventory',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 4),
              child: Text(
                "All Brands",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // BRAND LIST
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 20),
                itemCount: brands.length,
                itemBuilder: (context, index) {
                  final brand = brands[index];
                  final name = brand['name'] ?? 'Unknown';
                  final logo = brand['logo'] ?? '';

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        title: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        trailing: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8C8D9),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: const Icon(Icons.business, color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BrandInventoryPage(
                                brandName: "Beauty Vault",
                                branchManager: "Thofia Concepcion",
                                branchCode: "03085",
                                brandLogoPath: "assets/beautyvault_logo.png",
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),

            // PAGE NUMBERING
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 18),
                    onPressed: _currentPage > 1
                        ? () {
                      setState(() {
                        _currentPage--;
                      });
                    }
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Page $_currentPage of $_totalPages',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, size: 18),
                    onPressed: _currentPage < _totalPages
                        ? () {
                      setState(() {
                        _currentPage++;
                      });
                    }
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}