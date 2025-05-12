/// Model class that represents a stock movement (entry or exit).
/// Used to transfer data between the application and the Supabase database.
class MovementModel {
  final String? id; // Unique ID (nullable, used for updates)
  final String produtoId; // Related product's ID (foreign key)
  final int quantidade; // Quantity moved (positive integer)
  final String tipo; // Type of movement: 'entrada' or 'saida'
  final String? usuarioId; // ID of the user who performed the movement
  final DateTime? data; // Timestamp of the movement

  MovementModel({
    this.id,
    required this.produtoId,
    required this.quantidade,
    required this.tipo,
    this.usuarioId,
    this.data,
  });

  /// Creates a MovementModel instance from a Supabase record (Map).
  factory MovementModel.fromMap(Map<String, dynamic> map) {
    return MovementModel(
      id: map['id']?.toString(),
      produtoId: map['produto_id'] ?? '',
      quantidade: int.tryParse(map['quantidade'].toString()) ?? 0,
      tipo: map['tipo'] ?? '',
      usuarioId: map['usuario_id'],
      data: map['data'] != null ? DateTime.parse(map['data']) : null,
    );
  }

  /// Converts the MovementModel instance into a Map for Supabase insertion.
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'produto_id': produtoId,
      'quantidade': quantidade,
      'tipo': tipo,
      'usuario_id': usuarioId,
      if (data != null) 'data': data!.toIso8601String(),
    };
  }
}
