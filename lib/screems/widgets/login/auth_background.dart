// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unnecessary_this, sized_box_for_whitespace

import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {

  final Widget child;

  const AuthBackground({
    Key? key, 
  required this.child
  }) ;

  @override
  Widget build(BuildContext context) {
    return Container(
       //color : Colors.red,
        width : double.infinity,
        height: double.infinity, 
        //El stak es una columna pero pone widgets uno dentro de otro como si fueran cartas    
        child: Stack(
          children: [
            _PurpleBox(),

            _HeaderIcon(),

            this.child,

          ],
        ),
      
    );
  }
}

class _HeaderIcon extends StatelessWidget {
 

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        
        child: Container(
        width: double.infinity,
        height: 120,
        margin: EdgeInsets.only(top: 30),
      // child: Icon(Icons.settings_input_svideo_outlined, color:Colors.white, size: 100),
        child: Image(
          image: AssetImage('assets/menu-img.png'),
          fit: BoxFit.cover,
        )
                       
      ),
    );
  }
}

class _PurpleBox extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;//obtener el tamaño de la pantalla
    return Container(
      width: double.infinity,
      height: size.height*0.4,//el 40% de la pantalla      
      decoration: _purpleBackground(),
      child: Stack(//Para poner widgets sobre otros
        children: [
          // Positioned(child:  _Bubble(), top: 120, left: 300,),//podemos cambiar la posicion
          // Positioned(child:  _Bubble(), top: -90, left: 80,),//podemos cambiar la posicion
          // Positioned(child:  _Bubble(), top: 40, left: 10,),//podemos cambiar la posicion
          //  Positioned(child:  _Bubble(), top: 65, right: 110,),//podemos cambiar la posicion
          // Positioned(child:  _Bubble(), top: -10, right: -30,),//podemos cambiar la posicion
          // Positioned(child:  _Bubble(), top: -50, left: -40,),//podemos cambiar la posicion
          // Positioned(child:  _Bubble(), top: -50, left: -30,),//podemos cambiar la posicion
           Positioned(child:  Text('QuantiAPP'), top: 50, left: 10,),//podemos cambiar la posicion
         
         
        ],
      ),
    );
  }

  BoxDecoration _purpleBackground() {
    return BoxDecoration(
      //Metodo en el cual se pone lo del 40%
      gradient: LinearGradient(//gradiente
        // ignore: prefer_const_literals_to_create_immutables
        colors: [
          Color.fromARGB(255, 255, 254, 254),
          Color.fromARGB(255, 214, 210, 210),
          Color.fromARGB(255, 255, 254, 254),
        ]
      )
    );
  }
}

class _Bubble extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Color.fromRGBO(255, 255, 255, 0.1)
      ),
    );
    
  }
}