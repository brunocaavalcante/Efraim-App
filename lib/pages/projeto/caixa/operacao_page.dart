import 'package:app_flutter/models/projeto.dart';
import 'package:app_flutter/models/usuario.dart';
import 'package:app_flutter/pages/core/alertService.dart';
import 'package:app_flutter/pages/core/custom_exception.dart';
import 'package:app_flutter/pages/projeto/caixa/check_participantes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/src/provider.dart';

class OperacaoPage extends StatefulWidget {
  Projeto projeto;
  int tipoOperacao;
  OperacaoPage({Key? key, required this.projeto, required this.tipoOperacao})
      : super(key: key);

  @override
  _OperacaoPageState createState() => _OperacaoPageState();
}

class _OperacaoPageState extends State<OperacaoPage> {
  final formKey = GlobalKey<FormState>();
  final nome = TextEditingController();
  final valor = TextEditingController();
  List<Usuario> participantes = <Usuario>[];

  @override
  Widget build(BuildContext context) {
    String operacao = widget.tipoOperacao == 1 ? "Depósito" : "Saque";

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context, true);
            },
            color: Colors.black,
          ),
          backgroundColor: const Color(0xFFEEEEEE),
          elevation: 0.0,
          flexibleSpace: Align(
            alignment: const AlignmentDirectional(0, 1),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
              child: Text(
                operacao,
                textAlign: TextAlign.start,
                style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )),
      body: formOperacao(),
      backgroundColor: const Color(0xFFEEEEEE),
    );
  }

  formOperacao() {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            fieldValor(),
            const Text(
              "Atribuir operação para:",
              style: TextStyle(fontSize: 18),
            ),
            Container(
                child: getParticipantes(),
                height: MediaQuery.of(context).size.height * 0.55,
                margin: const EdgeInsets.only(top: 20)),
            btnSalvar()
          ],
        ),
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
              addParticipanteInList(participante);

              return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                          padding: const EdgeInsets.all(6),
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
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle),
                                      child: participante.photo != null &&
                                              participante.photo != ""
                                          ? Image.network(
                                              participante.photo as String,
                                              fit: BoxFit.cover)
                                          : Image.asset(
                                              "imagens/logo_sem_nome.png",
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
                                        child: CheckParticipante(
                                            participante: participante)))
                              ]))));
            }).toList(),
          );
        });
  }

  btnSalvar() {
    return Padding(
        padding: const EdgeInsets.all(24.0),
        child: ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                adicionarOperacao();
              }
            },
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.check),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Salvar",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ])));
  }

  Widget fieldValor() {
    var mask = MaskTextInputFormatter(mask: 'R\$ ##,##');
    return Padding(
        padding: const EdgeInsets.all(24),
        child: TextFormField(
            inputFormatters: [mask],
            controller: valor,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Valor:',
                hintText: 'R\$ 00,00'),
            validator: (value) {
              if (value!.isEmpty) {
                return "Campo obrigatório";
              }
              return null;
            }));
  }

  adicionarOperacao() async {
    try {
      if (participantes.any((x) => x.check == true)) {
        print(participantes.length);
        /* await context
              .read<ProjetoService>()
              .addOperacao(projeto, operacaoCaixa);*/
        Navigator.pop(context);
      } else {
        AlertService.showAlert(
            "Alerta!", "Nenhum participante selecionado!", context);
      }
    } on CustomException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  addParticipanteInList(Usuario participante) {
    bool jaAdicionado = participantes.any((x) => x.id == participante.id);
    if (jaAdicionado == false) participantes.add(participante);
  }
}
