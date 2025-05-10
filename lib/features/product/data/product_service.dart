import 'package:supabase_flutter/supabase_flutter.dart';
import '../../product/model/product_model.dart';

/// Service responsible for communicating with Supabase to manage products.
class ProductService {
  final SupabaseClient _client = Supabase.instance.client;
  final String _table = 'produtos'; // adjust to your actual table name

  /// Fetches all products from Supabase
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final response = await _client.from(_table).select();

      return (response as List)
          .map((map) => ProductModel.fromMap(map as Map<String, dynamic>))
          .toList();
    } catch (e, stack) {
      print('Erro ao buscar produtos: $e');
      print('Stacktrace: $stack');
      return [];
    }
  }

  /// Inserts a new product into Supabase
  Future<void> insertProduct(ProductModel product) async {
    await _client.from(_table).insert(product.toMap());
  }

  /// Updates an existing product
  Future<void> updateProduct(ProductModel product) async {
    final id = product.id;
    if (id == null) return;
    await _client.from(_table).update(product.toMap()).eq('id', id as Object);
  }

  /// Deletes a product by ID
  Future<void> deleteProduct(String id) async {
    await _client.from(_table).delete().eq('id', id);
  }
}
