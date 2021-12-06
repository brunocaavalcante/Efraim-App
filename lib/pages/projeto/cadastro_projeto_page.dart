import 'package:app_flutter/models/projeto.dart';
import 'package:app_flutter/services/projetos_service.dart';
import 'package:app_flutter/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CadastroProjetoPage extends StatefulWidget {
  const CadastroProjetoPage({Key? key}) : super(key: key);

  @override
  _CadastroProjetoPageState createState() => _CadastroProjetoPageState();
}

class _CadastroProjetoPageState extends State<CadastroProjetoPage> {
  final formKey = GlobalKey<FormState>();
  final titulo = TextEditingController();
  final dataInicio = TextEditingController();
  final dataFim = TextEditingController();
  final dataCadastro = TextEditingController();
  final descricao = TextEditingController();

  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  Widget fieldTitulo() {
    return TextFormField(
        decoration: const InputDecoration(labelText: 'Nome:'),
        controller: titulo,
        validator: (value) {
          if (value!.isEmpty) {
            return "Campo obrigatório";
          }
          return null;
        });
  }

  Widget fieldDescricao() {
    return TextFormField(
        decoration: const InputDecoration(labelText: 'Descrição:'),
        controller: descricao,
        validator: (value) {
          if (value!.isEmpty) {
            return "Campo obrigatório";
          }
          return null;
        });
  }

  Widget fieldDataInicio() {
    var mask = MaskTextInputFormatter(mask: '##/##/####');
    return TextFormField(
        decoration: const InputDecoration(
            labelText: 'Data de Inicio:', hintText: 'dd/mm/yyyy'),
        inputFormatters: [mask],
        controller: dataInicio,
        keyboardType: TextInputType.datetime,
        validator: (value) {
          if (value!.isEmpty) {
            return "Campo obrigatório";
          }
          return null;
        });
  }

  Widget fieldDataFinal() {
    var mask = MaskTextInputFormatter(mask: '##/##/####');
    return TextFormField(
        decoration: const InputDecoration(
            labelText: 'Data de Termino:', hintText: 'dd/mm/yyyy'),
        inputFormatters: [mask],
        controller: dataFim,
        keyboardType: TextInputType.datetime,
        validator: (value) {
          if (value!.isEmpty) {
            return "Campo obrigatório";
          } else {
            var fim = DateFormat('dd/MM/yyyy').parse(dataFim.text);
            var inicio = DateFormat('dd/MM/yyyy').parse(dataInicio.text);

            if (fim.isBefore(inicio)) {
              return "A data de final do projeto não pode ser anterior a data de início.";
            }
          }
          return null;
        });
  }

  cadastrarProjeto() async {
    setState(() => loading = true);
    try {
      var projeto = Projeto();
      projeto.titulo = titulo.text;
      projeto.descricao = descricao.text;
      projeto.dataInicio = DateFormat('dd/MM/yyyy').parse(dataInicio.text);
      projeto.dataFinal = DateFormat('dd/MM/yyyy').parse(dataFim.text);
      projeto.dataCadastro = DateTime.now();
      await context.read<ProjetoService>().salvarProjeto(projeto);
      Navigator.pop(context);
    } on AuthException catch (e) {
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
        // ignore: deprecated_member_use
        child: RaisedButton(
            color: const Color.fromRGBO(79, 88, 100, 1),
            child: const Text(
              "Salvar",
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                cadastrarProjeto();
              }
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(17.0))));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Projeto'),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              fieldTitulo(),
              fieldDescricao(),
              fieldDataInicio(),
              fieldDataFinal(),
              const SizedBox(height: 30.0),
              btnSalvar
            ],
          ),
        ),
      )),
    );
  }
}
