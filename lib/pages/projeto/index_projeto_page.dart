import 'package:app_flutter/models/projeto.dart';
import 'package:app_flutter/services/projetos_service.dart';
import 'package:app_flutter/theme/app-colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'cadastro_projeto_page.dart';
import 'datails_projeto_page.dart';

class IndexProjetoPage extends StatefulWidget {
  const IndexProjetoPage({Key? key}) : super(key: key);

  @override
  _home_projeto_pageState createState() => _home_projeto_pageState();
}

class _home_projeto_pageState extends State<IndexProjetoPage> {
  final Stream<QuerySnapshot> _projetoStream =
      FirebaseFirestore.instance.collection('projetos').snapshots();
  FirebaseAuth auth = FirebaseAuth.instance;

  mostrarDetalhes(Projeto projeto) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DatailsProjetoPage(projeto: projeto),
      ),
    );
  }

  @override
  void initState() {
    lista();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Projetos"),
      ),
      body: lista(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CadastroProjetoPage()));
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

    return lista;
  }

  Widget createProjetosListView(BuildContext context, AsyncSnapshot snapshot) {
    var projetos = snapshot.data;
    return ListView.builder(
      itemCount: projetos.length,
      itemBuilder: (BuildContext context, int index) {
        return projetos.isNotEmpty
            ? GestureDetector(
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
                        ]))))
            : const CircularProgressIndicator();
      },
    );
  }

  lista() {
    return FutureBuilder(
        future: getLista(),
        initialData: [],
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData)
            return createProjetosListView(context, snapshot);
          else
            return const CircularProgressIndicator();
        });
  }
}
