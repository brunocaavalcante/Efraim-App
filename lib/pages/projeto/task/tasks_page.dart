import 'package:app_flutter/models/projeto.dart';
import 'package:app_flutter/models/task.dart';
import 'package:app_flutter/models/usuario.dart';
import 'package:app_flutter/pages/projeto/task/task_add_page.dart';
import 'package:app_flutter/services/projetos_service.dart';
import 'package:app_flutter/theme/app-colors.dart';
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
        SizedBox(
            height: MediaQuery.of(context).size.height * 0.67,
            child: getParticipantesTasks())
      ],
    );
  }

  getParticipantesTasks() {
    Stream<QuerySnapshot> participanteStream = FirebaseFirestore.instance
        .collection('projetos')
        .doc(widget.projeto.id)
        .collection("participantes")
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: participanteStream,
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
                margin: const EdgeInsets.only(bottom: 10),
                child: Card(
                    color: AppColors.cinzaEscuro,
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                        padding: const EdgeInsets.all(6),
                        child: ExpansionTile(
                            trailing: const Icon(
                              Icons.arrow_drop_down_circle_outlined,
                              color: Colors.white,
                            ),
                            leading: Container(
                                width: 50,
                                height: 50,
                                clipBehavior: Clip.antiAlias,
                                decoration:
                                    const BoxDecoration(shape: BoxShape.circle),
                                child: participante.photo != null &&
                                        participante.photo != ""
                                    ? Image.network(
                                        participante.photo as String,
                                        fit: BoxFit.cover)
                                    : Image.asset("imagens/logo_sem_nome.png",
                                        fit: BoxFit.cover)),
                            title: Text(
                              participante.name,
                              style: const TextStyle(color: Colors.white),
                            ),
                            children: [
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.30,
                                  child: getTasks(participante))
                            ]))));
          }).toList(),
        );
      },
    );
  }

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
                margin: const EdgeInsetsDirectional.only(start: 35, bottom: 5),
                child: Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) async {
                    await context.read<ProjetoService>().deleteTaskParticipante(
                        widget.projeto.id, participante.id, task);
                  },
                  background: Container(
                      color: Colors.red,
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      alignment: Alignment.centerRight,
                      child: Container(
                          margin: const EdgeInsets.only(right: 20),
                          child: const Text("Excluir",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)))),
                  child: Card(
                      elevation: 5,
                      margin: const EdgeInsets.only(right: 5, top: 5),
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
                                      widget.projeto.id, participante.id, task);
                            },
                            title: Text(task.descricao,
                                style: task.status == true
                                    ? const TextStyle(color: Colors.grey)
                                    : const TextStyle(color: Colors.black),
                                textAlign: TextAlign.start),
                            controlAffinity: ListTileControlAffinity.leading,
                          ))),
                ));
          }).toList(),
        );
      },
    );
  }
}
