import 'package:app_flutter/models/escala.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EscalaService extends ChangeNotifier {
  CollectionReference escalas =
      FirebaseFirestore.instance.collection('escalas');

  obter(Escala item) async {
    return await escalas
        .doc(item.setor)
        .collection(
            DateTime.now().month.toString() + DateTime.now().year.toString())
        .get();
  }

  salvar(Escala item) async {
    item.dataCadastro = DateTime.now();
    await escalas
        .doc(item.setor)
        .collection(item.dataCadastro!.month.toString() +
            item.dataCadastro!.year.toString())
        .add(item.toJson());
  }

  editar(Escala item) async {
    await escalas
        .doc(item.setor)
        .collection(item.dataCadastro!.month.toString() +
            item.dataCadastro!.year.toString())
        .doc(item.id)
        .set(item.toJson());
  }

  excluir(Escala item) async {
    await escalas
        .doc(item.setor)
        .collection(item.dataCadastro!.month.toString() +
            item.dataCadastro!.year.toString())
        .doc(item.id)
        .delete();
  }
}
