class Tarefa {
  int? id;
  String titulo;
  String? descricao;
  int? prioridade;
  String criadoEm;
  String? projetoRelacionado;

  Tarefa({
    this.id,
    required this.titulo,
    this.descricao,
    this.prioridade,
    String? criadoEm,
    this.projetoRelacionado,
  }) : criadoEm = criadoEm ?? DateTime.now().toIso8601String();

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'titulo': titulo,
      'descricao': descricao,
      'prioridade': prioridade,
      'criadoEm': criadoEm,
      'projetoRelacionado': projetoRelacionado,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  factory Tarefa.fromMap(Map<String, dynamic> map) {
    return Tarefa(
      id: map['id'] as int?,
      titulo: map['titulo'] as String? ?? '',
      descricao: map['descricao'] as String?,
      prioridade: map['prioridade'] as int?,
      criadoEm: map['criadoEm'] as String?,
      projetoRelacionado: map['projetoRelacionado'] as String?,
    );
  }
}
