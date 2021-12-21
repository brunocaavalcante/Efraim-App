import 'package:app_flutter/theme/app-colors.dart';
import 'package:flutter/material.dart';

class CaixaProjetoPage extends StatefulWidget {
  const CaixaProjetoPage({Key? key}) : super(key: key);

  @override
  _CaixaProjetoPageState createState() => _CaixaProjetoPageState();
}

class _CaixaProjetoPageState extends State<CaixaProjetoPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
            color: AppColors.cinzaEscuro,
            height: MediaQuery.of(context).size.height / 6),
        Container(
            child: projetoDetail(),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0),
                )),
            height: MediaQuery.of(context).size.height / 2),
      ],
    );
  }

  projetoDetail() {
    return Container(
      margin: const EdgeInsets.only(top: 80.0),
      padding: const EdgeInsets.only(top: 70.0),
      child: SingleChildScrollView(
          child: Column(children: [
        ListTile(title: const Text("Descrição"), subtitle: Text("Teste")),
        ListTile(title: const Text("Data Cadastro"), subtitle: Text("Teste")),
      ])),
    );
  }
}
