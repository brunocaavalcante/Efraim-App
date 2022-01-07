import 'package:app_flutter/models/evento.dart';
import 'package:app_flutter/pages/core/custom_exception.dart';
import 'package:app_flutter/pages/core/date_ultils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AgendaService extends ChangeNotifier {
  CollectionReference agenda = FirebaseFirestore.instance.collection('agenda');

  adicionarEvento(Evento entity) async {
    await agenda.add(entity.toJson()).catchError((error) =>
        throw CustomException(
            "ocorreu um erro ao cadastrar o evento tente novamente"));
  }

  excluirEvento(Evento entity) async {
    await agenda.doc(entity.id).delete().catchError((error) =>
        throw CustomException("ocorreu um erro ao excluir tente novamente"));
  }
}
