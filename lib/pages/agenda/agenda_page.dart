import 'package:app_flutter/models/evento.dart';
import 'package:app_flutter/pages/core/date_ultils.dart';
import 'package:app_flutter/services/agenda_service.dart';
import 'package:app_flutter/theme/app-colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({Key? key}) : super(key: key);

  @override
  _AgendaPageState createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  late Map<DateTime, List<Evento>> eventosMes;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController _eventController = TextEditingController();

  @override
  void initState() {
    eventosMes = {};
    super.initState();
  }

  List<Evento> _getEventsMonth(DateTime date) {
    return eventosMes[DateUltils.onlyDate(date)] ?? [];
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Agenda")),
        body: bodyCalendar(),
        floatingActionButton: addEvento());
  }

  addEvento() {
    return FloatingActionButton.extended(
      onPressed: () => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Add Evento"),
          content: TextFormField(
            controller: _eventController,
          ),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text("Ok"),
              onPressed: () async {
                if (_eventController.text.isEmpty) {
                } else {
                  var evento = Evento();
                  evento.descricao = _eventController.text;
                  evento.dataEvento = selectedDay;
                  evento.dataCadastro = DateTime.now();
                  evento.responsavel = auth.currentUser!.displayName ?? '';
                  adicionarEvento(evento);
                }
                Navigator.pop(context);
                _eventController.clear();
                return;
              },
            ),
          ],
        ),
      ),
      label: const Text("Add Evento"),
      icon: const Icon(Icons.add),
      backgroundColor: Colors.black,
    );
  }

  adicionarEvento(Evento entity) async {
    await context.read<AgendaService>().adicionarEvento(entity);
  }

  bodyCalendar() {
    Stream<QuerySnapshot> _eventoStream = FirebaseFirestore.instance
        .collection('agenda')
        .where('Ano', isEqualTo: selectedDay.year)
        .where('Mes', isEqualTo: selectedDay.month)
        .snapshots();

    return SingleChildScrollView(
      child: StreamBuilder(
        stream: _eventoStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            snapshot.data.docs.forEach((item) {
              Map<String, dynamic> data = item.data() as Map<String, dynamic>;
              var evento = Evento().toEntity(data);
              evento.id = item.id;

              if (eventosMes[evento.dataEvento] != null) {
                if (!eventoJaAdicionado(
                    evento, eventosMes[evento.dataEvento])) {
                  eventosMes[evento.dataEvento]?.add(evento);
                }
              } else {
                eventosMes[evento.dataEvento as DateTime] = [evento];
              }
            });
            final eventosDia =
                eventosMes[DateUltils.onlyDate(selectedDay)] ?? [];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  clipBehavior: Clip.antiAlias,
                  margin: const EdgeInsets.all(8.0),
                  child: TableCalendar(
                      locale: 'pt_BR',
                      focusedDay: focusedDay,
                      selectedDayPredicate: (day) =>
                          isSameDay(day, selectedDay),
                      firstDay: DateTime(1990),
                      lastDay: DateTime(2050),
                      eventLoader: _getEventsMonth,
                      onDaySelected: (_selectedDay, _focusedDay) {
                        setState(() {
                          selectedDay = _selectedDay;
                          focusedDay = _focusedDay;
                        });
                      },
                      onPageChanged: (_focusedDay) {
                        setState(() {
                          selectedDay = _focusedDay;
                          focusedDay = _focusedDay;
                        });
                      },
                      headerStyle: HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          formatButtonShowsNext: false,
                          formatButtonDecoration: BoxDecoration(
                            color: AppColors.blue,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          formatButtonTextStyle: const TextStyle(
                            color: Colors.white,
                          ))),
                ),
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: AppColors.cinzaEscuro,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0),
                      )),
                  child: Column(children: [
                    Container(
                        margin: const EdgeInsets.only(top: 10),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.53,
                        child: getEventosDay(eventosDia))
                  ]),
                )
              ],
            );
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }

  getEventosDay(List<Evento> eventosDay) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: eventosDay.length,
        itemBuilder: (BuildContext context, int index) {
          Evento evento = eventosDay[index];
          return Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) async {
                    eventosMes[evento.dataEvento]!.remove(evento);
                    await context.read<AgendaService>().excluirEvento(evento);
                    setState(() {});
                  },
                  child: Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: ListTile(
                          trailing: const Icon(Icons.arrow_back_ios_new),
                          subtitle: Text(
                              DateFormat('EEEE, dd MMMM, yyyy', 'pt_BR')
                                  .format(evento.dataEvento as DateTime)),
                          title: Text(evento.descricao as String,
                              textAlign: TextAlign.start))),
                  background: Container(
                      color: Colors.red,
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      alignment: Alignment.centerRight,
                      child: Container(
                          margin: const EdgeInsets.only(right: 20),
                          child: const Text("Excluir",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold))))));
        });
  }

  bool eventoJaAdicionado(Evento evento, List<Evento>? lista) {
    for (var item in lista!) {
      if (evento.id == item.id) return true;
    }
    return false;
  }
}
