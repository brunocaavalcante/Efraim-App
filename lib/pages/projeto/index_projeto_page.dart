import 'package:app_flutter/models/projeto.dart';
import 'package:app_flutter/pages/core/custom_exception.dart';
import 'package:app_flutter/pages/core/widget_ultil.dart';
import 'package:app_flutter/services/projetos_service.dart';
import 'package:app_flutter/theme/app-colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import '../core/custom_exception.dart';
import 'cadastro_projeto_page.dart';
import 'datails_projeto_page.dart';

class IndexProjetoPage extends StatefulWidget {
  const IndexProjetoPage({Key? key}) : super(key: key);

  @override
  _home_projeto_pageState createState() => _home_projeto_pageState();
}

class _home_projeto_pageState extends State<IndexProjetoPage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  mostrarDetalhes(Projeto projeto) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DatailsProjetoPage(projeto: projeto),
      ),
    );
    if (result != null && result) setState(() {});
  }

  @override
  void initState() {
    getLista();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUltil.barWithArrowBackIos(context, "Projetos"),
      body: lista(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CadastroProjetoPage()));
          if (result != null && result) setState(() {});
        },
        backgroundColor: AppColors.blue,
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<bool> verificaSeProprietarioOuParticipante(
      String idUser, Projeto projeto) async {
    if (idUser == projeto.responsavel!.id) return true;

    var lista = await context.read<ProjetoService>().getParticipantes(projeto);

    for (var item in lista.docs) {
      if (item.id == idUser) return true;
    }

    return false;
  }

  Future<List<Projeto>> getLista() async {
    var projetos = await context.read<ProjetoService>().getProjetos();
    var lista = <Projeto>[];
    try {
      if (projetos != null) {
        for (var item in projetos.docs) {
          Map<String, dynamic> data = item.data() as Map<String, dynamic>;
          var projeto = Projeto().toEntity(data);
          projeto.id = item.id;

          if (await verificaSeProprietarioOuParticipante(
              auth.currentUser!.uid, projeto)) {
            lista.add(projeto);
          }
        }
      }
    } on CustomException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }

    return lista;
  }

  Widget createProjetosListView(BuildContext context, AsyncSnapshot snapshot) {
    var projetos = snapshot.data;
    return ListView.builder(
      itemCount: projetos.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
            onTap: () => mostrarDetalhes(projetos[index]),
            child: Container(
                margin: const EdgeInsets.all(10),
                child: Card(
                    elevation: 10,
                    child: Column(children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.3,
                          margin: const EdgeInsets.all(10),
                          child: projetos[index].photo != ''
                              ? Image.network(projetos[index].photo,
                                  fit: BoxFit.cover)
                              : Image.asset("imagens/logo_sem_nome.png",
                                  fit: BoxFit.fitHeight)),
                      ListTile(
                          title: Text(projetos[index].titulo),
                          subtitle: Text(projetos[index].descricao))
                    ]))));
      },
    );
  }

  lista() {
    return FutureBuilder(
        future: getLista(),
        initialData: const [],
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return createProjetosListView(context, snapshot);
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
