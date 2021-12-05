import 'package:app_flutter/theme/app-colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class IndexProjetoPage extends StatefulWidget {
  const IndexProjetoPage({Key? key}) : super(key: key);

  @override
  _home_projeto_pageState createState() => _home_projeto_pageState();
}

class _home_projeto_pageState extends State<IndexProjetoPage> {
  final Stream<QuerySnapshot> _projetoStream =
      FirebaseFirestore.instance.collection('projetos').snapshots();

  getProjetos() {
    return StreamBuilder<QuerySnapshot>(
      stream: _projetoStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Erro!');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Carregando");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return ListTile(
              leading: const Icon(
                Icons.receipt_long_outlined,
                size: 30,
              ),
              title: Text(data['Titulo']),
              subtitle: Text(data['Descricao']),
            );
          }).toList(),
        );
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
        onPressed: null,
        backgroundColor: AppColors.blue,
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
