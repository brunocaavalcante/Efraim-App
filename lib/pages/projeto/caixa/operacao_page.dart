import 'package:app_flutter/models/caixa.dart';
import 'package:app_flutter/models/opracao_caixa.dart';
import 'package:app_flutter/models/projeto.dart';
import 'package:app_flutter/models/usuario.dart';
import 'package:app_flutter/pages/projeto/caixa/confirmacao_page.dart';
import 'package:app_flutter/services/projetos_service.dart';
import 'package:app_flutter/pages/core/currency_input_formatter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final valor = TextEditingController();
  int view = 1;
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
      body: customView(),
      backgroundColor: const Color(0xFFEEEEEE),
    );
  }

  containerAtribuir() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Atribuir operação para:",
            style: TextStyle(fontSize: 30),
          ),
          Container(
              child: listaMembros(), margin: const EdgeInsets.only(top: 20)),
        ],
      ),
    );
  }

  listaMembros() {
    Stream<QuerySnapshot> _participanteStream =
        FirebaseFirestore.instance.collection('users').snapshots();

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
                          child: ListTile(
                              onTap: () => goToConfirmacao(participante),
                              leading: Container(
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
                                      : Image.asset("imagens/logo_sem_nome.png",
                                          fit: BoxFit.cover)),
                              subtitle: Text(participante.email),
                              title: Text(participante.name,
                                  textAlign: TextAlign.start)))));
            }).toList(),
          );
        });
  }

  btnProximo() {
    return Padding(
        padding: const EdgeInsets.all(24.0),
        child: ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                setState(() {
                  view = 2;
                });
              }
            },
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("Próximo", style: TextStyle(fontSize: 20))),
              Icon(Icons.arrow_forward_ios)
            ])));
  }

  Widget fieldValor() {
    return Form(
        key: formKey,
        child: Padding(
            padding: const EdgeInsets.all(24),
            child: TextFormField(
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                  CurrencyInputFormatter()
                ],
                controller: valor,
                style: const TextStyle(fontSize: 30),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'R\$ 0,00',
                    hintStyle: TextStyle(fontSize: 30)),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Campo obrigatório";
                  }
                  return null;
                })));
  }

  addParticipanteInList(Usuario participante) {
    bool jaAdicionado = participantes.any((x) => x.id == participante.id);
    if (jaAdicionado == false) participantes.add(participante);
  }

  containerValor() {
    return SingleChildScrollView(
        child: Column(children: [
      Container(
          margin: const EdgeInsets.only(top: 40, left: 50, bottom: 70),
          child: const Text("Qual o valor da operação?",
              style: TextStyle(fontSize: 30))),
      fieldValor(),
      SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.35),
      btnProximo()
    ]));
  }

  Widget customView() {
    return view == 1 ? containerValor() : containerAtribuir();
  }

  goToConfirmacao(Usuario user) {
    var operacao = OperacaoCaixa();
    operacao.dataCadastro = DateTime.now();
    operacao.idContribuinte = user.id;
    operacao.nomeContribuinte = user.name;
    operacao.photoContribuinte = user.photo;
    operacao.valor = double.tryParse(valor.text
        .replaceRange(0, 3, "")
        .replaceAll(".", "")
        .replaceAll(",", "."));
    operacao.tipoOperacao = widget.tipoOperacao;

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) =>
                ConfirmacaoPage(projeto: widget.projeto, operacao: operacao)));
  }
}
