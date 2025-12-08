class Evento {
  final int? id;
  final String nome;
  final String? descricao;
  final String dataInicio;
  final String dataFim;
  final int organizador;

  Evento({
    this.id,
    required this.nome,
    this.descricao,
    required this.dataInicio,
    required this.dataFim,
    required this.organizador,
  });

  // Converte JSON vindo da API para Objeto
  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
      id: json['id'],
      // O símbolo ?? significa: "Se for null, use o valor da direita"
      nome: json['nome'] ?? 'Sem Nome',
      descricao: json['descricao'],
      dataInicio: json['data_inicio'] ?? '',
      dataFim: json['data_fim'] ?? '',
      organizador: json['organizador'] ?? 0,
    );
  }

  // Converte Objeto para JSON para enviar à API
  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'descricao': descricao ?? "",
      'data_inicio': dataInicio,
      'data_fim': dataFim,
      'organizador': organizador,
    };
  }
}