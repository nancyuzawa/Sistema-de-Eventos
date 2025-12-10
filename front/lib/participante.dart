class Participante {
  final int? id;
  final String nome;
  final String email;
  final String telefone;

  Participante({this.id, required this.nome, required this.email, required this.telefone});

  factory Participante.fromJson(Map<String, dynamic> json) {
    return Participante(
      id: json['id'],
      nome: json['nome'] ?? '',
      email: json['email'] ?? '',
      telefone: json['telefone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'email': email,
      'telefone': telefone,
    };
  }
}