import 'package:app_flutter/models/usuario.dart';

class Escala {
  String? id;
  String? responsavel;
  DateTime? data;
  DateTime? dataCadastro;
  List<String>? usuarios;
  String? setor;

  Map<String, Object?> toJson() {
    return {
      'Responsavel': responsavel,
      'Data': data,
      'DataCadastro': dataCadastro,
      'Usuarios': usuarios
    };
  }

  Escala toEntity(Map<String, dynamic> map) {
    responsavel = map['Responsavel'];
    data = (map['Data']).toDate();
    dataCadastro = (map['DataCadastro']).toDate();
    usuarios = map['Usuarios'];
    return this;
  }
}
