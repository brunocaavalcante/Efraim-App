import 'package:app_flutter/models/opracao_caixa.dart';
import 'package:app_flutter/models/projeto.dart';
import 'package:app_flutter/pages/core/date_ultils.dart';
import 'package:app_flutter/services/projetos_service.dart';
import 'package:app_flutter/pages/core/currency_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class ConfirmacaoPage extends StatefulWidget {
  Projeto projeto;
  OperacaoCaixa operacao;

  ConfirmacaoPage({Key? key, required this.projeto, required this.operacao})
      : super(key: key);

  @override
  _ConfirmacaoPageState createState() => _ConfirmacaoPageState();
}

class _ConfirmacaoPageState extends State<ConfirmacaoPage> {
  @override
  Widget build(BuildContext context) {
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
          flexibleSpace: const Align(
            alignment: AlignmentDirectional(0, 1),
            child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                child: Text("Confirmação",
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 20,
                        fontWeight: FontWeight.bold))),
          )),
      body: containerView(),
      backgroundColor: const Color(0xFFEEEEEE),
    );
  }

  containerView() {
    var operacaoString =
        widget.operacao.tipoOperacao == 1 ? "Depósito" : "Saque";

    return Column(
      children: [
        containerHeader(),
        containerItem(
            "Contribuinte", widget.operacao.nomeContribuinte as String),
        containerItem(
            "Data", DateUltils.formatarData(widget.operacao.dataCadastro)),
        containerItem("Tipo de operação", operacaoString),
        btnProximo()
      ],
    );
  }

  btnProximo() {
    return Padding(
        padding: const EdgeInsets.all(24.0),
        child: ElevatedButton(
            onPressed: () async {
              await context
                  .read<ProjetoService>()
                  .addOperacao(widget.projeto, widget.operacao);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
              Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("Confirmar", style: TextStyle(fontSize: 20))),
              Icon(Icons.check)
            ])));
  }

  containerHeader() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.3,
        padding: const EdgeInsets.all(30),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text("Valor", style: TextStyle(fontSize: 30)),
          Container(
              margin: const EdgeInsets.only(top: 20, bottom: 10),
              child: Text(FormatarMoeda.formatar(widget.operacao.valor),
                  style: const TextStyle(fontSize: 50))),
        ]));
  }

  containerItem(String titulo, String value) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.12,
        padding: const EdgeInsets.only(top: 20, left: 30),
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: const TextStyle(fontSize: 20, color: Colors.grey),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }
}
