import 'package:app_flutter/theme/app-colors.dart';
import 'package:flutter/material.dart';

class TaskAddPage extends StatefulWidget {
  const TaskAddPage({Key? key}) : super(key: key);

  @override
  _TaskAddPageState createState() => _TaskAddPageState();
}

class _TaskAddPageState extends State<TaskAddPage> {
  TextEditingController textController = TextEditingController();
  bool? checkboxListTileValue = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: AppBar(
              backgroundColor: AppColors.cinzaEscuro,
              elevation: 0.0,
              flexibleSpace: const Align(
                alignment: AlignmentDirectional(0, 1),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                  child: Text(
                    'Criar Nova Tarefa',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.white,
                        fontSize: 20),
                  ),
                ),
              )),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.cinzaEscuro,
                  ),
                  child: Align(
                    alignment: const AlignmentDirectional(4, 0),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
                      child: TextFormField(
                        controller: textController,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Descrição',
                          labelStyle: const TextStyle(
                            fontFamily: 'Raleway',
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Color(0xFFDEDEDE)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Color(0xFFDEDEDE)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsetsDirectional.fromSTEB(
                              10, 10, 10, 10),
                        ),
                        style: const TextStyle(
                          fontFamily: 'Raleway',
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
                      child: Text(
                        'Atribuir tarefa para:',
                        style: TextStyle(fontFamily: 'Noto Sans', fontSize: 22),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(0, 0),
                            child: Container(
                              width: 50,
                              height: 50,
                              clipBehavior: Clip.antiAlias,
                              decoration:
                                  const BoxDecoration(shape: BoxShape.circle),
                              child: Image.network(
                                'https://picsum.photos/seed/855/600',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(1),
                                bottomRight: Radius.circular(1),
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(1),
                              ),
                              child: CheckboxListTile(
                                value: checkboxListTileValue ??= false,
                                onChanged: (newValue) => setState(
                                    () => checkboxListTileValue = newValue),
                                title: const Text(
                                  'Bruno Cavalcante',
                                  textAlign: TextAlign.center,
                                ),
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                contentPadding:
                                    const EdgeInsetsDirectional.fromSTEB(
                                        10, 0, 30, 0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                alignment: const AlignmentDirectional(0, -0.6),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                  child: ButtonTheme(
                      minWidth: MediaQuery.of(context).size.width,
                      padding:
                          const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
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
                          onPressed: () {},
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17.0)))),
                ),
              ),
            ]))));
  }
}
