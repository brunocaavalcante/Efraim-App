import 'package:app_flutter/models/escala.dart';
import 'package:app_flutter/models/usuario.dart';
import 'package:app_flutter/pages/core/alert_service.dart';
import 'package:app_flutter/pages/core/custom_exception.dart';
import 'package:app_flutter/pages/core/date_ultils.dart';
import 'package:app_flutter/pages/core/widget_ultil.dart';
import 'package:app_flutter/services/escala_service.dart';
import 'package:app_flutter/services/user_service.dart';
import 'package:app_flutter/theme/app-colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/src/provider.dart';

class AddEscalaPage extends StatefulWidget {
  Escala entity;
  var lista = <Usuario>[];

  AddEscalaPage({Key? key, required this.entity, required this.lista})
      : super(key: key);

  @override
  State<AddEscalaPage> createState() => _AddEscalaPageState();
}

class _AddEscalaPageState extends State<AddEscalaPage> {
  final Stream<QuerySnapshot> _membroStream =
      FirebaseFirestore.instance.collection('users').snapshots();
  final formKey = GlobalKey<FormState>();
  final data = TextEditingController();
  var participantes = <Usuario>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUltil.barWithArrowBackIos(context, "Adicionar Escala"),
      body: containerBody(),
    );
  }

  containerBody() {
    return SingleChildScrollView(
        child: Column(children: [fieldForm(), containerMenu(), btnSalvar()]));
  }

  Widget fieldForm() {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.95,
        child: Form(key: formKey, child: fieldData()));
  }

  btnSalvar() {
    return Padding(
        padding: const EdgeInsets.all(24.0),
        child: ElevatedButton(
            onPressed: () => salvarEscala(),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: const Text("Salvar", style: TextStyle(fontSize: 20))),
              const Icon(Icons.check)
            ])));
  }

  containerMenu() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.55,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: AppColors.cinzaEscuro,
            borderRadius: const BorderRadius.all(Radius.circular(25.0))),
        child: Column(
          children: [
            const Text("Selecione os escalados:",
                style: TextStyle(color: Colors.white, fontSize: 18)),
            Container(
              margin: const EdgeInsets.only(top: 5),
              height: MediaQuery.of(context).size.height * 0.45,
              child: getMembros(),
            )
          ],
        ));
  }

  getMembros() {
    participantes = widget.lista;
    return ListView.builder(
        shrinkWrap: true,
        itemCount: participantes.length,
        itemBuilder: (context, index) {
          return Card(
              elevation: 5,
              child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Row(children: [
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
                              controlAffinity: ListTileControlAffinity.trailing,
                              contentPadding:
                                  const EdgeInsetsDirectional.fromSTEB(
                                      10, 0, 30, 0),
                            )))
                  ])));
        });
  }

  Widget fieldData() {
    var mask = MaskTextInputFormatter(mask: '##/##/####');
    return Padding(
        padding: const EdgeInsets.all(24),
        child: TextFormField(
            decoration: const InputDecoration(
                labelText: 'Data da Escala:',
                hintText: 'dd/mm/yyyy',
                border: OutlineInputBorder()),
            inputFormatters: [mask],
            controller: data,
            keyboardType: TextInputType.datetime,
            validator: (value) {
              if (value!.isEmpty) {
                return "Campo obrigatório";
              }
              return null;
            }));
  }

  salvarEscala() async {
    if (formKey.currentState!.validate()) {
      var auth = context.read<UserService>().auth.currentUser;
      var escala = widget.entity;
      escala.data = DateUltils.stringToDate(data.text);
      escala.dataCadastro = DateTime.now();
      escala.usuarios = obterIdUsuariosSelecionados();
      escala.responsavel = auth!.uid;
      bool anySelected = escala.usuarios!.isNotEmpty;
      try {
        if (!anySelected) {
          AlertService.showAlert(
              "Alerta!", "Nenhum participante selecionado!", context);
        } else {
          await context.read<EscalaService>().salvar(escala);
          Navigator.pop(context);
        }
      } on CustomException catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  List<String> obterIdUsuariosSelecionados() {
    var lista = <String>[];
    for (var item in participantes) {
      if (item.check ?? false) {
        lista.add(item.id);
      }
    }
    return lista;
  }
}
