import 'package:flutter/material.dart';

class ParticipantePage extends StatefulWidget {
  const ParticipantePage({Key? key}) : super(key: key);

  @override
  _ParticipantePageState createState() => _ParticipantePageState();
}

class _ParticipantePageState extends State<ParticipantePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ItemInfo(),
        ),
      ],
    );
  }

  Container participantesDetail() {
    return Container(
      padding: const EdgeInsets.all(32.0),
      child: ListTile(
        title: Text("Participantes"),
        subtitle: Text("Participante"),
        leading: Icon(
          Icons.emoji_emotions_rounded,
          color: Colors.blueGrey[900],
        ),
      ),
    );
  }
}

class ItemInfo extends StatelessWidget {
  const ItemInfo();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: <Widget>[
          shopeName(),
          Text(
            "Nowadays, making printed materials have become fast, easy and simple. If you want your promotional material to be an eye-catching object, you should make it colored. By way of using inkjet printer this is not hard to make. An inkjet printer is any printer that places extremely small droplets of ink onto paper to create an image.",
            style: TextStyle(
              height: 1.5,
            ),
          ),
          SizedBox(height: size.height * 0.1),
        ],
      ),
    );
  }

  Row shopeName() {
    return Row(
      children: <Widget>[
        Icon(
          Icons.location_on,
          color: Colors.amber,
        ),
        SizedBox(width: 10),
        Text("name"),
      ],
    );
  }
}
