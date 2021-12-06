import 'package:app_flutter/models/projeto.dart';
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
}
