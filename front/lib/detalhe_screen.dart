import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'api_service.dart';
import 'evento.dart';
import 'participante.dart';
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
  List<dynamic> inscricoes = [];
  List<Participante> todosParticipantes = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      futureEvento = api.getEventoById(widget.eventoId);
    });
    _carregarInscricoes();
  }

  // Busca inscrições e filtra as que são deste evento
  void _carregarInscricoes() async {
    try {
      // Carrega TUDO (Inscrições e Pessoas) para poder cruzar os dados
      final listaInscricoes = await api.getInscricoes();
      final listaPessoas = await api.getParticipantes();

      // Filtra apenas inscrições deste evento
      final inscricoesDoEvento = listaInscricoes.where((i) => i['evento'] == widget.eventoId).toList();

      // Monta uma lista bonitinha com o nome da pessoa junto
      List<dynamic> listaFinal = [];
      for (var inscricao in inscricoesDoEvento) {
        // Acha quem é o dono do ID 'participante'
        final pessoa = listaPessoas.firstWhere(
            (p) => p.id == inscricao['participante'],
            orElse: () => Participante(nome: 'Desconhecido', email: '', telefone: '')
        );
        
        listaFinal.add({
          'id_inscricao': inscricao['id'],
          'nome_pessoa': pessoa.nome,
          'email_pessoa': pessoa.email,
        });
      }

      setState(() {
        inscricoes = listaFinal;
        todosParticipantes = listaPessoas; // Guarda para usar no Dropdown depois
      });
    } catch (e) {
      print("Erro ao carregar inscrições: $e");
    }
  }

  void _abrirDialogoInscricao() {
    int? participanteSelecionado;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder( // Necessário para atualizar o Dropdown dentro do Dialog
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Adicionar Participante"),
              content: DropdownButton<int>(
                hint: const Text("Selecione a pessoa"),
                value: participanteSelecionado,
                isExpanded: true,
                items: todosParticipantes.map((Participante p) {
                  return DropdownMenuItem<int>(
                    value: p.id,
                    child: Text(p.nome),
                  );
                }).toList(),
                onChanged: (val) {
                  setStateDialog(() => participanteSelecionado = val);
                },
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
                ElevatedButton(
                  onPressed: () async {
                    if (participanteSelecionado != null) {
                      await api.createInscricao(widget.eventoId, participanteSelecionado!);
                      Navigator.pop(context);
                      _carregarInscricoes(); // Recarrega a lista
                    }
                  },
                  child: const Text("Confirmar"),
                )
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do Evento')),
      body: FutureBuilder<Evento>(
        future: futureEvento,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          
          final evento = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- CABEÇALHO DO EVENTO ---
                Text(evento.nome, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blue)),
                const SizedBox(height: 10),
                Text(evento.descricao ?? "Sem descrição", style: const TextStyle(fontSize: 16)),
                const Divider(height: 30),
                
                // --- BOTÕES DE AÇÃO DO EVENTO ---
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.edit),
                        label: const Text("Editar Dados"),
                        onPressed: () async {
                          final result = await Navigator.push(
                            context, MaterialPageRoute(builder: (context) => FormScreen(evento: evento)),
                          );
                          if (result == true) _loadData();
                        },
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                const Text("Participantes Inscritos", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),

                // --- LISTA DE INSCRITOS ---
                inscricoes.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Ninguém inscrito ainda."),
                      )
                    : ListView.builder(
                        shrinkWrap: true, // Importante para lista dentro de ScrollView
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: inscricoes.length,
                        itemBuilder: (context, index) {
                          final item = inscricoes[index];
                          return Card(
                            child: ListTile(
                              leading: const Icon(Icons.person),
                              title: Text(item['nome_pessoa']),
                              subtitle: Text(item['email_pessoa']),
                              trailing: IconButton(
                                icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                                onPressed: () async {
                                  await api.deleteInscricao(item['id_inscricao']);
                                  _carregarInscricoes();
                                },
                              ),
                            ),
                          );
                        },
                      ),

                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.person_add),
                    label: const Text("Inscrever Participante"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                    onPressed: _abrirDialogoInscricao,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}