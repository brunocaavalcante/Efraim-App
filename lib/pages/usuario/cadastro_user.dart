import 'package:app_flutter/models/usuario.dart';
import 'package:app_flutter/pages/core/custom_exception.dart';
import 'package:app_flutter/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/src/provider.dart';

class CadastroUserPage extends StatefulWidget {
  const CadastroUserPage({Key? key}) : super(key: key);

  @override
  _CadastroUserPageState createState() => _CadastroUserPageState();
}

class _CadastroUserPageState extends State<CadastroUserPage> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final dataNascimento = TextEditingController();
  final telefone = TextEditingController();
  final nome = TextEditingController();
  final senha = TextEditingController();
  final confirmSenha = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  Widget fieldName() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Nome:'),
      controller: nome,
      validator: (value) {
        if (value!.isEmpty) {
          return "Campo obrigatório";
        }
        return null;
      },
    );
  }

  Widget fieldEmail() {
    return TextFormField(
        decoration: const InputDecoration(labelText: 'E-mail:'),
        controller: email,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return "Campo obrigatório";
          }
          return null;
        });
  }

  Widget fieldDataNascimento() {
    var mask = MaskTextInputFormatter(mask: '##/##/####');
    return TextFormField(
        decoration: const InputDecoration(
            labelText: 'Data de Nascimento:', hintText: 'dd/mm/yyyy'),
        inputFormatters: [mask],
        controller: dataNascimento,
        keyboardType: TextInputType.datetime,
        validator: (value) {
          if (value!.isEmpty) {
            return "Campo obrigatório";
          }
          return null;
        });
  }

  Widget fieldPhone() {
    var mask = MaskTextInputFormatter(mask: '(##) # ####-####');
    return TextFormField(
        inputFormatters: [mask],
        controller: telefone,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
            labelText: 'Telefone:', hintText: '(99) 9 9999-9999'),
        validator: (value) {
          if (value!.isEmpty) {
            return "Campo obrigatório";
          }
          return null;
        });
  }

  Widget fieldSenha() {
    return TextFormField(
        obscureText: true,
        controller: senha,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(labelText: 'Senha:'),
        validator: (value) {
          if (value!.isEmpty) {
            return "Campo obrigatório";
          }
          if (value.length < 6) {
            return "Senha deve ter no minímo 6 caracteres.";
          }
          return null;
        });
  }

  Widget fieldConfirmSenha() {
    return TextFormField(
        obscureText: true,
        controller: confirmSenha,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(labelText: 'Confirmar senha:'),
        validator: (value) {
          if (value!.isEmpty) {
            return "Campo obrigatório";
          }
          if (value.length < 6) {
            return "Senha deve ter no minímo 6 caracteres.";
          }
          return null;
        });
  }

  registrar() async {
    setState(() => loading = true);
    try {
      var usuario = Usuario();
      usuario.name = nome.text;
      usuario.telefone = telefone.text;
      usuario.email = email.text;
      usuario.senha = senha.text;
      usuario.confirmSenha = confirmSenha.text;
      usuario.dataNascimento =
          DateFormat('dd/MM/yyyy').parse(dataNascimento.text);
      await context.read<UserService>().registrar(usuario);
      Navigator.pop(context);
    } on CustomException catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final btnSalvar = ButtonTheme(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        child: ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                registrar();
              }
            },
            child: const Text(
              "Salvar",
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )));

    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Usuário')),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              fieldName(),
              fieldPhone(),
              fieldDataNascimento(),
              fieldEmail(),
              fieldSenha(),
              fieldConfirmSenha(),
              const SizedBox(height: 30.0),
              btnSalvar
            ],
          ),
        ),
      )),
    );
  }
}
