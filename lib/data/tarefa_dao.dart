import '../models/tarefa.dart';
import 'database_helper.dart';

class TarefaDao {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<int> inserir(Tarefa tarefa) async {
    final db = await _dbHelper.database;
    return await db.insert('tarefas', tarefa.toMap());
  }

  Future<List<Tarefa>> listar() async {
    final db = await _dbHelper.database;
    final maps = await db.query('tarefas', orderBy: 'prioridade DESC, id DESC');
    return maps.map((m) => Tarefa.fromMap(m)).toList();
  }

  Future<int> atualizar(Tarefa tarefa) async {
    final db = await _dbHelper.database;
    return await db.update(
      'tarefas',
      tarefa.toMap(),
      where: 'id = ?',
      whereArgs: [tarefa.id],
    );
  }

  Future<int> excluir(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('tarefas', where: 'id = ?', whereArgs: [id]);
  }
}
