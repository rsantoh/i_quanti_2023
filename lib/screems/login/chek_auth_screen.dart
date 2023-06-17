

// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/login_service.dart';
import '../screems.dart';

class CheckAuthScreen  extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: authService.readToken(),//el token almacenado
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            //preguntamos  si hay datos
            if(!snapshot.hasData)
                    return  CircularProgressIndicator(
                color: Colors.indigo,
              );
            if(snapshot.data==''|| snapshot.data=='0'){
              Future.microtask(() {
              Navigator.pushReplacement(context, PageRouteBuilder(
                  pageBuilder: (_, __, ___) => LoginScreen(),
                  transitionDuration: Duration(seconds: 0)
                  )
                ); 
              });
            }
            else{
              Future.microtask(() {
              Navigator.pushReplacement(context, PageRouteBuilder(
                  pageBuilder: (_, __, ___) => HomePage(),
                  transitionDuration: Duration(seconds: 0)
                  )
                ); 
              });
              
            }
             //la funcion que se ejecuta apenas el widget termine
            return Container();            
          },
          
          )
      ),
    );
  }
}