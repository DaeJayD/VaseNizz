import 'package:flutter/material.dart';
import 'package:vasenizzpos/products/brand_inventory.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

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
      backgroundColor: const Color(0xFFF5E9ED),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: const BoxDecoration(
          color: Color(0xFFFCE7EC),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            _BottomNavItem(icon: Icons.dashboard, label: 'Dashboard'),
            _BottomNavItem(icon: Icons.shopping_cart, label: 'Sales'),
            _BottomNavItem(icon: Icons.inventory, label: 'Inventory', active: true),
            _BottomNavItem(icon: Icons.bar_chart, label: 'Report'),
            _BottomNavItem(icon: Icons.person, label: 'Profile'),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: const Color(0xFFFABFD2),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/logo.png', height: 50),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Carmen Branch",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Thofia Concepcion (03085)",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.notifications_none, size: 28),
                ],
              ),
            ),
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
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "All Brands",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: brands.length,
                itemBuilder: (context, index) {
                  final brand = brands[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 4,
                            offset: const Offset(2, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(
                          brand['name']!,
                          style: const TextStyle(fontSize: 16),
                        ),
                        trailing: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset(
                            brand['logo']!,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
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
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// Bottom Navigation Item Widget
// ------------------------------------------------------------
class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  const _BottomNavItem({required this.icon, required this.label, this.active = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: active ? Colors.redAccent : Colors.black54),
        Text(label, style: TextStyle(color: active ? Colors.redAccent : Colors.black54)),
      ],
    );
  }
}


class _PaginationBar extends StatelessWidget {
  const _PaginationBar();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          children: List.generate(8, (i) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: i == 0 ? const Color(0xFFFABFD2) : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                alignment: Alignment.center,
                child: Text("${i + 1}"),
              ),
            );
          }),
        ),
        const SizedBox(height: 5),
        const Text("1 of 8 pages (84 items)", style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
