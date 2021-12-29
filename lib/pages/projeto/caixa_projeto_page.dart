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
    return Scaffold(
      body: projetoDetail(),
      backgroundColor: const Color(0xFFEEEEEE),
    );
  }

  projetoDetail() {
    return Column(
        children: [containerTop(), containerSaldo(), containerMenu()]);
  }

  containerTop() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.only(top: 50),
      decoration: BoxDecoration(
          color: AppColors.cinzaEscuro,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(25.0),
            bottomRight: Radius.circular(25.0),
          )),
      child: const Text(
        "CAIXA",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
      ),
    );
  }

  containerSaldo() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.94,
      height: MediaQuery.of(context).size.height * 0.15,
      margin: const EdgeInsets.only(bottom: 30),
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(25.0))),
      child: const Text("Saldo: 2000,00",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  containerMenu() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.94,
        height: MediaQuery.of(context).size.height * 0.40,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(25.0))),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              itemMenu("imagens/historico.png", "Histórico", 0.08),
              itemMenu("imagens/deposito.png", "Depósito", 0.08),
              itemMenu("imagens/saque.png", "Saque", 0.09)
            ]),
            const SizedBox(height: 30),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              itemMenu("imagens/report.png", "Relatório", 0.08),
            ])
          ],
        ));
  }

  itemMenu(String image, String text, double size) {
    return Column(children: [
      Container(
          height: MediaQuery.of(context).size.height * size,
          margin: const EdgeInsets.only(top: 10),
          child: Image.asset(image, fit: BoxFit.fitHeight)),
      Text(text, style: const TextStyle(fontSize: 20))
    ]);
  }
}
