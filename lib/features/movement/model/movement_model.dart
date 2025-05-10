class MovementModel {
  final int? id;
  final String codigoProduto;
  final int quantidade;
  final String tipo;
  final DateTime data;
  final String? usuarioId;

  MovementModel({
    this.id,
    required this.codigoProduto,
    required this.quantidade,
    required this.tipo,
    required this.data,
    this.usuarioId,
  });

  factory MovementModel.fromMap(Map<String, dynamic> map) {
    return MovementModel(
      id: map['id'],
      codigoProduto: map['codigo_produto'],
      quantidade: map['quantidade'],
      tipo: map['tipo'],
      data: DateTime.parse(map['data']),
      usuarioId: map['usuario_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'codigo_produto': codigoProduto,
      'quantidade': quantidade,
      'tipo': tipo,
      'data': data.toIso8601String(),
      'usuario_id': usuarioId,
    };
  }
}
