import 'dart:convert';

/// Data model representing a product in the inventory.
/// Used for communication between the application and Supabase.
class ProductModel {
  final String? id; // Unique identifier (UUID) from Supabase
  final String codigo; // Internal product code (e.g., SKU)
  final String nome; // Product name
  final double valor; // Product price
  final String segmento; // Product category
  final String? validade; // Expiration date (format: yyyy-MM-dd)
  final String unidade; // Unit of measure
  final int quantidade; // Current stock quantity
  final int estoqueMinimo; // Minimum stock threshold
  final String descricao; // Description or details
  final String? imagemUrl; // URL of the product image (optional)

  ProductModel({
    this.id,
    required this.codigo,
    required this.nome,
    required this.valor,
    required this.segmento,
    required this.validade,
    required this.unidade,
    required this.quantidade,
    required this.estoqueMinimo,
    required this.descricao,
    this.imagemUrl,
  });

  /// Creates a [ProductModel] instance from a Supabase response map.
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    // Decode 'nome' handling UTF-8 bytes or String
    final rawNome = map['nome'];
    final nome = rawNome is List<int>
        ? utf8.decode(rawNome)
        : (rawNome as String? ?? '');

    return ProductModel(
      id: map['id']?.toString(),
      codigo: map['codigo'] as String? ?? '',
      nome: nome,
      valor: double.tryParse(map['valor'].toString()) ?? 0.0,
      segmento: map['segmento'] as String? ?? '',
      validade: map['validade']?.toString(),
      unidade: map['unidade'] as String? ?? '',
      quantidade: int.tryParse(map['quantidade'].toString()) ?? 0,
      estoqueMinimo: int.tryParse(map['estoque_minimo'].toString()) ?? 0,
      descricao: map['descricao'] as String? ?? '',
      imagemUrl: map['imagem_url'] as String?,
    );
  }

  /// Converts the [ProductModel] instance into a map for insertion or update in Supabase.
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'codigo': codigo,
      'nome': nome,
      'valor': valor,
      'segmento': segmento,
      'validade': validade,
      'unidade': unidade,
      'quantidade': quantidade,
      'estoque_minimo': estoqueMinimo,
      'descricao': descricao,
      'imagem_url': imagemUrl,
    };
  }
}
