import 'dart:convert';

/// Data model representing um produto, compatível com Supabase e SQLite.
/// - Campos nulos no PostgreSQL viram String?, DateTime? ou double? em Dart.
/// - Datas são serializadas/deserializadas em ISO 8601.
class ProductModel {
  final String? id; // UUID gerado pelo Supabase
  final String nome; // NOT NULL
  final String? descricao; // NULLABLE
  final String? codigo; // NULLABLE, UNIQUE
  final int quantidade; // DEFAULT 0
  final String? imagemUrl; // NULLABLE
  final String? usuarioId; // UUID do usuário (nullable FK)
  final DateTime? createdAt; // timestamp with time zone, default now()
  final double? valor; // numeric(10,2)
  final String? segmento; // text nullable
  final DateTime? validade; // date nullable
  final String? unidade; // text nullable
  final int estoqueMinimo; // DEFAULT 0

  ProductModel({
    this.id,
    required this.nome,
    this.descricao,
    this.codigo,
    this.quantidade = 0,
    this.imagemUrl,
    this.usuarioId,
    this.createdAt,
    this.valor,
    this.segmento,
    this.validade,
    this.unidade,
    this.estoqueMinimo = 0,
  });

  /// Constrói a partir de um Map (Supabase ou SQLite), decodificando datas.
  factory ProductModel.fromMap(Map<String, dynamic> m) {
    // trata possíveis bytes UTF-8 em 'nome'
    final rawNome = m['nome'];
    final nome = rawNome is List<int>
        ? utf8.decode(rawNome)
        : (rawNome as String? ?? '');

    return ProductModel(
      id: m['id']?.toString(),
      nome: nome,
      descricao: m['descricao'] as String?,
      codigo: m['codigo'] as String?,
      quantidade: (m['quantidade'] is int)
          ? m['quantidade'] as int
          : int.tryParse(m['quantidade']?.toString() ?? '') ?? 0,
      imagemUrl: m['imagem_url'] as String?,
      usuarioId: m['usuario_id']?.toString(),
      createdAt: m['created_at'] != null
          ? DateTime.parse(m['created_at'] as String)
          : null,
      valor: m['valor'] != null ? double.tryParse(m['valor'].toString()) : null,
      segmento: m['segmento'] as String?,
      validade: m['validade'] != null
          ? DateTime.parse(m['validade'] as String)
          : null,
      unidade: m['unidade'] as String?,
      estoqueMinimo: (m['estoque_minimo'] is int)
          ? m['estoque_minimo'] as int
          : int.tryParse(m['estoque_minimo']?.toString() ?? '') ?? 0,
    );
  }

  /// Gera o Map para upsert no Supabase.
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'nome': nome,
      'descricao': descricao,
      'codigo': codigo,
      'quantidade': quantidade,
      'imagem_url': imagemUrl,
      'usuario_id': usuarioId,
      'created_at': createdAt?.toIso8601String(),
      'valor': valor,
      'segmento': segmento,
      'validade': validade?.toIso8601String(),
      'unidade': unidade,
      'estoque_minimo': estoqueMinimo,
    };
  }

  /// (Opcional) Se for usar localmente com sqflite, adicione isSynced:
  Map<String, dynamic> toLocalMap({bool isSynced = false}) {
    final m = toMap();
    // SQLite não aceita null em campos não criados; converte double? para REAL, DateTime? para TEXT
    m['isSynced'] = isSynced ? 1 : 0;
    return m;
  }
}
