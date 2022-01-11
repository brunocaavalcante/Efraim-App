import 'package:app_flutter/models/projeto.dart';
import 'package:flutter/material.dart';

class OperacaoPage extends StatefulWidget {
  Projeto projeto;
  int tipoOperacao;
  OperacaoPage({Key? key, required this.projeto, required this.tipoOperacao})
      : super(key: key);

  @override
  _OperacaoPageState createState() => _OperacaoPageState();
}

class _OperacaoPageState extends State<OperacaoPage> {
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
      body: Container(),
      backgroundColor: const Color(0xFFEEEEEE),
    );
  }
}
