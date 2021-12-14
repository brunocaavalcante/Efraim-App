import 'package:app_flutter/models/projeto.dart';
import 'package:app_flutter/models/user.dart';
import 'package:app_flutter/services/projetos_service.dart';
import 'package:app_flutter/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class ParticipantePage extends StatefulWidget {
  Projeto projeto;
  ParticipantePage({Key? key, required this.projeto}) : super(key: key);

  @override
  _ParticipantePageState createState() => _ParticipantePageState();
}

class _ParticipantePageState extends State<ParticipantePage> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  Usuario user = Usuario();

  Widget fieldEmail() {
    return TextFormField(
        decoration: const InputDecoration(labelText: 'E-mail:'),
        controller: email,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          bool emailValid = RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(value.toString());
          if (value!.isEmpty) {
            return "Campo obrigatório";
          } else if (!emailValid) {
            return "Email inválido!";
          }
          return null;
        });
  }

  emailExistente() async {
    user = await context.read<UserService>().obterUsuarioPorEmail(email.text);
    return user.email != null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[addParticipante(), getParticipantes()],
    );
  }

  Container addParticipante() {
    return Container(
        padding: const EdgeInsets.only(right: 32.0, left: 32, top: 32),
        child: Row(
          children: <Widget>[
            const Icon(Icons.group_add_sharp, size: 30, color: Colors.blue),
            const SizedBox(width: 10),
            TextButton(
              onPressed: () {
                email.clear();
                showAlertCadastroParticipante();
              },
              child: const Text("Adicionar Participante",
                  style: TextStyle(fontSize: 20)),
            ),
          ],
        ));
  }

  showAlertCadastroParticipante() {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Adicionar Participante'),
        content: Form(key: formKey, child: fieldEmail()),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancelar'),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                if (await emailExistente()) {
                  adicionarParticipante();
                  Navigator.pop(context, 'OK');
                } else {}
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  showAlertExcluirParticipante(Usuario participante) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Alerta!'),
        content: const Text("Deseja realmente excluir o particiapante?"),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancelar'),
            child: const Text('Cancelar'),
          ),
          TextButton(
              onPressed: () async {
                excluirParticipante(participante);
                Navigator.pop(context, 'OK');
              },
              child: const Text('OK')),
        ],
      ),
    );
  }

  getParticipantes() {
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
              child: ListTile(
                  leading: const Icon(
                    Icons.perm_identity_rounded,
                    color: Colors.blueGrey,
                    size: 30,
                  ),
                  title: Text(participante.name),
                  subtitle: Text(participante.email),
                  onTap: null,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          size: 25.0,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          showAlertExcluirParticipante(participante);
                        },
                      ),
                    ],
                  )),
            );
          }).toList(),
        );
      },
    );
  }

  adicionarParticipante() async {
    await context
        .read<ProjetoService>()
        .addParticipanteProjeto(widget.projeto, user);
  }

  excluirParticipante(Usuario participante) async {
    await context
        .read<ProjetoService>()
        .excluirParticipanteProjeto(widget.projeto, participante);
  }
}
