import 'package:supabase_flutter/supabase_flutter.dart';
import '../../product/model/product_model.dart';
import '../model/movement_model.dart';

/// Service responsible for interacting with Supabase to perform
/// inventory movements and update product stock accordingly.
class MovementService {
  final SupabaseClient _client = Supabase.instance.client;
  final String _table = 'movimentacoes';

  /// Inserts a new inventory movement into the database and updates the product stock.
  Future<void> insertMovement(MovementModel movement) async {
    try {
      // 1. Fetch the current product by ID from Supabase
      final produtoResponse = await _client
          .from('produtos')
          .select()
          .eq('id', movement.produtoId)
          .single();

      final produto = ProductModel.fromMap(produtoResponse);
      int novaQuantidade = produto.quantidade;

      // DEBUG: Test update with same value just to verify update behavior
      // final result = await _client.from('produtos').update(
      //     {'quantidade': novaQuantidade}).eq('id', produto.id.toString());
      // print('Resultado do update: $result');

      // 2. Normalize movement type and apply quantity logic
      final tipo = movement.tipo.toLowerCase().replaceAll('í', 'i');

      if (tipo == 'entrada') {
        novaQuantidade += movement.quantidade;
      } else if (tipo == 'saida') {
        novaQuantidade -= movement.quantidade;
        if (novaQuantidade < 0) {
          throw Exception('Quantidade insuficiente em estoque.');
        }
      } else {
        throw Exception('Tipo de movimentação inválido: ${movement.tipo}');
      }

      // 3. Update the product stock with the new quantity
      await _client.from('produtos').update({'quantidade': novaQuantidade}).eq(
          'id', produto.id.toString());

      // 4. Insert the movement into the 'movimentacoes' table
      await _client.from(_table).insert(movement.toMap());

      // Debug prints to verify data flow and logic
      // print('ID do produto: ${produto.id}');
      // print('Quantidade atual: ${produto.quantidade}');
      // print('Quantidade movimentada: ${movement.quantidade}');
      // print('Tipo: ${movement.tipo}');
    } catch (e) {
      // Rethrow after logging to preserve stack trace
      // print('Erro ao registrar movimentação: $e');
      rethrow;
    }
  }
}
