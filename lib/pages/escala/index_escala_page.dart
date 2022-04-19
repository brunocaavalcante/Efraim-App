import 'package:app_flutter/models/escala.dart';
import 'package:app_flutter/models/usuario.dart';
import 'package:app_flutter/pages/core/date_ultils.dart';
import 'package:app_flutter/pages/core/widget_ultil.dart';
import 'package:app_flutter/pages/escala/add_escala_page.dart';
import 'package:app_flutter/pages/usuario/widget_info_user.dart';
import 'package:app_flutter/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class IndexEscalaPage extends StatefulWidget {
  Escala escala;
  IndexEscalaPage({Key? key, required this.escala}) : super(key: key);

  @override
  State<IndexEscalaPage> createState() => _IndexEscalaPageState();
}

class _IndexEscalaPageState extends State<IndexEscalaPage> {
  var listaUsuarios = <Usuario>[];

  @override
  void initState() {
    recuperaListaUsuarios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: WidgetUltil.barWithArrowBackIos(
            context, widget.escala.setor as String),
        body: Column(
          children: [getLista(), btnAddEscala()],
        ));
  }

  goToAddEscalaPage() {
    var item = widget.escala;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AddEscalaPage(entity: item, lista: listaUsuarios)));
  }

  getLista() {
    return SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.height * 0.76,
            margin: const EdgeInsets.all(10),
            child: getEscalas()));
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

  getEscalas() {
    Stream<QuerySnapshot> _participanteStream = FirebaseFirestore.instance
        .collection('escalas')
        .doc(widget.escala.setor)
        .collection(
            DateTime.now().month.toString() + DateTime.now().year.toString())
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
              data["id"] = document.id;
              var item = Escala().toEntity(data);

              return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(children: [
                        Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(top: 5, left: 2),
                            child: Text(DateUltils.formatarData(item.data),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17))),
                        retornaUsuariosEscalados(item.usuarios)
                      ])));
            }).toList(),
          );
        });
  }

  retornaUsuariosEscalados(lista) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: lista.length,
        itemBuilder: (context, index) {
          return WidgetInfoUser(uid: lista[index]);
        });
  }

  btnAddEscala() {
    return Padding(
        padding: const EdgeInsets.all(14.0),
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
