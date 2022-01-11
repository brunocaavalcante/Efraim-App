import 'package:app_flutter/models/constantes.dart';
import 'package:app_flutter/pages/core/main_drawer.dart';
import 'package:app_flutter/theme/app-colors.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  static const styleText = TextStyle(fontSize: 15, color: Colors.grey);
  static const titleText = TextStyle(fontSize: 17, fontWeight: FontWeight.bold);
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[containerTop(), containerInfo()],
          ),
        ),
        drawer:
            const MainDrawer() // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  containerTop() {
    return Center(
        child: Column(children: [
      Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.2,
          margin: const EdgeInsets.only(bottom: 30),
          child: Image.asset("imagens/logo_sem_nome.png", fit: BoxFit.contain)),
      Text('Comunidade Evangélica Efraim',
          style: Theme.of(context).textTheme.headline5)
    ]));
  }

  containerInfo() {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width,
      child: Column(children: [
        ListTile(
            title:
                Text("Endereço:", style: Theme.of(context).textTheme.headline6),
            subtitle: const Text(Constantes.enderecoText, style: styleText)),
        ListTile(
            title: Text("Dias de Culto:",
                style: Theme.of(context).textTheme.headline6),
            subtitle: const Text(Constantes.diasCulto, style: styleText)),
        ListTile(
            title:
                Text("Versão:", style: Theme.of(context).textTheme.headline6),
            subtitle: const Text("1.0.0 - 09/01/2022", style: styleText)),
      ]),
    );
  }
}
