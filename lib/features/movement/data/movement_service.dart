import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/movement_model.dart';

class MovementService {
  final SupabaseClient _client = Supabase.instance.client;
  final String _table = 'movimentacoes'; // Nome da tabela no Supabase

  /// Insere uma movimentação no Supabase
  Future<void> insertMovement(MovementModel movement) async {
    try {
      await _client.from(_table).insert(movement.toMap());
    } catch (e) {
      throw Exception('Erro ao salvar movimentação: $e');
    }
  }
}
