import 'package:supabase_flutter/supabase_flutter.dart';

class InventoryService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get inventory history with pagination
  Future<Map<String, dynamic>> getInventoryHistory({
    int page = 1,
    int pageSize = 20,
    String? branchId,
  }) async {
    try {
      final from = (page - 1) * pageSize;
      final to = from + pageSize - 1;

      if (branchId != null) {
        final response = await _supabase
            .from('inventory_movements')
            .select()
            .eq('branch_id', branchId)
            .order('created_at', ascending: false)
            .range(from, to);

        return {
          'data': response,
          'error': null,
          'totalCount': response.length,
        };
      } else {
        final response = await _supabase
            .from('inventory_movements')
            .select()
            .order('created_at', ascending: false)
            .range(from, to);

        return {
          'data': response,
          'error': null,
          'totalCount': response.length,
        };
      }
    } catch (e) {
      return {
        'data': null,
        'error': e.toString(),
        'totalCount': 0,
      };
    }
  }

  // Get sales data as inventory movements
  Future<Map<String, dynamic>> getSalesAsInventoryMovements({int limit = 100}) async {
    try {
      final response = await _supabase
          .from('sale_items')
          .select('''
            *,
            sales(
              cashier_name,
              payment_method,
              created_at,
              total_amount
            ),
            products(
              name,
              sku,
              brands(name)
            )
          ''')
          .order('created_at', ascending: false)
          .limit(limit);

      // Transform the data into inventory movement format
      final movements = [];
      for (final item in response) {
        final sale = item['sales'] ?? {};
        final product = item['products'] ?? {};
        final brand = product['brands'] ?? {};

        movements.add({
          'id': item['id'],
          'created_at': sale['created_at'] ?? item['created_at'],
          'movement_type': 'sold',
          'quantity': item['quantity'],
          'reason': '${sale['payment_method'] ?? 'N/A'} • \$${sale['total_amount']?.toStringAsFixed(2) ?? '0.00'}',
          'product_name': product['name'] ?? 'Unknown Product',
          'product_sku': product['sku'] ?? 'N/A',
          'brand_name': brand['name'] ?? 'N/A',
          'employee_name': sale['cashier_name'] ?? 'Unknown Cashier',
          'unit_price': item['unit_price']?.toStringAsFixed(2) ?? '0.00',
          'total_price': item['total_price']?.toStringAsFixed(2) ?? '0.00',
          'is_sale': true,
        });
      }

      return {
        'data': movements,
        'error': null,
      };
    } catch (e) {
      return {
        'data': null,
        'error': e.toString(),
      };
    }
  }

  // Get combined inventory movements and sales data
  Future<Map<String, dynamic>> getCombinedInventoryHistory({int limit = 100}) async {
    try {
      // First try to get inventory movements
      final movements = await _supabase
          .from('inventory_movements')
          .select('''
            *,
            products(name, sku, brands(name)),
            employees(name),
            branches(name)
          ''')
          .order('created_at', ascending: false)
          .limit(limit);

      if (movements.isNotEmpty) {
        return {
          'data': movements,
          'error': null,
        };
      }

      // Fallback to sales data
      return await getSalesAsInventoryMovements(limit: limit);
    } catch (e) {
      return {
        'data': null,
        'error': e.toString(),
      };
    }
  }

  // Get low stock alerts across all branches
  Future<Map<String, dynamic>> getStockSummary() async {
    try {
      // Get all branch stock
      final allStock = await _supabase
          .from('branch_stock')
          .select()
          .order('current_stock', ascending: true);

      // Filter for low stock manually
      final lowStock = allStock.where((item) {
        final currentStock = item['current_stock'] ?? 0;
        final threshold = item['low_stock_threshold'] ?? 10;
        return currentStock <= threshold;
      }).toList();

      return {
        'data': lowStock,
        'error': null,
      };
    } catch (e) {
      return {
        'data': null,
        'error': e.toString(),
      };
    }
  }

  // Get branch inventory data by branch name
  Future<Map<String, dynamic>> getBranchInventory(String branchName) async {
    try {
      // First get branch ID from name
      final branchResponse = await _supabase
          .from('branches')
          .select()
          .eq('name', '$branchName BRANCH')
          .single();

      final branchId = branchResponse['id'];

      // Then get inventory for that branch
      final inventoryResponse = await _supabase
          .from('branch_stock')
          .select()
          .eq('branch_id', branchId)
          .order('current_stock', ascending: true);

      return {
        'data': inventoryResponse,
        'error': null,
      };
    } catch (e) {
      return {
        'data': null,
        'error': e.toString(),
      };
    }
  }

  // Get all inventory for a specific branch by ID
  Future<Map<String, dynamic>> getBranchInventoryById(String branchId) async {
    try {
      final inventoryResponse = await _supabase
          .from('branch_stock')
          .select()
          .eq('branch_id', branchId)
          .order('current_stock', ascending: true);

      return {
        'data': inventoryResponse,
        'error': null,
      };
    } catch (e) {
      return {
        'data': null,
        'error': e.toString(),
      };
    }
  }

  // Get all branches
  Future<Map<String, dynamic>> getBranches() async {
    try {
      final response = await _supabase
          .from('branches')
          .select()
          .order('name');

      return {
        'data': response,
        'error': null,
      };
    } catch (e) {
      return {
        'data': null,
        'error': e.toString(),
      };
    }
  }

  // Update stock with movement tracking
  Future<Map<String, dynamic>> updateStock({
    required String productId,
    required String branchId,
    required String movementType,
    required int quantity,
    required String userId,
    String reason = '',
    String? referenceId,
  }) async {
    try {
      // Get current stock
      final currentStockResponse = await _supabase
          .from('branch_stock')
          .select()
          .eq('product_id', productId)
          .eq('branch_id', branchId)
          .single();

      final previousStock = currentStockResponse['current_stock'] ?? 0;
      int newStock = previousStock;

      switch (movementType) {
        case 'in':
          newStock = previousStock + quantity;
          break;
        case 'out':
        case 'sold':
          newStock = previousStock - quantity;
          break;
        case 'adjustment':
          newStock = quantity;
          break;
      }

      // Update branch stock
      await _supabase.from('branch_stock').upsert({
        'product_id': productId,
        'branch_id': branchId,
        'current_stock': newStock,
        'last_updated': DateTime.now().toIso8601String(),
      });

      // Record movement
      await _supabase.from('inventory_movements').insert({
        'product_id': productId,
        'branch_id': branchId,
        'movement_type': movementType,
        'quantity': quantity,
        'previous_stock': previousStock,
        'new_stock': newStock,
        'user_id': userId,
        'reason': reason,
        'reference_id': referenceId,
      });

      return {'error': null};
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // Manually create inventory movements for existing sales
  Future<Map<String, dynamic>> createInventoryMovementsForExistingSales() async {
    try {
      // Call a stored procedure to process existing sales
      final response = await _supabase.rpc('process_existing_sales_movements');

      return {
        'data': response,
        'error': null,
      };
    } catch (e) {
      // If RPC doesn't exist, manually process sales
      return await _manuallyProcessSalesMovements();
    }
  }

  // Manual processing of sales movements
  Future<Map<String, dynamic>> _manuallyProcessSalesMovements() async {
    try {
      // Get all sale items
      final saleItems = await _supabase
          .from('sale_items')
          .select('''
            *,
            sales(payment_method, cashier_name),
            products(name, sku)
          ''')
          .order('created_at', ascending: false);

      int processedCount = 0;

      for (final item in saleItems) {
        final sale = item['sales'] ?? {};
        final product = item['products'] ?? {};

        // Check if movement already exists
        final existingMovement = await _supabase
            .from('inventory_movements')
            .select()
            .eq('reference_id', item['sale_id'])
            .eq('product_id', item['product_id'])
            .maybeSingle();

        if (existingMovement == null) {
          // Create inventory movement
          await _supabase.from('inventory_movements').insert({
            'product_id': item['product_id'],
            'branch_id': await _getDefaultBranchId(),
            'movement_type': 'sold',
            'quantity': item['quantity'],
            'previous_stock': 100, // Default starting stock
            'new_stock': 100 - item['quantity'],
            'user_id': 'system',
            'reason': 'Sale - ${sale['payment_method']}',
            'reference_id': item['sale_id'],
            'created_at': item['created_at'],
          });
          processedCount++;
        }
      }

      return {
        'data': {'processed_count': processedCount},
        'error': null,
      };
    } catch (e) {
      return {
        'data': null,
        'error': e.toString(),
      };
    }
  }

  // Get default branch ID
  Future<String> _getDefaultBranchId() async {
    try {
      final branch = await _supabase
          .from('branches')
          .select('id')
          .limit(1)
          .single();
      return branch['id'];
    } catch (e) {
      // Return a default UUID if no branches exist
      return '00000000-0000-0000-0000-000000000000';
    }
  }

  // Search products across all branches
  Future<Map<String, dynamic>> searchProducts(String query) async {
    try {
      // For simple search, we'll get all and filter manually
      final allProducts = await _supabase
          .from('products')
          .select();

      final filtered = allProducts.where((item) {
        final productName = item['name']?.toString().toLowerCase() ?? '';
        final sku = item['sku']?.toString().toLowerCase() ?? '';
        final brand = item['brand_id']?.toString().toLowerCase() ?? '';
        final searchLower = query.toLowerCase();
        return productName.contains(searchLower) ||
            sku.contains(searchLower) ||
            brand.contains(searchLower);
      }).toList();

      return {
        'data': filtered,
        'error': null,
      };
    } catch (e) {
      return {
        'data': null,
        'error': e.toString(),
      };
    }
  }

  // Get product details by ID
  Future<Map<String, dynamic>> getProductById(String productId) async {
    try {
      final response = await _supabase
          .from('products')
          .select()
          .eq('id', productId)
          .single();

      return {
        'data': response,
        'error': null,
      };
    } catch (e) {
      return {
        'data': null,
        'error': e.toString(),
      };
    }
  }

  // Get stock movements for a specific product
  Future<Map<String, dynamic>> getProductMovements(String productId, {int limit = 50}) async {
    try {
      final response = await _supabase
          .from('inventory_movements')
          .select()
          .eq('product_id', productId)
          .order('created_at', ascending: false)
          .limit(limit);

      return {
        'data': response,
        'error': null,
      };
    } catch (e) {
      return {
        'data': null,
        'error': e.toString(),
      };
    }
  }
  Future<Map<String, dynamic>> getSalesWithProductDetails({int limit = 100}) async {
    try {
      final response = await _supabase
          .from('sale_items')
          .select('''
          *,
          sales(
            cashier_name,
            payment_method,
            created_at,
            total_amount
          ),
          products(
            name,
            sku,
            brands(name)
          )
        ''')
          .order('created_at', ascending: false)
          .limit(limit);

      return {
        'data': response,
        'error': null,
      };
    } catch (e) {
      return {
        'data': null,
        'error': e.toString(),
      };
    }
  }
  // Get total items sold (for summary)
  Future<int> getTotalItemsSold() async {
    try {
      final response = await _supabase
          .from('sale_items')
          .select('quantity');

      final total = response.fold<int>(0, (sum, item) => sum + (item['quantity'] as int));
      return total;
    } catch (e) {
      return 0;
    }

  }
}