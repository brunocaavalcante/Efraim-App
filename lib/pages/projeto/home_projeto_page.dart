import 'package:app_flutter/models/projeto.dart';
import 'package:app_flutter/theme/app-colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeProjetoPage extends StatefulWidget {
  Projeto projeto;
  HomeProjetoPage({Key? key, required this.projeto}) : super(key: key);

  @override
  _HomeProjetoState createState() => _HomeProjetoState();
}

class _HomeProjetoState extends State<HomeProjetoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: returnBody(),
      backgroundColor: AppColors.cinzaEscuro,
    );
  }

  returnBody() {
    return Stack(
      children: <Widget>[
        Container(
            color: AppColors.cinzaEscuro,
            height: MediaQuery.of(context).size.height / 6),
        projetoDetail(),
        Container(
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              "imagens/add-photo-back-white.png",
              height: 130,
              width: 130,
              fit: BoxFit.contain,
            ))
      ],
    );
  }

  projetoDetail() {
    return Container(
      margin: const EdgeInsets.only(top: 80.0),
      padding: const EdgeInsets.only(top: 70.0),
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0),
          )),
      child: SingleChildScrollView(
          child: Column(children: [
        ListTile(
            title: const Text("Descrição"),
            subtitle: Text(widget.projeto.descricao)),
        ListTile(
            title: const Text("Data Cadastro"),
            subtitle: Text(formatarData(widget.projeto.dataCadastro))),
        ListTile(
            title: const Text("Data Início"),
            subtitle: Text(formatarData(widget.projeto.dataInicio))),
        ListTile(
            title: const Text("Data Final"),
            subtitle: Text(formatarData(widget.projeto.dataFinal))),
        ListTile(
            title: const Text("Administrador"),
            subtitle: Text(widget.projeto.responsavel!.name))
      ])),
    );
  }

  formatarData(DateTime? data) {
    if (data != null) {
      return DateFormat('dd/MM/yyyy').format(data);
    } else {
      return "";
    }
  }
}
