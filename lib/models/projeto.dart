import 'package:app_flutter/models/user.dart';

class Projeto {
  var id = '';
  String titulo = '';
  String descricao = '';
  DateTime? dataCadastro = null;
  DateTime? dataInicio = null;
  DateTime? dataFinal = null;
  Usuario? responsavel = null;

  Map<String, Object?> toJson() {
    return {
      'Titulo': titulo,
      'Descricao': descricao,
      'DataInicio': dataInicio,
      'DataFim': dataFinal,
      'DataCadastro': dataCadastro,
      'Id': id,
    };
  }
}
