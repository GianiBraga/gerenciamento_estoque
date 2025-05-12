class MovementModel {
  final String? id;
  final String produtoId;
  final int quantidade;
  final String tipo;
  final String? usuarioId;
  final DateTime? data;

  MovementModel({
    this.id,
    required this.produtoId,
    required this.quantidade,
    required this.tipo,
    this.usuarioId,
    this.data,
  });

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
