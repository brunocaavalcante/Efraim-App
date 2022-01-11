import 'package:app_flutter/models/projeto.dart';
import 'package:app_flutter/pages/core/date_ultils.dart';
import 'package:app_flutter/pages/projeto/caixa/operacao_page.dart';
import 'package:app_flutter/theme/app-colors.dart';
import 'package:flutter/material.dart';

class CaixaProjetoPage extends StatefulWidget {
  Projeto projeto;
  CaixaProjetoPage({Key? key, required this.projeto}) : super(key: key);

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
        children: [containerTop(), containerSaqueDeposito(), containerMenu()]);
  }

  containerTop() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
          color: AppColors.cinzaEscuro,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(25.0),
            bottomRight: Radius.circular(25.0),
          )),
      child: containerSaldo(),
    );
  }

  containerSaldo() {
    return Container(
        width: 100,
        height: 100,
        margin: const EdgeInsets.only(left: 15),
        child: ListTile(
          title: const Text("Saldo: 2000,00",
              style: TextStyle(fontSize: 30, color: Colors.white)),
          subtitle: Text(DateUltils.formatarData(DateTime.now()),
              style: const TextStyle(color: Colors.white)),
        ));
  }

  containerSaqueDeposito() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      GestureDetector(
          onTap: () => goToOperacaoPage(1),
          child: const SizedBox(
              width: 160,
              child: Card(
                  child: ListTile(
                      title: Text("Deposito",
                          style: TextStyle(color: Colors.green)),
                      leading:
                          Icon(Icons.attach_money, color: Colors.green))))),
      GestureDetector(
          onTap: () => goToOperacaoPage(2),
          child: const SizedBox(
              width: 160,
              child: Card(
                  child: ListTile(
                      title: Text("Saque", style: TextStyle(color: Colors.red)),
                      leading: Icon(Icons.attach_money, color: Colors.red)))))
    ]);
  }

  containerMenu() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.94,
        height: MediaQuery.of(context).size.height * 0.50,
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: AppColors.cinzaEscuro,
            borderRadius: BorderRadius.all(Radius.circular(25.0))),
        child: Column(
          children: [
            const Text("Histórico",
                style: TextStyle(color: Colors.white, fontSize: 20)),
            itemHistorico(),
          ],
        ));
  }

  itemHistorico() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 10, top: 10),
      child: Card(
          child: ListTile(
              trailing: Text(
                '+ RS 20,00',
                style: TextStyle(color: Colors.green),
              ),
              leading: Container(
                  width: 50,
                  height: 50,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: Image.asset("imagens/logo_sem_nome.png",
                      fit: BoxFit.cover)),
              subtitle: Text(DateUltils.formatarData(DateTime.now())),
              title: Text("Bruno Cavalcante", textAlign: TextAlign.start))),
    );
  }

  goToOperacaoPage(int tipoOperacao) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => OperacaoPage(
                projeto: widget.projeto, tipoOperacao: tipoOperacao)));
  }
}
