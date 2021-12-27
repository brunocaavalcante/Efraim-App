import 'package:app_flutter/models/projeto.dart';
import 'package:app_flutter/theme/app-colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  mostrarDetalhes(Projeto projeto) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DatailsProjetoPage(projeto: projeto),
      ),
    );
  }

  getProjetos() {
    return StreamBuilder<QuerySnapshot>(
      stream: _projetoStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Erro!');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Carregando");
        }

        return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
          data["Id"] = document.id;
          var projeto = Projeto().toEntity(data);

          return GestureDetector(
              onTap: () => mostrarDetalhes(projeto),
              child: Container(
                  margin: const EdgeInsets.all(10),
                  child: Card(
                      elevation: 10,
                      child: Column(children: [
                        Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.3,
                            margin: const EdgeInsets.all(10),
                            child: projeto.photo != ''
                                ? Image.network(projeto.photo,
                                    fit: BoxFit.fitHeight)
                                : Image.asset("imagens/logo_sem_nome.png",
                                    fit: BoxFit.fitHeight)),
                        ListTile(
                            title: Text(projeto.titulo),
                            subtitle: Text(projeto.descricao))
                      ]))));
        }).toList());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Projetos"),
      ),
      body: getProjetos(),
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
}
