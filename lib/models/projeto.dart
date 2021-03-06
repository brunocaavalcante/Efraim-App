import 'package:app_flutter/models/caixa.dart';
import 'package:app_flutter/models/usuario.dart';

class Projeto {
  var id = '';
  String titulo = '';
  String descricao = '';
  DateTime? dataCadastro;
  DateTime? dataInicio;
  DateTime? dataFinal;
  Usuario? responsavel;
  List<Usuario> listParticipantes = [];
  String photo = '';
  Caixa caixa = Caixa();

  Map<String, Object?> toJson() {
    return {
      'Titulo': titulo,
      'Descricao': descricao,
      'DataInicio': dataInicio,
      'DataFim': dataFinal,
      'DataCadastro': dataCadastro,
      'Id': id,
      'Administrador': responsavel!.toJson(),
      'Photo': photo
    };
  }

  Projeto toEntity(Map<String, dynamic> map) {
    titulo = map['Titulo'];
    descricao = map['Descricao'];
    photo = map['Photo'] ?? '';
    dataInicio = (map['DataInicio']).toDate();
    dataFinal = (map['DataFim']).toDate();
    dataCadastro = (map['DataCadastro']).toDate();
    responsavel = Usuario().toEntity(map['Administrador']);
    id = map['Id'];
    return this;
  }
}
