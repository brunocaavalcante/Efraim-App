import 'package:app_flutter/models/projeto.dart';
import 'package:app_flutter/models/task.dart';
import 'package:app_flutter/models/usuario.dart';
import 'package:app_flutter/repository/base-repository.dart';
import 'package:app_flutter/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProjetoService extends ChangeNotifier {
  CollectionReference projetos =
      FirebaseFirestore.instance.collection('projetos');
  static const String path = "projetos";

  getProjetos() async {
    FirebaseFirestore db = await BaseRepository.get();
    var snapshot = await db
        .collection(path)
        //.where('time_id', isEqualTo: timeId)
        .get();

    List<Projeto> projetos = [];
    snapshot.docs.forEach((doc) {
      final data = doc.data();
      var projeto = Projeto();
      projeto.id = doc.id;
      projeto.titulo = data['Titulo'];
      projeto.descricao = data['Descricao'];
      projetos.add(projeto);
    });

    return projetos;
  }

  salvarProjeto(Projeto entity) async {
    await projetos.add(entity.toJson()).catchError((error) =>
        throw AuthException("ocorreu um erro ao cadastrar tente novamente"));
  }

//REGION TASKS
  Future<void> addTaskParticipanteProjeto(
      String idProjeto, String idParticipante, Task task) async {
    await projetos
        .doc(idProjeto)
        .collection('tasks/' + idParticipante)
        .add(task.toJson())
        .catchError((error) =>
            throw AuthException("Ocorreu um erro ao cadastrar a task."));
  }

//REGION PARTICIPANTES
  Future<void> addParticipanteProjeto(
      Projeto projeto, Usuario participante) async {
    await projetos
        .doc(projeto.id)
        .collection('participantes')
        .add(participante.toJson())
        .catchError((error) => throw AuthException(
            "ocorreu um erro ao atualizar tente novamente"));
  }

  Future<void> excluirParticipanteProjeto(
      Projeto projeto, Usuario participante) async {
    await projetos
        .doc(projeto.id)
        .collection('participantes')
        .doc(participante.id)
        .delete()
        .catchError((error) => throw AuthException(
            "ocorreu um erro ao exluir participante tente novamente"));
  }
  //END REGION PARTICIPANTES
}
