import 'package:flutter/material.dart';

class HomeEscala extends StatefulWidget {
  const HomeEscala({Key? key}) : super(key: key);

  @override
  State<HomeEscala> createState() => _HomeEscalaState();
}

class _HomeEscalaState extends State<HomeEscala> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Escalas'),
        ),
        body: Container());
  }
}
