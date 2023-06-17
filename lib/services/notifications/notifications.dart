// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'package:flutter/material.dart';

class NotificationService{

  static late GlobalKey<ScaffoldMessengerState> messengerKey = new GlobalKey<ScaffoldMessengerState>();

  static showSnackbar(String message){    
    final snackBar = SnackBar(
      backgroundColor: Colors.black,
      content: Text(message, style: TextStyle(color: Colors.white, fontSize: 20), 
       // : Colors.deepOrange,
      ) ,
    
    );   
    if(messengerKey.currentState == null){


    }
    else{
      messengerKey.currentState!.showSnackBar(snackBar);
    }
    
  }

}