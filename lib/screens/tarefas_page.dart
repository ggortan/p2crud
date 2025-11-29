import 'package:flutter/material.dart';
import '../data/tarefa_dao.dart';
import '../models/tarefa.dart';

class TarefasPage extends StatefulWidget {
  const TarefasPage({super.key});

  @override
  State<TarefasPage> createState() => _TarefasPageState();
}

class _TarefasPageState extends State<TarefasPage> {
  final TarefaDao _dao = TarefaDao();
  List<Tarefa> _tarefas = [];

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future _carregar() async {
    final lista = await _dao.listar();
    setState(() {
      _tarefas = lista;
    });
  }

  Future _mostrarFormulario([Tarefa? tarefa]) async {
    final tituloCtrl = TextEditingController(text: tarefa?.titulo ?? '');
    final descricaoCtrl = TextEditingController(text: tarefa?.descricao ?? '');
    final prioridadeCtrl = TextEditingController(
      text: tarefa?.prioridade?.toString() ?? '',
    );
    final projetoCtrl = TextEditingController(
      text: tarefa?.projetoRelacionado ?? '',
    );

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(tarefa == null ? 'Nova tarefa' : 'Editar tarefa'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: tituloCtrl,
                  decoration: const InputDecoration(labelText: 'Título'),
                ),
                TextField(
                  controller: descricaoCtrl,
                  decoration: const InputDecoration(labelText: 'Descrição'),
                ),
                TextField(
                  controller: prioridadeCtrl,
                  decoration: const InputDecoration(labelText: 'Prioridade'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: projetoCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Projeto relacionado',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                final p = int.tryParse(prioridadeCtrl.text);
                if (tarefa == null) {
                  final nova = Tarefa(
                    titulo: tituloCtrl.text,
                    descricao: descricaoCtrl.text,
                    prioridade: p,
                    projetoRelacionado: projetoCtrl.text,
                  );
                  await _dao.inserir(nova);
                } else {
                  final atualizada = Tarefa(
                    id: tarefa.id,
                    titulo: tituloCtrl.text,
                    descricao: descricaoCtrl.text,
                    prioridade: p,
                    criadoEm: tarefa.criadoEm,
                    projetoRelacionado: projetoCtrl.text,
                  );
                  await _dao.atualizar(atualizada);
                }
                Navigator.of(context).pop();
                await _carregar();
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Future _excluir(int id) async {
    await _dao.excluir(id);
    await _carregar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Tarefas')),
      body: ListView.builder(
        itemCount: _tarefas.length,
        itemBuilder: (context, index) {
          final t = _tarefas[index];
          return ListTile(
            title: Text(t.titulo),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (t.descricao != null && t.descricao!.isNotEmpty)
                  Text(t.descricao!),
                Text('Prioridade: ${t.prioridade ?? '-'}'),
                if (t.projetoRelacionado != null &&
                    t.projetoRelacionado!.isNotEmpty)
                  Text('Projeto: ${t.projetoRelacionado!}'),
                Text('Criado: ${t.criadoEm}'),
              ],
            ),
            isThreeLine: true,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _mostrarFormulario(t),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _excluir(t.id!),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarFormulario(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
