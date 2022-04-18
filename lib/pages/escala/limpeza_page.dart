import 'package:app_flutter/models/escala.dart';
import 'package:app_flutter/models/usuario.dart';
import 'package:app_flutter/pages/core/widget_ultil.dart';
import 'package:app_flutter/pages/escala/add_escala_page.dart';
import 'package:app_flutter/services/escala_service.dart';
import 'package:app_flutter/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class LimpezaPage extends StatefulWidget {
  const LimpezaPage({Key? key}) : super(key: key);

  @override
  State<LimpezaPage> createState() => _LimpezaPageState();
}

class _LimpezaPageState extends State<LimpezaPage> {
  var listaUsuarios = <Usuario>[];

  @override
  Widget build(BuildContext context) {
    recuperaListaUsuarios();
    return Scaffold(
        appBar: WidgetUltil.barWithArrowBackIos(context, "Limpeza"),
        body: Column(
          children: [getLista(), btnAddEscala()],
        ));
  }

  goToAddEscalaPage() {
    var item = Escala();
    item.setor = "Limpeza";
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AddEscalaPage(entity: item, lista: listaUsuarios)));
  }

  getLista() {
    return GestureDetector(
        onTap: () => null,
        child: Container(
            margin: const EdgeInsets.all(10),
            child: Card(
                elevation: 10,
                child: Column(children: [
                  ListTile(
                      title: Text("05/04/2022 - Sexta"),
                      subtitle: Text("Escalados:"))
                ]))));
  }

  recuperaListaUsuarios() async {
    var lista = await context.read<UserService>().obterTodos();

    for (var item in lista.docs) {
      Map<String, dynamic> data = item.data() as Map<String, dynamic>;
      var user = Usuario().toEntity(data);
      user.id = item.id;
      listaUsuarios.add(user);
    }
  }

  btnAddEscala() {
    return Padding(
        padding: const EdgeInsets.all(24.0),
        child: ElevatedButton(
            onPressed: () => goToAddEscalaPage(),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: const Text("Adicionar Escala",
                      style: TextStyle(fontSize: 20))),
              const Icon(Icons.add)
            ])));
  }
}
