import 'dart:convert';
import 'package:http/http.dart' as http;
import 'evento.dart';

class ApiService {
  // Use 10.0.2.2 para emulador Android.
  // Se for rodar no celular físico, use o IP da sua máquina (ex: 192.168.x.x)
  static const String baseUrl = "http://127.0.0.1:8000/api/eventos/";

  // GET: Listar todos
  Future<List<Evento>> getEventos() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Evento.fromJson(data)).toList();
    } else {
      throw Exception('Falha ao carregar eventos');
    }
  }

  // POST: Criar novo
  Future<Evento> createEvento(Evento evento) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(evento.toJson()),
    );
    if (response.statusCode == 201) {
      return Evento.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao criar evento: ${response.body}');
    }
  }

  // PUT: Atualizar
  Future<Evento> updateEvento(int id, Evento evento) async {
    final response = await http.put(
      Uri.parse("$baseUrl$id/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(evento.toJson()),
    );
    if (response.statusCode == 200) {
      return Evento.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao atualizar evento');
    }
  }

  // DELETE: Excluir
  Future<void> deleteEvento(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl$id/"));
    if (response.statusCode != 204) {
      throw Exception('Falha ao deletar evento');
    }
  }
}