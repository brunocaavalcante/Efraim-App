import 'package:app_flutter/models/usuario.dart';

class Task {
  String descricao = '';
  DateTime? dataCadastro;
  Usuario? responsavel;
  String id = '';
  bool? status = false;

  Map<String, Object?> toJson() {
    return {
      'descricao': descricao,
      'dataCadastro': dataCadastro,
      'status': status,
      'id': id
    };
  }

  Task toEntity(Map<String, dynamic> map) {
    id = map['id'] ?? "";
    descricao = map['descricao'] ?? "";
    status = map['status'] ?? false;
    if (map['dataCadastro'] != null) {
      dataCadastro = (map['dataCadastro']).toDate();
    }
    return this;
  }
}
