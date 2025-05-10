class ProductModel {
  final String? id; // Corrigido: Supabase usa UUID
  final String codigo;
  final String nome;
  final double valor;
  final String categoria;
  final String validade; // Data em formato 'yyyy-MM-dd'
  final int quantidade;
  final String descricao;
  final String? imagemUrl;

  ProductModel({
    this.id,
    required this.codigo,
    required this.nome,
    required this.valor,
    required this.categoria,
    required this.validade,
    required this.quantidade,
    required this.descricao,
    this.imagemUrl,
  });

  /// Creates a ProductModel instance from a Map (e.g., from Supabase)
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id']?.toString(),
      codigo: map['codigo'] ?? '',
      nome: map['nome'] ?? '',
      valor: double.tryParse(map['valor'].toString()) ?? 0.0,
      categoria: map['categoria'] ?? '',
      validade: map['validade']?.toString() ?? '',
      quantidade: int.tryParse(map['quantidade'].toString()) ?? 0,
      descricao: map['descricao'] ?? '',
      imagemUrl: map['imagem_url'],
    );
  }

  /// Converts this ProductModel instance into a Map for database insertion/update
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'codigo': codigo,
      'nome': nome,
      'valor': valor,
      'categoria': categoria,
      'validade': validade,
      'quantidade': quantidade,
      'descricao': descricao,
      'imagem_url': imagemUrl,
    };
  }
}
