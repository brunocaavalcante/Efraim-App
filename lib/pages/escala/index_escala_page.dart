import 'package:app_flutter/models/escala.dart';
import 'package:app_flutter/models/usuario.dart';
import 'package:app_flutter/pages/core/date_ultils.dart';
import 'package:app_flutter/pages/core/widget_ultil.dart';
import 'package:app_flutter/pages/escala/add_escala_page.dart';
import 'package:app_flutter/pages/usuario/widget_info_user.dart';
import 'package:app_flutter/services/escala_service.dart';
import 'package:app_flutter/services/user_service.dart';
import 'package:app_flutter/theme/app-colors.dart';
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
          children: [getLista()],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => goToAddEscalaPage(),
          backgroundColor: AppColors.cinzaEscuro,
          child: const Icon(Icons.add),
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
            height: MediaQuery.of(context).size.height * 0.8,
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
              var item = Escala().toEntity(data);
              item.id = document.id;

              return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) async {
                        item.setor = widget.escala.setor;
                        await context.read<EscalaService>().excluir(item);
                      },
                      child: Card(
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(children: [
                            Container(
                                alignment: Alignment.topRight,
                                width: MediaQuery.of(context).size.width,
                                margin:
                                    const EdgeInsets.only(top: 10, right: 10),
                                child: Text(DateUltils.formatarData(item.data),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.cinzaEscuro,
                                        fontSize: 17))),
                            retornaUsuariosEscalados(item.usuarios)
                          ])),
                      background: Container(
                          color: Colors.red,
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          alignment: Alignment.centerRight,
                          child: Container(
                              margin: const EdgeInsets.only(right: 20),
                              child: const Text("Excluir",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold))))));
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
}
