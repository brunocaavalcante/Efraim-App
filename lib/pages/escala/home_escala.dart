import 'package:app_flutter/models/escala.dart';
import 'package:app_flutter/pages/core/widget_ultil.dart';
import 'package:flutter/material.dart';
import 'index_escala_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeEscala extends StatelessWidget {
  const HomeEscala({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    goToPage(String page) {
      var escala = Escala();
      escala.setor = page;

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => IndexEscalaPage(escala: escala)));
    }

    return Scaffold(
        appBar: WidgetUltil.barWithArrowBackIos(context, "Escalas"),
        body: Row(children: [
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height,
              child: Column(children: [
                GestureDetector(
                    onTap: () => goToPage("Limpeza"),
                    child: itemMenu(
                        "Limpeza", FontAwesomeIcons.handsClapping, 50)),
                GestureDetector(
                    onTap: () => goToPage("Monte"),
                    child: itemMenu(
                        "Oração no Monte", FontAwesomeIcons.handsPraying, 50)),
              ])),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height,
              child: Column(children: [
                //itemMenu("Culto no lar", Icons.home),
                GestureDetector(
                    onTap: () => goToPage("Jejum"),
                    child: itemMenu("Jejum", FontAwesomeIcons.bookBible, 50)),
              ]))
        ]));
  }

  itemMenu(String text, IconData itemIcon, double size) {
    return Container(
        margin: const EdgeInsets.all(20),
        child: Column(children: [
          FaIcon(itemIcon, size: size),
          Text(text, style: const TextStyle(fontSize: 20))
        ]));
  }
}
