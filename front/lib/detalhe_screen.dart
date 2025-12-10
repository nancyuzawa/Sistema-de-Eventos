import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'api_service.dart';
import 'evento.dart';
import 'form_screen.dart';

class DetalheScreen extends StatefulWidget {
  final int eventoId; 

  const DetalheScreen({super.key, required this.eventoId});

  @override
  _DetalheScreenState createState() => _DetalheScreenState();
}

class _DetalheScreenState extends State<DetalheScreen> {
  final ApiService api = ApiService();
  late Future<Evento> futureEvento;

  @override
  void initState() {
    super.initState();
    futureEvento = api.getEventoById(widget.eventoId);
  }

  void _refresh() {
    setState(() {
      futureEvento = api.getEventoById(widget.eventoId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do Evento')),
      body: FutureBuilder<Evento>(
        future: futureEvento,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erro: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final evento = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    evento.nome,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    evento.descricao ?? "Sem descrição",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  _buildDateInfo("Início", evento.dataInicio),
                  _buildDateInfo("Fim", evento.dataFim),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.edit),
                      label: const Text("Editar Evento"),
                      onPressed: () async {
                        // Navega para edição
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FormScreen(evento: evento)),
                        );
                        // Se editou, atualiza os detalhes na tela
                        if (result == true) _refresh();
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text("Evento não encontrado"));
        },
      ),
    );
  }

  Widget _buildDateInfo(String label, String dateStr) {
    final date = DateTime.parse(dateStr);
    final formatted = DateFormat('dd/MM/yyyy - HH:mm').format(date);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, size: 20, color: Colors.blue),
          const SizedBox(width: 8),
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(formatted),
        ],
      ),
    );
  }
}