import 'package:supabase_flutter/supabase_flutter.dart';
import '../../product/model/product_model.dart';
import '../model/movement_model.dart';

class MovementService {
  final SupabaseClient _client = Supabase.instance.client;
  final String _table = 'movimentacoes';

  /// Insere uma movimentação e atualiza o estoque do produto
  Future<void> insertMovement(MovementModel movement) async {
    try {
      // 1. Buscar o produto atual pelo ID
      final produtoResponse = await _client
          .from('produtos')
          .select()
          .eq('id', movement.produtoId)
          .single();

      final produto = ProductModel.fromMap(produtoResponse);

      // 2. Atualizar a quantidade com base no tipo da movimentação
      int novaQuantidade = produto.quantidade;
      // testa o update
      final result = await _client.from('produtos').update(
          {'quantidade': novaQuantidade}).eq('id', produto.id.toString());

      print('Resultado do update: $result');

      final tipo = movement.tipo
          .toLowerCase()
          .replaceAll('í', 'i'); // ← normaliza entrada

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

      // 3. Atualizar o produto com a nova quantidade
      await _client.from('produtos').update({'quantidade': novaQuantidade}).eq(
          'id', produto.id.toString());

      // 4. Inserir a movimentação na tabela
      await _client.from(_table).insert(movement.toMap());
      print('ID do produto: ${produto.id}');
      print('Quantidade atual: ${produto.quantidade}');
      print('Quantidade movimentada: ${movement.quantidade}');
      print('Tipo: ${movement.tipo}');
    } catch (e) {
      print('Erro ao registrar movimentação: $e');
      rethrow;
    }
  }
}
