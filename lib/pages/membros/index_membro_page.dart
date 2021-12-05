import 'package:app_flutter/theme/app-colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class IndexMembroPage extends StatefulWidget {
  const IndexMembroPage({Key? key}) : super(key: key);

  @override
  _IndexMembroPageState createState() => _IndexMembroPageState();
}

class _IndexMembroPageState extends State<IndexMembroPage> {
  final Stream<QuerySnapshot> _membroStream =
      FirebaseFirestore.instance.collection('membros').snapshots();

  getMembros() {
    return StreamBuilder<QuerySnapshot>(
      stream: _membroStream,
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
                Icons.person_sharp,
                size: 30,
              ),
              title: Text(data['Nome']),
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
        title: const Text("Membros"),
      ),
      body: getMembros(),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        backgroundColor: AppColors.blue,
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
