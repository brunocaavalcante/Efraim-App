import 'package:app_flutter/theme/app-colors.dart';
import 'package:flutter/material.dart';

class IndexMembroPage extends StatefulWidget {
  const IndexMembroPage({Key? key}) : super(key: key);

  @override
  _IndexMembroPageState createState() => _IndexMembroPageState();
}

class _IndexMembroPageState extends State<IndexMembroPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Membros"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Testando app no navegador',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        backgroundColor: AppColors.blue,
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
