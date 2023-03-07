import 'package:app_flutter/models/usuario.dart';
import 'package:app_flutter/pages/agenda/agenda_page.dart';
import 'package:app_flutter/pages/escala/home_escala.dart';
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
      children: [
        SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.95,
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
                                    ? Image.network(
                                        auth.usuario?.photoURL as String,
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
                            style: const TextStyle(
                                fontSize: 17, color: Colors.white),
                          ),
                          Text(
                            auth.usuario?.email ?? "",
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.white),
                          )
                        ])),
                itemMenu(
                    "Projetos", Icons.album_rounded, const IndexProjetoPage()),
                itemMenu("Membros", Icons.people_alt, const IndexMembroPage()),
                itemMenu(
                    "Agenda", Icons.view_agenda_rounded, const AgendaPage()),
                itemMenu("Escalas", Icons.list, const HomeEscala()),
                ListTile(
                    leading: const Icon(Icons.person_search),
                    title: const Text("Meu Perfil",
                        style: TextStyle(fontSize: 18)),
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
                  leading: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.red),
                  title: const Text("Sair",
                      style: TextStyle(fontSize: 18, color: Colors.red)),
                  onTap: () => context.read<UserService>().logout(),
                )
              ],
            )),
        retornaVersao()
      ],
    ));
  }

  itemMenu(String text, IconData? icon, Widget page) {
    return ListTile(
        leading: Icon(icon),
        title: Text(text, style: const TextStyle(fontSize: 18)),
        onTap: () async {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => page));
        });
  }

  retornaVersao() {
    return const SizedBox(
      width: 200,
      child: Text(
        "Versão: 5.3.0 - 06/03/2023",
        style: TextStyle(fontSize: 14, color: Colors.grey),
      ),
    );
  }
}
