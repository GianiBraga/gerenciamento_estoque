/// Data model representing a product in the inventory.
/// Used for communication between the application and Supabase.
class ProductModel {
  final String? id; // Unique identifier (UUID) from Supabase
  final String codigo; // Internal product code (e.g., SKU)
  final String nome; // Product name
  final double valor; // Product price
  final String segmento; // Product category
  final String validade; // Expiration date (format: yyyy-MM-dd)
  final int quantidade; // Current stock quantity
  final String descricao; // Description or details
  final String? imagemUrl; // URL of the product image (optional)
  final String unidade;
  final int estoqueMinimo;

  ProductModel({
    this.id,
    required this.codigo,
    required this.nome,
    required this.valor,
    required this.segmento,
    required this.validade,
    required this.quantidade,
    required this.descricao,
    this.imagemUrl,
    required this.unidade,
    required this.estoqueMinimo,
  });

  /// Creates a [ProductModel] instance from a Supabase response map.
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id']?.toString(),
      codigo: map['codigo'] ?? '',
      nome: map['nome'] ?? '',
      valor: double.tryParse(map['valor'].toString()) ?? 0.0,
      segmento: map['segmento'] ?? '',
      validade: map['validade']?.toString() ?? '',
      unidade: map['unidade'] ?? '',
      quantidade: int.tryParse(map['quantidade'].toString()) ?? 0,
      descricao: map['descricao'] ?? '',
      imagemUrl: map['imagem_url'],
      estoqueMinimo: int.tryParse(map['estoque_minimo'].toString()) ?? 0,
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
