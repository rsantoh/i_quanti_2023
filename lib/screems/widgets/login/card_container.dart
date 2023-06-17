// ignore_for_file: prefer_const_constructors, unnecessary_this

import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
 
  final Widget child;

  const CardContainer({
    Key? key, 
    required this.child
    }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),//para que nada quede tan pegado a los bordes
        decoration: _createCardShape(),
        child: this.child,
      ),
    );
  }

  BoxDecoration _createCardShape() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25),//redondea las esquinas
      // ignore: prefer_const_literals_to_create_immutables
      boxShadow: [
        
        BoxShadow(
          color: Colors.black38,//color de la sombra
          blurRadius: 15,//que tanto quiero expandir el blur
          offset: Offset(0,5),//Posición a la que quiero mover la sombra
        )
      ]

    );
  }
}