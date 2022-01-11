import 'package:app_flutter/models/usuario.dart';
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
      FirebaseFirestore.instance.collection('users').snapshots();

  getMembros() {
    return StreamBuilder<QuerySnapshot>(
      stream: _membroStream,
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
            var participante = Usuario().toEntity(data);

            return Container(
                margin: const EdgeInsets.only(bottom: 10, top: 10),
                child: Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) async {},
                    child: Card(
                        elevation: 5,
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        child: ListTile(
                            trailing: const Icon(Icons.arrow_back_ios_new),
                            leading: Container(
                                width: 50,
                                height: 50,
                                clipBehavior: Clip.antiAlias,
                                decoration:
                                    const BoxDecoration(shape: BoxShape.circle),
                                child: participante.photo != null &&
                                        participante.photo != ""
                                    ? Image.network(
                                        participante.photo as String,
                                        fit: BoxFit.cover)
                                    : Image.asset("imagens/logo_sem_nome.png",
                                        fit: BoxFit.cover)),
                            subtitle: Text(participante.email),
                            title: Text(participante.name,
                                textAlign: TextAlign.start))),
                    background: Container(
                        color: Colors.red,
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        alignment: Alignment.centerRight,
                        child: Container(
                            margin: const EdgeInsets.only(right: 20),
                            child: const Text("Excluir", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))))));
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Membros", style: TextStyle(fontSize: 25)),
      ),
      body: getMembros(),
      backgroundColor: AppColors.cinzaEscuro,
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        backgroundColor: AppColors.blue,
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
