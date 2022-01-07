import 'package:app_flutter/models/usuario.dart';
import 'package:app_flutter/pages/core/date_ultils.dart';

class Evento {
  DateTime? dataEvento;
  DateTime? dataCadastro;
  String? responsavel;
  String? descricao;
  String? id;
  int? ano;
  int? mes;
  int? dia;

  Map<String, Object?> toJson() {
    return {
      'DataEvento': dataEvento,
      'DataCadastro': dataCadastro,
      'Responsavel': responsavel,
      'Descricao': descricao,
      'Id': id,
      'Ano': dataEvento!.year.toInt(),
      'Mes': dataEvento!.month.toInt(),
      'Dia': dataEvento!.day.toInt(),
    };
  }

  Evento toEntity(Map<String, dynamic> map) {
    descricao = map['Descricao'];
    id = map['Id'];
    dataEvento = DateUltils.onlyDate(map['DataEvento'].toDate() as DateTime);
    dataCadastro = (map['DataCadastro']).toDate();
    responsavel = map['Responsavel'];
    ano = dataEvento!.year;
    mes = dataEvento!.month;
    dia = dataEvento!.day;
    return this;
  }
}
