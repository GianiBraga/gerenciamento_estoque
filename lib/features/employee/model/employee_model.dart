// EmployeeModel: represents a funcionário with nome e matrícula
class EmployeeModel {
  final String nome;
  final String matricula;

  EmployeeModel({
    required this.nome,
    required this.matricula,
  });

  /// Cria uma instância de EmployeeModel a partir de um Map (por ex. do Supabase)
  factory EmployeeModel.fromMap(Map<String, dynamic> map) {
    return EmployeeModel(
      nome: map['nome'] as String? ?? '',
      matricula: map['matricula'] as String? ?? '',
    );
  }

  /// Converte para Map, se necessário para envio
  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'matricula': matricula,
    };
  }
}
