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
              color: Theme.of(context).primaryColor,
              child: Row(children: [
                Container(
                  width: 80,
                  height: 80,
                  margin: const EdgeInsets.only(top: 30, bottom: 10, right: 10),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage("imagens/user-menu-photo.png"),
                          fit: BoxFit.fill)),
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                      margin: const EdgeInsets.only(top: 30, right: 20),
                      child: const Text("C.E.EFRAIM",
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold))),
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
                ])
              ])),
          const ListTile(
            leading: Icon(Icons.album_rounded),
            title: Text("Projetos", style: TextStyle(fontSize: 18)),
            onTap: null,
          ),
          const ListTile(
            leading: Icon(Icons.people_alt),
            title: Text("Membros", style: TextStyle(fontSize: 18)),
            onTap: null,
          ),
          const ListTile(
            leading: Icon(Icons.offline_pin_rounded),
            title: Text("Departamentos", style: TextStyle(fontSize: 18)),
            onTap: null,
          ),
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
