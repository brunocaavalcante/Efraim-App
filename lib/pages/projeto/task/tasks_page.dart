import 'package:app_flutter/models/projeto.dart';
import 'package:app_flutter/models/task.dart';
import 'package:app_flutter/models/usuario.dart';
import 'package:app_flutter/pages/projeto/task/task_add_page.dart';
import 'package:app_flutter/services/projetos_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class TasksPage extends StatefulWidget {
  Projeto projeto;
  TasksPage({Key? key, required this.projeto}) : super(key: key);

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  var participantes = <Usuario>[];

  @override
  Widget build(BuildContext context) {
    participantes = [];
    return Column(
      children: <Widget>[
        addTask(),
        Container(
            height: MediaQuery.of(context).size.height / 1.5,
            child: getParticipantesTasks())
      ],
    );
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
            participantes.add(participante);

            return Container(
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFFCFD8DC)))),
              child: ExpansionTile(
                  leading: const Icon(Icons.account_circle_rounded,
                      color: Colors.blueGrey, size: 50),
                  title: Text(participante.name),
                  children: [getTasks(participante)]),
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
                widget.projeto.listParticipantes = participantes;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TaskAddPage(projeto: widget.projeto),
                  ),
                );
              },
              child: const Text("Adicionar nova Tarefa",
                  style: TextStyle(fontSize: 20)),
            ),
          ],
        ));
  }

  getTasks(Usuario participante) {
    Stream<QuerySnapshot> tasksStream = FirebaseFirestore.instance
        .collection('projetos')
        .doc(widget.projeto.id)
        .collection("participantes")
        .doc(participante.id)
        .collection('tasks')
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: tasksStream,
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
            var task = Task().toEntity(data);

            return Container(
              height: 40,
              margin: const EdgeInsetsDirectional.only(start: 35, bottom: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(1),
                          bottomRight: Radius.circular(1),
                          topLeft: Radius.circular(1),
                          topRight: Radius.circular(1),
                        ),
                        child: Theme(
                            data: ThemeData(
                              checkboxTheme: CheckboxThemeData(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            ),
                            child: CheckboxListTile(
                              value: task.status,
                              onChanged: (newValue) async {
                                task.status = newValue;
                                await context
                                    .read<ProjetoService>()
                                    .updateTaskParticipanteProjeto(
                                        widget.projeto.id,
                                        participante.id,
                                        task);
                              },
                              title: Text(task.descricao,
                                  style: task.status == true
                                      ? const TextStyle(color: Colors.grey)
                                      : const TextStyle(color: Colors.black),
                                  textAlign: TextAlign.start),
                              controlAffinity: ListTileControlAffinity.leading,
                            ))),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
