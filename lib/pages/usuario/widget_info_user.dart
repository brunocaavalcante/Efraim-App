import 'package:app_flutter/models/usuario.dart';
import 'package:app_flutter/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WidgetInfoUser extends StatefulWidget {
  String uid;
  WidgetInfoUser({Key? key, required this.uid}) : super(key: key);

  @override
  State<WidgetInfoUser> createState() => _WidgetInfoUserState();
}

class _WidgetInfoUserState extends State<WidgetInfoUser> {
  @override
  Widget build(BuildContext context) {
    UserService auth = Provider.of<UserService>(context);

    return FutureBuilder<Usuario>(
        future: auth.obterUsuarioPorId(widget.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            var participante = snapshot.data;
            return Row(children: [
              Container(
                  width: 30,
                  height: 30,
                  margin: const EdgeInsets.only(
                      left: 20, bottom: 5, right: 10, top: 10),
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child:
                      participante?.photo != null && participante?.photo != ""
                          ? Image.network(participante?.photo as String,
                              fit: BoxFit.cover)
                          : Image.asset("imagens/logo_sem_nome.png",
                              fit: BoxFit.cover)),
              Text(participante?.name.toUpperCase(), textAlign: TextAlign.start)
            ]);
          }
          return Text("Carregando");
        });
  }
}
