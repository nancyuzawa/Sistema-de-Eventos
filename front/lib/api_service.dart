import 'dart:convert';
import 'package:http/http.dart' as http;
import 'evento.dart';

class ApiService {
  static const String baseUrl = "http://127.0.0.1:8000/api/eventos/";

  // GET - Listar todos eventos
  Future<List<Evento>> getEventos() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Evento.fromJson(data)).toList();
    } else {
      throw Exception('Falha ao carregar eventos');
    }
  }

  // POST - Criar novo evento
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

  // PUT - Atualizar evento
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

  // DELETE - Excluir evento
  Future<void> deleteEvento(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl$id/"));
    if (response.statusCode != 204) {
      throw Exception('Falha ao deletar evento');
    }
  }

  // GET - Buscar um evento específico pelo ID
  Future<Evento> getEventoById(int id) async {
    final response = await http.get(Uri.parse("$baseUrl$id/"));
    if (response.statusCode == 200) {
      return Evento.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao carregar detalhes do evento');
    }
  }

  // LOGIN
  Future<bool> login(String username, String password) async {
    final url = baseUrl.replaceAll("api/eventos/", "") + "api-token-auth/";
    
    final response = await http.post(
      Uri.parse(url),
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      return true; 
    } else {
      return false; 
    }
  }

  // CADASTRO - Cria um novo usuário
  Future<bool> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('${baseUrl.replaceAll("eventos/", "")}cadastro/'), 
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return true; 
    } else {
      throw Exception('Erro ao cadastrar: ${response.body}');
    }
  }
}

