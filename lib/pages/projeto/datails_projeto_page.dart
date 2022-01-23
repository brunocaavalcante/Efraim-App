import 'package:app_flutter/models/projeto.dart';
import 'package:app_flutter/pages/indisponivel_page.dart';
import 'package:app_flutter/pages/projeto/caixa/caixa_projeto_page.dart';
import 'package:app_flutter/pages/projeto/home_projeto_page.dart';
import 'package:app_flutter/pages/projeto/projeto_participantes_page.dart';
import 'package:app_flutter/pages/projeto/task/tasks_page.dart';
import 'package:app_flutter/theme/app-colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DatailsProjetoPage extends StatefulWidget {
  Projeto projeto;
  DatailsProjetoPage({Key? key, required this.projeto}) : super(key: key);

  @override
  _DatailsProjetoPageState createState() => _DatailsProjetoPageState();
}

class _DatailsProjetoPageState extends State<DatailsProjetoPage> {
  int _currentIndex = 0;
  List<Widget> telas = [];
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0.0,
            toolbarHeight: 60,
            title: ListTile(
              title: Text(
                widget.projeto.titulo,
                style: const TextStyle(color: Colors.white),
              ),
              trailing: Container(
                  width: 45,
                  height: 45,
                  margin: const EdgeInsets.only(top: 15, right: 10, bottom: 5),
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: auth.currentUser?.photoURL != null
                      ? Image.network(auth.currentUser?.photoURL as String,
                          fit: BoxFit.cover)
                      : Image.asset("imagens/user-menu-photo.png",
                          fit: BoxFit.cover)),
            ) //remove borda do appbar
            ),
        body: returnView(),
        bottomNavigationBar: returnNavigatorBarBottom());
  }

  returnNavigatorBarBottom() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.blueGrey[50],
      selectedItemColor: AppColors.blue,
      unselectedItemColor: AppColors.cinzaEscuro.withOpacity(.60),
      selectedFontSize: 16,
      unselectedFontSize: 14,
      currentIndex: _currentIndex,
      onTap: (value) {
        setState(() {
          _currentIndex = value;
        }); // Respond to item press.
      },
      items: const [
        BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home)),
        BottomNavigationBarItem(
            label: "Participantes", icon: Icon(Icons.people)),
        BottomNavigationBarItem(label: "Tarefas", icon: Icon(Icons.task_alt)),
        BottomNavigationBarItem(
            label: "Caixa", icon: Icon(Icons.monetization_on))
      ],
    );
  }

  returnView() {
    telas = [];
    telas.add(HomeProjetoPage(projeto: widget.projeto));
    telas.add(ParticipantePage(projeto: widget.projeto));
    telas.add(TasksPage(projeto: widget.projeto));
    telas.add(const IndisponivelPage());
    return telas[_currentIndex];
  }
}
