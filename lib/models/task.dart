import 'package:app_flutter/models/usuario.dart';

class Task {
  String titulo = '';
  String descricao = '';
  DateTime? dataCadastro;
  String status = '';
  Usuario? responsavel;
  String id = '';

  Map<String, Object?> toJson() {
    return {
      'titulo': titulo,
      'descricao': descricao,
      'dataCadastro': dataCadastro,
      'status': status,
      'responsavel': responsavel,
      'id': id
    };
  }

  Task toEntity(Map<String, dynamic> map) {
    id = map['id'] ?? "";
    titulo = map['titulo'] ?? "";
    descricao = map['descricao'] ?? "";
    //status = map['status'] ?? "";
    //responsavel = Usuario().toEntity(map['responsavel']);
    if (map['dataCadastro'] != null) {
      dataCadastro = (map['dataCadastro']).toDate();
    }
    return this;
  }
}
