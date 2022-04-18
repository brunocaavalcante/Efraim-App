import 'package:app_flutter/pages/core/widget_ultil.dart';
import 'package:app_flutter/theme/app-colors.dart';
import 'package:flutter/material.dart';

import 'limpeza_page.dart';

class HomeEscala extends StatelessWidget {
  const HomeEscala({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    goToLimpezaPage() {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LimpezaPage()));
    }

    return Scaffold(
        appBar: WidgetUltil.barWithArrowBackIos(context, "Escalas"),
        body: Row(children: [
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height,
              child: Column(children: [
                GestureDetector(
                    onTap: () => goToLimpezaPage(),
                    child: itemMenu("Limpeza", Icons.clean_hands_sharp)),
                itemMenu("Evagelismo", Icons.book)
              ])),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height,
              child: Column(children: [
                itemMenu("Culto no lar", Icons.home),
                itemMenu("Limpeza", Icons.clean_hands_sharp)
              ]))
        ]));
  }

  itemMenu(String text, IconData itemIcon) {
    return Container(
        margin: const EdgeInsets.all(30),
        child: Column(children: [
          Icon(itemIcon, size: 80, color: AppColors.cinzaEscuro),
          Text(text, style: const TextStyle(fontSize: 25))
        ]));
  }
}
