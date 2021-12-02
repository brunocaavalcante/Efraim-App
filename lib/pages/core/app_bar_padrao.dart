import 'package:flutter/material.dart';

class AppBarPadrao {
  static retornaBackgroundFundo() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            height: 200.0,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("imagens/backgroud-app-bar.png"))),
          ),
        )
      ],
    );
  }

  static retornaIconAddPhoto() {
    return Positioned(
      top: 100.0,
      child: Container(
        height: 170.0,
        width: 170.0,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: const DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("imagens/user-menu-photo.png"),
            ),
            border: Border.all(color: Colors.white, width: 6.0)),
      ),
    );
  }
}
