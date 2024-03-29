import 'dart:io';
import 'package:app_flutter/models/usuario.dart';
import 'package:app_flutter/pages/core/custom_exception.dart';
import 'package:app_flutter/pages/core/date_ultils.dart';
import 'package:app_flutter/services/file_service.dart';
import 'package:app_flutter/services/user_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/src/provider.dart';

class MeuPerfil extends StatefulWidget {
  Usuario usuario;
  MeuPerfil({Key? key, required this.usuario}) : super(key: key);

  @override
  _MeuPerfilState createState() => _MeuPerfilState();
}

class _MeuPerfilState extends State<MeuPerfil> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final dataNascimento = TextEditingController();
  final telefone = TextEditingController();
  final nome = TextEditingController();
  final senha = TextEditingController();
  final confirmSenha = TextEditingController();
  UploadTask? task;
  File? file;
  bool loading = false;

  @override
  void initState() {
    inicializarValores();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meu Perfil')),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              fieldPhoto(),
              fieldName(),
              fieldPhone(),
              fieldDataNascimento(),
              fieldEmail(),
              btnSalvar()
            ],
          ),
        ),
      )),
    );
  }

  btnSalvar() {
    return Padding(
        padding: const EdgeInsets.all(24.0),
        child: ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                editar();
              }
            },
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
              Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("Salvar", style: TextStyle(fontSize: 20))),
              Icon(Icons.check)
            ])));
  }

  Widget fieldName() {
    return Padding(
        padding: const EdgeInsets.all(24),
        child: TextFormField(
          decoration: const InputDecoration(
              labelText: 'Nome:', border: OutlineInputBorder()),
          controller: nome,
          validator: (value) {
            if (value!.isEmpty) {
              return "Campo obrigatório";
            }
            return null;
          },
        ));
  }

  Widget fieldEmail() {
    return Padding(
        padding: const EdgeInsets.all(24),
        child: TextFormField(
            decoration: const InputDecoration(
                labelText: 'E-mail:', border: OutlineInputBorder()),
            controller: email,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value!.isEmpty) {
                return "Campo obrigatório";
              }
              return null;
            }));
  }

  Widget fieldDataNascimento() {
    var mask = MaskTextInputFormatter(mask: '##/##/####');
    return Padding(
        padding: const EdgeInsets.all(24),
        child: TextFormField(
            decoration: const InputDecoration(
                labelText: 'Data de Nascimento:',
                hintText: 'dd/mm/yyyy',
                border: OutlineInputBorder()),
            inputFormatters: [mask],
            controller: dataNascimento,
            keyboardType: TextInputType.datetime,
            validator: (value) {
              if (value!.isEmpty) {
                return "Campo obrigatório";
              }
              return null;
            }));
  }

  Widget fieldPhone() {
    var mask = MaskTextInputFormatter(mask: '(##) # ####-####');
    return Padding(
        padding: const EdgeInsets.all(24),
        child: TextFormField(
            inputFormatters: [mask],
            controller: telefone,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                labelText: 'Telefone:',
                hintText: '(99) 9 9999-9999',
                border: OutlineInputBorder()),
            validator: (value) {
              if (value!.isEmpty) {
                return "Campo obrigatório";
              }
              return null;
            }));
  }

  Widget fieldSenha() {
    return Padding(
        padding: const EdgeInsets.all(24),
        child: TextFormField(
            obscureText: true,
            controller: senha,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                labelText: 'Senha:', border: OutlineInputBorder()),
            validator: (value) {
              if (value!.isEmpty) {
                return "Campo obrigatório";
              }
              if (value.length < 6) {
                return "Senha deve ter no minímo 6 caracteres.";
              }
              return null;
            }));
  }

  Widget fieldConfirmSenha() {
    return Padding(
        padding: const EdgeInsets.all(24),
        child: TextFormField(
            obscureText: true,
            controller: confirmSenha,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                labelText: 'Confirmar senha:', border: OutlineInputBorder()),
            validator: (value) {
              if (value!.isEmpty) {
                return "Campo obrigatório";
              }
              if (value.length < 6) {
                return "Senha deve ter no minímo 6 caracteres.";
              }
              return null;
            }));
  }

  fieldPhoto() {
    return Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        child: Column(children: [
          GestureDetector(
              onTap: () => selectFile(),
              child: Container(
                  width: 130,
                  height: 130,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child:
                      widget.usuario.photo != null && widget.usuario.photo != ''
                          ? Image.network(widget.usuario.photo as String,
                              fit: BoxFit.cover)
                          : Image.asset("imagens/add-photo-back-white.png",
                              fit: BoxFit.cover))),
          task != null ? buildUploadStatus(task!) : Container()
        ]));
  }

  editar() async {
    setState(() => loading = true);
    try {
      var usuario = Usuario();
      usuario.name = nome.text;
      usuario.telefone = telefone.text;
      usuario.email = email.text;
      usuario.photo = widget.usuario.photo;
      usuario.dataNascimento = DateUltils.stringToDate(dataNascimento.text);
      await context.read<UserService>().atualizar(usuario);
      Navigator.pop(context);
    } on CustomException catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
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
    widget.usuario.photo = urlDownload;
    setState(() {});
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
                  child: const CircularProgressIndicator(strokeWidth: 10));
            } else {
              return Container();
            }
          } else {
            return Container();
          }
        },
      );

  inicializarValores() {
    nome.text = widget.usuario.name ?? '';
    telefone.text = widget.usuario.telefone ?? '';
    senha.text = widget.usuario.senha ?? '';
    dataNascimento.text =
        DateUltils.formatarData(widget.usuario.dataNascimento);
    email.text = widget.usuario.email ?? '';
  }
}
