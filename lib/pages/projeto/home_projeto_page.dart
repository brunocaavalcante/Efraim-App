import 'dart:io';

import 'package:app_flutter/models/projeto.dart';
import 'package:app_flutter/pages/projeto/index_projeto_page.dart';
import 'package:app_flutter/services/file_service.dart';
import 'package:app_flutter/services/projetos_service.dart';
import 'package:app_flutter/theme/app-colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';

class HomeProjetoPage extends StatefulWidget {
  Projeto projeto;
  HomeProjetoPage({Key? key, required this.projeto}) : super(key: key);

  @override
  _HomeProjetoState createState() => _HomeProjetoState();
}

class _HomeProjetoState extends State<HomeProjetoPage> {
  UploadTask? task;
  File? file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: returnBody(),
      backgroundColor: AppColors.cinzaEscuro,
    );
  }

  btnExcluir() {
    return Container(
        width: MediaQuery.of(context).size.width - 50,
        height: 50,
        margin: const EdgeInsets.only(top: 50),
        child: OutlinedButton.icon(
          label: const Text(
            'EXCLUIR',
            style: TextStyle(color: Colors.red),
          ),
          icon: const Icon(
            Icons.delete_forever,
            color: Colors.red,
          ),
          onPressed: () {
            showAlertExcluirProjeto();
          },
        ));
  }

  returnBody() {
    return Stack(
      children: <Widget>[
        Container(
            color: AppColors.cinzaEscuro,
            height: MediaQuery.of(context).size.height / 6),
        projetoDetail(),
        Container(
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width,
            child: GestureDetector(
                onTap: () => selectFile(),
                child: Container(
                    width: 130,
                    height: 130,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: widget.projeto.photo != ''
                        ? Image.network(widget.projeto.photo,
                            fit: BoxFit.contain)
                        : Image.asset("imagens/add-photo-back-white.png",
                            fit: BoxFit.contain)))),
        task != null ? buildUploadStatus(task!) : Container(),
      ],
    );
  }

  projetoDetail() {
    return Container(
      margin: const EdgeInsets.only(top: 80.0),
      padding: const EdgeInsets.only(top: 70.0),
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0),
          )),
      child: SingleChildScrollView(
          child: Column(children: [
        ListTile(
            title: const Text("Descrição"),
            subtitle: Text(widget.projeto.descricao)),
        ListTile(
            title: const Text("Data Cadastro"),
            subtitle: Text(formatarData(widget.projeto.dataCadastro))),
        ListTile(
            title: const Text("Data Início"),
            subtitle: Text(formatarData(widget.projeto.dataInicio))),
        ListTile(
            title: const Text("Data Final"),
            subtitle: Text(formatarData(widget.projeto.dataFinal))),
        ListTile(
            title: const Text("Administrador"),
            subtitle: Text(widget.projeto.responsavel!.name)),
        btnExcluir()
      ])),
    );
  }

  formatarData(DateTime? data) {
    if (data != null) {
      return DateFormat('dd/MM/yyyy').format(data);
    } else {
      return "";
    }
  }

  showAlertExcluirProjeto() {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Alerta!'),
        content: const Text("Deseja realmente excluir o Projeto?"),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancelar'),
            child: const Text('Cancelar'),
          ),
          TextButton(
              onPressed: () async {
                await context
                    .read<ProjetoService>()
                    .excluirProjeto(widget.projeto);
                Navigator.pop(context);
                Navigator.pop(context, true);
              },
              child: const Text('OK')),
        ],
      ),
    );
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() {
      file = File(path);
      uploadFile();
    });
  }

  Future uploadFile() async {
    if (file == null) return;

    final fileName = file!.path;
    final destination = 'files/$fileName';
    task = FileService.uploadFile(destination, file!);

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    widget.projeto.photo = urlDownload;
    updateProjeto(widget.projeto);
    setState(() {});
  }

  updateProjeto(Projeto projeto) async {
    await context.read<ProjetoService>().updateProjeto(projeto);
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100);

            if (percentage < 100.0) {
              return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(strokeWidth: 10));
            } else {
              return Container();
            }
          } else {
            return Container();
          }
        },
      );
}
