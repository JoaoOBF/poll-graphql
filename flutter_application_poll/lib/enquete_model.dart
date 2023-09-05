class EnqueteModel {
  final String id;
  final String titulo;
  final List<String> opcoes;
  final List<int> votos;

  EnqueteModel({
    required this.id,
    required this.titulo,
    required this.opcoes,
    required this.votos,
  });

  factory EnqueteModel.fromJson(Map<String, dynamic> json) {
    return EnqueteModel(
      id: json['id'] as String,
      titulo: json['titulo'] as String,
      opcoes: (json['opcoes'] as List<dynamic>).map((dynamic item) => item as String).toList(),
      votos: (json['votos'] as List<dynamic>).map((dynamic item) => item as int).toList(),
    );
  }
}