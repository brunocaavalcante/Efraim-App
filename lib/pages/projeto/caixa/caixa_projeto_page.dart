import 'package:app_flutter/models/caixa.dart';
import 'package:app_flutter/models/opracao_caixa.dart';
import 'package:app_flutter/models/projeto.dart';
import 'package:app_flutter/pages/core/alert_service.dart';
import 'package:app_flutter/pages/core/currency_input_formatter.dart';
import 'package:app_flutter/pages/core/date_ultils.dart';
import 'package:app_flutter/pages/projeto/caixa/operacao_page.dart';
import 'package:app_flutter/services/projetos_service.dart';
import 'package:app_flutter/theme/app-colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CaixaProjetoPage extends StatefulWidget {
  Projeto projeto;
  CaixaProjetoPage({Key? key, required this.projeto}) : super(key: key) {
    obterCaixa();
  }

  obterCaixa() async {
    QuerySnapshot<Object?> result = await ProjetoService().getCaixa(projeto);
    for (var item in result.docs) {
      Map<String, dynamic> data = item.data() as Map<String, dynamic>;
      projeto.caixa = Caixa().toEntity(data);
      projeto.caixa.id = item.id;
    }
  }

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
    var _caixaStream = FirebaseFirestore.instance
        .collection('projetos')
        .doc(widget.projeto.id)
        .collection("caixa")
        .doc(widget.projeto.caixa.id)
        .snapshots();

    return StreamBuilder<DocumentSnapshot>(
        stream: _caixaStream,
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          var caixa = Caixa().toEntity(data);
          widget.projeto.caixa.saldo = caixa.saldo;

          return Container(
              width: 100,
              height: 100,
              margin: const EdgeInsets.only(left: 15),
              child: ListTile(
                title: Text(FormatarMoeda.formatar(caixa.saldo),
                    style: const TextStyle(fontSize: 40, color: Colors.white)),
                subtitle: Text(DateUltils.formatarData(DateTime.now()),
                    style: const TextStyle(color: Colors.white, fontSize: 17)),
              ));
        });
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
            borderRadius: const BorderRadius.all(Radius.circular(25.0))),
        child: Column(
          children: [
            const Text("Histórico",
                style: TextStyle(color: Colors.white, fontSize: 20)),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: itemHistorico(),
            )
          ],
        ));
  }

  itemHistorico() {
    Stream<QuerySnapshot> _participanteStream = FirebaseFirestore.instance
        .collection('projetos')
        .doc(widget.projeto.id)
        .collection("caixa")
        .doc(widget.projeto.caixa.id)
        .collection("historico")
        .orderBy('DataCadastro', descending: true)
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
              data["Id"] = document.id;
              var operacao = OperacaoCaixa().toEntity(data);
              var operador = operacao.tipoOperacao == 1 ? "+ " : "- ";
              return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(bottom: 10, top: 10),
                  child: Card(
                      child: ListTile(
                          trailing: Text(
                            operador + FormatarMoeda.formatar(operacao.valor),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: operacao.tipoOperacao == 1
                                    ? Colors.green
                                    : Colors.red),
                          ),
                          leading: Container(
                              width: 50,
                              height: 50,
                              clipBehavior: Clip.antiAlias,
                              decoration:
                                  const BoxDecoration(shape: BoxShape.circle),
                              child: operacao.photoContribuinte == ""
                                  ? Image.asset("imagens/logo_sem_nome.png",
                                      fit: BoxFit.cover)
                                  : Image.network(
                                      operacao.photoContribuinte as String,
                                      fit: BoxFit.cover)),
                          subtitle: Text(
                              DateUltils.formatarData(operacao.dataCadastro)),
                          title: Text(operacao.nomeContribuinte.toString(),
                              textAlign: TextAlign.start))));
            }).toList(),
          );
        });
  }

  goToOperacaoPage(int tipoOperacao) {
    if (tipoOperacao == 2 && widget.projeto.caixa.saldo! <= 0) {
      AlertService.showAlert(
          "Atenção", "Saldo insuficiênte para saque.", context);
      return;
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => OperacaoPage(
                projeto: widget.projeto, tipoOperacao: tipoOperacao)));
  }
}
