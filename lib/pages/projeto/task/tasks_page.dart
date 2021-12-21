import 'package:app_flutter/models/projeto.dart';
import 'package:app_flutter/models/task.dart';
import 'package:app_flutter/models/usuario.dart';
import 'package:app_flutter/pages/projeto/task/task_add_page.dart';
import 'package:app_flutter/theme/app-colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TasksPage extends StatefulWidget {
  Projeto projeto;
  TasksPage({Key? key, required this.projeto}) : super(key: key);

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final formKey = GlobalKey<FormState>();
  final descricao = TextEditingController();
  final titulo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[addTask(), getParticipantesTasks()],
    );
  }

  Widget fieldTitulo() {
    return TextFormField(
        decoration: const InputDecoration(labelText: 'Tituilo:'),
        controller: titulo,
        validator: (value) {
          if (value!.isEmpty) {
            return "Campo obrigatório";
          }
          return null;
        });
  }

  Widget fieldDescricao() {
    return TextFormField(
        decoration: const InputDecoration(labelText: 'Descrição:'),
        controller: descricao,
        validator: (value) {
          if (value!.isEmpty) {
            return "Campo obrigatório";
          }
          return null;
        });
  }

  getParticipantesTasks() {
    Stream<QuerySnapshot> _participanteStream = FirebaseFirestore.instance
        .collection('projetos')
        .doc(widget.projeto.id)
        .collection("participantes")
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: _participanteStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Erro!');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Carregando");
        }

        return ListView(
          shrinkWrap: true,
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            data["id"] = document.id;
            var participante = Usuario().toEntity(data);

            return Container(
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFFCFD8DC)))),
              child: ExpansionTile(
                  leading: const Icon(Icons.account_circle_rounded,
                      color: Colors.blueGrey, size: 50),
                  title: Text(participante.name),
                  children: []),
            );
          }).toList(),
        );
      },
    );
  }

  mostrarDetalhes(Task task) {}

  Container addTask() {
    return Container(
        padding: const EdgeInsets.only(right: 32.0, left: 32, top: 32),
        child: Row(
          children: <Widget>[
            const Icon(Icons.group_add_sharp, size: 30, color: Colors.blue),
            const SizedBox(width: 10),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TaskAddPage(),
                  ),
                );
              },
              child: const Text("Adicionar nova Tarefa",
                  style: TextStyle(fontSize: 20)),
            ),
          ],
        ));
  }
}
