import 'package:supabase_flutter/supabase_flutter.dart';
import '../../product/model/product_model.dart';

/// Service responsible for communicating with Supabase to manage products.
/// Handles CRUD operations (Create, Read, Update, Delete).
class ProductService {
  final SupabaseClient _client = Supabase.instance.client;
  final String _table = 'produtos'; // Supabase table name

  /// Fetches all products from Supabase.
  /// Returns a list of [ProductModel] or an empty list on error.
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final response = await _client.from(_table).select();

      return (response as List)
          .map((map) => ProductModel.fromMap(map as Map<String, dynamic>))
          .toList();
    } catch (e, stack) {
      // Logs error and returns empty list if request fails
      print('Erro ao buscar produtos: $e');
      print('Stacktrace: $stack');
      return [];
    }
  }

  /// Inserts a new product record into Supabase.
  Future<void> insertProduct(ProductModel product) async {
    await _client.from(_table).insert(product.toMap());
  }

  /// Updates an existing product in Supabase by its ID.
  /// Does nothing if the product ID is null.
  Future<void> updateProduct(ProductModel product) async {
    final id = product.id;
    if (id == null) return;

    await _client.from(_table).update(product.toMap()).eq('id', id as Object);
  }

  /// Deletes a product from Supabase by its ID.
  Future<void> deleteProduct(String id) async {
    await _client.from(_table).delete().eq('id', id);
  }
}
