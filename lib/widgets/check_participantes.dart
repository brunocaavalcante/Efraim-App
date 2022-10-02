import 'package:app_flutter/models/usuario.dart';
import 'package:app_flutter/services/firebase_messaging_service.dart';
import 'package:app_flutter/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckParticipante extends StatefulWidget {
  Usuario participante;
  CheckParticipante({Key? key, required this.participante}) : super(key: key);

  @override
  _CheckParticipanteState createState() => _CheckParticipanteState();
}

class _CheckParticipanteState extends State<CheckParticipante> {
  @override
  Widget build(BuildContext context) {
    var participante = widget.participante;

    return CheckboxListTile(
      value: participante.check ?? false,
      onChanged: (newValue) {
        setState(() => participante.check = newValue);
      },
      title: Text(
        participante.name ?? "",
        textAlign: TextAlign.start,
      ),
      controlAffinity: ListTileControlAffinity.trailing,
      contentPadding: const EdgeInsetsDirectional.fromSTEB(10, 0, 30, 0),
    );
  }
}
