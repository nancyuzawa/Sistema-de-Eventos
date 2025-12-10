class Atividade {
  final int? id;
  final int eventoId;
  final String titulo;
  final String descricao;
  final bool finalizada;

  Atividade({
    this.id,
    required this.eventoId,
    required this.titulo,
    required this.descricao,
    required this.finalizada,
  });

  factory Atividade.fromJson(Map<String, dynamic> json) {
    return Atividade(
      id: json['id'],
      eventoId: json['evento'],
      titulo: json['titulo'] ?? '',
      descricao: json['descricao'] ?? '',
      finalizada: json['finalizada'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'evento': eventoId,
      'titulo': titulo,
      'descricao': descricao,
      'finalizada': finalizada,
    };
  }
}