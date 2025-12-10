import 'package:flutter/material.dart';
import 'api_service.dart';
import 'atividade.dart';
import 'evento.dart';

class ListaAtividadesScreen extends StatefulWidget {
  const ListaAtividadesScreen({super.key});

  @override
  _ListaAtividadesScreenState createState() => _ListaAtividadesScreenState();
}

class _ListaAtividadesScreenState extends State<ListaAtividadesScreen> {
  final ApiService api = ApiService();
  late Future<List<Atividade>> futureAtividades;
  List<Evento> eventosDisponiveis = [];

  @override
  void initState() {
    super.initState();
    _refreshList();
    _carregarEventos();
  }

  void _refreshList() {
    setState(() {
      futureAtividades = api.getAtividades();
    });
  }

  void _carregarEventos() async {
    try {
      final lista = await api.getEventos();
      setState(() => eventosDisponiveis = lista);
    } catch (e) {
      print("Erro ao carregar eventos: $e");
    }
  }

  void _showForm({Atividade? atividade}) {
    final tituloController = TextEditingController(text: atividade?.titulo ?? '');
    final descController = TextEditingController(text: atividade?.descricao ?? '');
    
    int? eventoSelecionado = atividade?.eventoId;

    if (eventoSelecionado != null && !eventosDisponiveis.any((e) => e.id == eventoSelecionado)) {
      eventoSelecionado = null;
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(atividade == null ? 'Nova Atividade' : 'Editar Atividade'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<int>(
                    hint: const Text("Selecione o Evento"),
                    value: eventoSelecionado,
                    isExpanded: true,
                    items: eventosDisponiveis.map((e) {
                      return DropdownMenuItem(
                        value: e.id,
                        child: Text(e.nome),
                      );
                    }).toList(),
                    onChanged: (val) => setStateDialog(() => eventoSelecionado = val),
                  ),
                  TextField(controller: tituloController, decoration: const InputDecoration(labelText: 'Título')),
                  TextField(controller: descController, decoration: const InputDecoration(labelText: 'Descrição')),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
                ElevatedButton(
                  onPressed: () async {
                    if (eventoSelecionado != null && tituloController.text.isNotEmpty) {
                      final novaAtv = Atividade(
                        id: atividade?.id, 
                        eventoId: eventoSelecionado!,
                        titulo: tituloController.text,
                        descricao: descController.text,
                        finalizada: atividade?.finalizada ?? false,
                      );

                      if (atividade == null) {
                        // Criar
                        await api.createAtividade(novaAtv);
                      } else {
                        // Editar
                        await api.updateAtividade(atividade.id!, novaAtv);
                      }

                      Navigator.pop(context);
                      _refreshList();
                    }
                  },
                  child: const Text('Salvar'),
                ),
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
      appBar: AppBar(title: const Text('Atividades (Programação)')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
        child: const Icon(Icons.add_task),
      ),
      body: FutureBuilder<List<Atividade>>(
        future: futureAtividades,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) return const Center(child: Text("Nenhuma atividade cadastrada."));
            
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final atv = snapshot.data![index];
                
                final nomeEvento = eventosDisponiveis
                    .firstWhere((e) => e.id == atv.eventoId, orElse: () => Evento(nome: 'Evento ${atv.eventoId}', descricao: '', dataInicio: '', dataFim: '', organizador: 0))
                    .nome;

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: const Icon(Icons.schedule, color: Colors.deepPurple),
                    title: Text(atv.titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("$nomeEvento\n${atv.descricao}"),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Botão Editar
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showForm(atividade: atv), 
                        ),
                        // Botão Excluir
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await api.deleteAtividade(atv.id!);
                            _refreshList();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}