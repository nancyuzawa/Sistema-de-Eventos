import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'api_service.dart';
import 'evento.dart';

class FormScreen extends StatefulWidget {
  final Evento? evento; // Se for null, é cadastro. Se tiver dados, é edição.

  const FormScreen({super.key, this.evento});

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _descController = TextEditingController();
  final _apiService = ApiService();

  DateTime _dataInicio = DateTime.now();
  DateTime _dataFim = DateTime.now().add(const Duration(hours: 2));

  @override
  void initState() {
    super.initState();
    if (widget.evento != null) {
      _nomeController.text = widget.evento!.nome;
      _descController.text = widget.evento!.descricao ?? '';
      _dataInicio = DateTime.parse(widget.evento!.dataInicio);
      _dataFim = DateTime.parse(widget.evento!.dataFim);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.evento == null ? 'Novo Evento' : 'Editar Evento')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome do Evento'),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
              const SizedBox(height: 20),
              ListTile(
                title: Text("Início: ${DateFormat('dd/MM/yyyy HH:mm').format(_dataInicio)}"),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _pickDateTime(true),
              ),
              ListTile(
                title: Text("Fim: ${DateFormat('dd/MM/yyyy HH:mm').format(_dataFim)}"),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _pickDateTime(false),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveEvento,
                child: Text(widget.evento == null ? 'CRIAR' : 'SALVAR ALTERAÇÕES'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDateTime(bool isInicio) async {
    final date = await showDatePicker(
      context: context,
      initialDate: isInicio ? _dataInicio : _dataFim,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(isInicio ? _dataInicio : _dataFim),
    );
    if (time == null) return;

    setState(() {
      final newDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
      if (isInicio) {
        _dataInicio = newDateTime;
      } else {
        _dataFim = newDateTime;
      }
    });
  }

  void _saveEvento() async {
    if (_formKey.currentState!.validate()) {
      // Formata para o padrão ISO que o Django aceita (ex: 2025-12-10T10:00:00)
      final evento = Evento(
        id: widget.evento?.id,
        nome: _nomeController.text,
        descricao: _descController.text,
        dataInicio: _dataInicio.toIso8601String(),
        dataFim: _dataFim.toIso8601String(),
        organizador: 1, // HARDCODED: Enviando ID 1 pois não temos login no app ainda
      );

      try {
        if (widget.evento == null) {
          await _apiService.createEvento(evento);
        } else {
          await _apiService.updateEvento(widget.evento!.id!, evento);
        }
        if (mounted) Navigator.pop(context, true); // Retorna true para atualizar a lista
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e')));
      }
    }
  }
}