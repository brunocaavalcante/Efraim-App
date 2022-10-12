import 'package:app_flutter/models/projeto.dart';
import 'package:app_flutter/models/task.dart';
import 'package:app_flutter/models/usuario.dart';
import 'package:app_flutter/pages/core/alert_service.dart';
import 'package:app_flutter/pages/core/custom_exception.dart';
import 'package:app_flutter/services/projetos_service.dart';
import 'package:app_flutter/theme/app-colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class TaskAddPage extends StatefulWidget {
  Projeto projeto;
  TaskAddPage({Key? key, required this.projeto}) : super(key: key);

  @override
  _TaskAddPageState createState() => _TaskAddPageState();
}

class _TaskAddPageState extends State<TaskAddPage> {
  TextEditingController textController = TextEditingController();
  var participantes = <Usuario>[];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final descricao = TextEditingController();

  Widget fieldDescricao() {
    return TextFormField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: 'Descrição:',
          labelStyle: const TextStyle(
            fontFamily: 'Raleway',
            color: Colors.white,
            fontSize: 20,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFDEDEDE)),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFDEDEDE)),
            borderRadius: BorderRadius.circular(10),
          ),
          errorStyle: const TextStyle(color: Colors.white),
          contentPadding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
        ),
        controller: descricao,
        validator: (value) {
          if (value!.isEmpty) return "Campo obrigatório";
          return null;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: AppBar(
              backgroundColor: AppColors.cinzaEscuro,
              elevation: 0.0,
              flexibleSpace: const Align(
                alignment: AlignmentDirectional(0, 1),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                  child: Text(
                    'Criar Nova Tarefa',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.white,
                        fontSize: 20),
                  ),
                ),
              )),
        ),
        body: ListView(children: [
          Column(children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 5,
                decoration: BoxDecoration(
                  color: AppColors.cinzaEscuro,
                ),
                child: Align(
                  alignment: const AlignmentDirectional(4, 0),
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
                    child: Form(key: formKey, child: fieldDescricao()),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
              child: Text(
                'Atribuir Tarefa Para:',
                style: TextStyle(fontFamily: 'Noto Sans', fontSize: 22),
              ),
            ),
            SizedBox(
                child: getParticipante(),
                height: MediaQuery.of(context).size.height / 1.9)
          ]),
          btnSalvar()
        ]));
  }

  btnSalvar() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 70,
        alignment: const AlignmentDirectional(0, -0.6),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
          child: ButtonTheme(
              minWidth: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              child: returnButton(Icons.save, "Salvar")),
        ));
  }

  returnButton(IconData ic, String text) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: ElevatedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            adicionarTask();
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(ic),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(text, style: const TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }

  adicionarTask() async {
    bool anySelected = false;
    try {
      for (var item in participantes) {
        if (item.check ?? false) {
          anySelected = true;
          var task = Task();
          task.dataCadastro = DateTime.now();
          task.descricao = descricao.text;
          task.responsavel = item;

          await context
              .read<ProjetoService>()
              .addTaskParticipanteProjeto(widget.projeto.id, item.id, task);
        }
      }
      if (!anySelected) {
        AlertService.showAlert(
            "Alerta!", "Nenhum participante selecionado!", context);
      } else {
        Navigator.pop(context);
      }
    } on CustomException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  getParticipante() {
    participantes = widget.projeto.listParticipantes;
    return ListView.builder(
        shrinkWrap: true,
        itemCount: participantes.length,
        itemBuilder: (context, index) {
          return Card(
              elevation: 5,
              child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(0, 0),
                          child: Container(
                              width: 50,
                              height: 50,
                              clipBehavior: Clip.antiAlias,
                              decoration:
                                  const BoxDecoration(shape: BoxShape.circle),
                              child: participantes[index].photo != null &&
                                      participantes[index].photo != ""
                                  ? Image.network(
                                      participantes[index].photo as String,
                                      fit: BoxFit.cover)
                                  : Image.asset("imagens/logo_sem_nome.png",
                                      fit: BoxFit.cover)),
                        ),
                        Expanded(
                            child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(1),
                                  bottomRight: Radius.circular(1),
                                  topLeft: Radius.circular(0),
                                  topRight: Radius.circular(1),
                                ),
                                child: CheckboxListTile(
                                  value: participantes[index].check ?? false,
                                  onChanged: (newValue) {
                                    setState(() =>
                                        participantes[index].check = newValue);
                                  },
                                  title: Text(
                                    participantes[index].name ?? "",
                                    textAlign: TextAlign.start,
                                  ),
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                  contentPadding:
                                      const EdgeInsetsDirectional.fromSTEB(
                                          10, 0, 30, 0),
                                )))
                      ])));
        });
  }
}
