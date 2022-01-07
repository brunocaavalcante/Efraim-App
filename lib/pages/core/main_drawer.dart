import 'package:app_flutter/models/usuario.dart';
import 'package:app_flutter/pages/agenda/agenda_page.dart';
import 'package:app_flutter/pages/membros/index_membro_page.dart';
import 'package:app_flutter/pages/projeto/index_projeto_page.dart';
import 'package:app_flutter/pages/usuario/meu_perfil.dart';
import 'package:app_flutter/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    UserService auth = Provider.of<UserService>(context);

    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              height: 150,
              color: Theme.of(context).primaryColor,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Container(
                          width: 45,
                          height: 45,
                          margin: const EdgeInsets.only(
                              top: 15, right: 10, bottom: 5),
                          clipBehavior: Clip.antiAlias,
                          decoration:
                              const BoxDecoration(shape: BoxShape.circle),
                          child: auth.usuario?.photoURL != null
                              ? Image.network(auth.usuario?.photoURL as String,
                                  fit: BoxFit.cover)
                              : Image.asset("imagens/user-menu-photo.png",
                                  fit: BoxFit.cover)),
                      Container(
                          margin: const EdgeInsets.only(
                              top: 20, right: 20, bottom: 10),
                          child: const Text("C.E.EFRAIM",
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)))
                    ]),
                    Text(
                      auth.usuario?.displayName ?? "",
                      textAlign: TextAlign.start,
                      style: const TextStyle(fontSize: 17, color: Colors.white),
                    ),
                    Text(
                      auth.usuario?.email ?? "",
                      textAlign: TextAlign.start,
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    )
                  ])),
          ListTile(
              leading: const Icon(Icons.album_rounded),
              title: const Text("Projetos", style: TextStyle(fontSize: 18)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const IndexProjetoPage()));
              }),
          ListTile(
              leading: const Icon(Icons.people_alt),
              title: const Text("Membros", style: TextStyle(fontSize: 18)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const IndexMembroPage()));
              }),
          ListTile(
              leading: const Icon(Icons.view_agenda_rounded),
              title: const Text("Agenda", style: TextStyle(fontSize: 18)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AgendaPage()));
              }),
          ListTile(
              leading: const Icon(Icons.person_search),
              title: const Text("Meu Perfil", style: TextStyle(fontSize: 18)),
              onTap: () async {
                Usuario usuario =
                    await auth.obterUsuarioPorId(auth.usuario!.uid);
                if (usuario.name != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MeuPerfil(
                                usuario: usuario,
                              )));
                }
              }),
          ListTile(
            leading:
                const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.red),
            title: const Text("Sair",
                style: TextStyle(fontSize: 18, color: Colors.red)),
            onTap: () => context.read<UserService>().logout(),
          ),
        ],
      ),
    );
  }
}
