import 'package:flutter/material.dart';
import 'api_service.dart';
import 'participante.dart';

class ListaParticipantesScreen extends StatefulWidget {
  const ListaParticipantesScreen({super.key});

  @override
  _ListaParticipantesScreenState createState() =>
      _ListaParticipantesScreenState();
}

class _ListaParticipantesScreenState extends State<ListaParticipantesScreen> {
  final ApiService api = ApiService();
  late Future<List<Participante>> futureParticipantes;

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  void _refreshList() {
    setState(() {
      futureParticipantes = api.getParticipantes();
    });
  }

  void _showForm({Participante? participante}) {
    final nomeController = TextEditingController(
      text: participante?.nome ?? '',
    );
    final emailController = TextEditingController(
      text: participante?.email ?? '',
    );
    final telController = TextEditingController(
      text: participante?.telefone ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(participante == null ? 'Novo Participante' : 'Editar'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: telController,
              decoration: const InputDecoration(labelText: 'Telefone'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final p = Participante(
                id: participante?.id,
                nome: nomeController.text,
                email: emailController.text,
                telefone: telController.text,
              );

              try {
                if (participante == null) {
                  await api.createParticipante(p);
                } else {
                  await api.updateParticipante(participante.id!, p);
                }

                if (mounted) {
                  Navigator.pop(context); 
                  _refreshList();
                }
              } catch (e) {
                print("Erro: $e");
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Participantes')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.person_add),
        onPressed: () => _showForm(),
      ),
      body: FutureBuilder<List<Participante>>(
        future: futureParticipantes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final p = snapshot.data![index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(p.nome.isNotEmpty ? p.nome[0] : '?'),
                  ),
                  title: Text(p.nome),
                  subtitle: Text(p.email),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Botão Editar
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showForm(participante: p),
                      ),
                      // Botão Excluir
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await api.deleteParticipante(p.id!);
                          _refreshList();
                        },
                      ),
                    ],
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
