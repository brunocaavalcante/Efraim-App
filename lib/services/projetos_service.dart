import 'package:app_flutter/models/caixa.dart';
import 'package:app_flutter/models/opracao_caixa.dart';
import 'package:app_flutter/models/projeto.dart';
import 'package:app_flutter/models/task.dart';
import 'package:app_flutter/models/usuario.dart';
import 'package:app_flutter/pages/core/custom_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProjetoService extends ChangeNotifier {
  CollectionReference projetos =
      FirebaseFirestore.instance.collection('projetos');
  static const String path = "projetos";

  Future<QuerySnapshot<Object?>> getProjetos() async {
    return projetos.get();
  }

  salvarProjeto(Projeto entity) async {
    DocumentReference docRef = await projetos.add(entity.toJson()).catchError(
        (error) => throw CustomException(
            "ocorreu um erro ao cadastrar tente novamente"));

    entity.id = docRef.id;
    addCaixa(entity);
  }

  updateProjeto(Projeto entity) async {
    await projetos.doc(entity.id).set(entity.toJson()).catchError((error) =>
        throw CustomException("ocorreu um erro ao atualizar tente novamente"));
  }

  excluirProjeto(Projeto entity) async {
    await projetos.doc(entity.id).delete().catchError((error) =>
        throw CustomException("ocorreu um erro ao excluir tente novamente"));
  }

//REGION TASKS
  Future<void> addTaskParticipanteProjeto(
      String idProjeto, String idParticipante, Task task) async {
    await projetos
        .doc(idProjeto)
        .collection('participantes')
        .doc(idParticipante)
        .collection('tasks')
        .add(task.toJson())
        .catchError((error) =>
            throw CustomException("Ocorreu um erro ao cadastrar a task."));
  }

  Future<void> updateTaskParticipanteProjeto(
      String idProjeto, String idParticipante, Task task) async {
    await projetos
        .doc(idProjeto)
        .collection('participantes')
        .doc(idParticipante)
        .collection('tasks')
        .doc(task.id)
        .set(task.toJson())
        .catchError((error) =>
            throw CustomException("Ocorreu um erro ao atualizar a task."));
  }

  Future<void> deleteTaskParticipante(
      String idProjeto, String idParticipante, Task task) async {
    await projetos
        .doc(idProjeto)
        .collection('participantes')
        .doc(idParticipante)
        .collection('tasks')
        .doc(task.id)
        .delete()
        .catchError((error) =>
            throw CustomException("Ocorreu um erro ao excluir a task."));
  }

//REGION PARTICIPANTES
  Future<void> addParticipanteProjeto(
      Projeto projeto, Usuario participante) async {
    await projetos
        .doc(projeto.id)
        .collection('participantes')
        .doc(participante.id)
        .set(participante.toJson())
        .catchError((error) => throw CustomException(
            "ocorreu um erro ao atualizar tente novamente"));
  }

  Future<void> excluirParticipanteProjeto(
      Projeto projeto, Usuario participante) async {
    await projetos
        .doc(projeto.id)
        .collection('participantes')
        .doc(participante.id)
        .delete()
        .catchError((error) => throw CustomException(
            "ocorreu um erro ao exluir participante tente novamente"));
  }

  Future<QuerySnapshot<Object?>> getParticipantes(Projeto projeto) async {
    return await projetos.doc(projeto.id).collection("participantes").get();
  }
  //END REGION PARTICIPANTES

  //REGION CAIXA
  Future<void> addCaixa(Projeto entity) async {
    var caixa = Caixa();
    caixa.saldo = 0;
    projetos.doc(entity.id).collection("caixa").add(caixa.toJson()).catchError(
        (error) => throw CustomException(
            "ocorreu um erro ao adicionar tente novamente"));
  }

  Future<void> addOperacao(Projeto projeto, OperacaoCaixa operacaoCaixa) async {
    await projetos
        .doc(projeto.id)
        .collection('caixa')
        .doc(projeto.caixa.id)
        .collection("historico")
        .add(operacaoCaixa.toJson())
        .catchError((error) => throw CustomException(
            "ocorreu um erro ao atualizar tente novamente"));
  }

  Future<QuerySnapshot<Object?>> getCaixa(Projeto entity) async {
    return projetos.doc(entity.id).collection("caixa").get();
  }

  Future<QuerySnapshot<Object?>> getHitorico(Projeto entity) async {
    return projetos
        .doc(entity.id)
        .collection("caixa")
        .doc(entity.caixa.id)
        .collection("historico")
        .get();
  }
  //END REGION CAIXA
}
