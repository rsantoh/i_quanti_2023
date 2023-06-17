// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class InputDecorations{

  static InputDecoration authInputDecoration({
    //Argumentos que reciben
    required String hintText,
     required String labelText,
     IconData? prefixIcon

  }){
    return InputDecoration(
        
        enabledBorder: UnderlineInputBorder(
         
          borderSide: BorderSide(
            color: Colors.black
          )
        ),
        
        focusedBorder: UnderlineInputBorder(
          
          borderSide: BorderSide(
            color: Colors.black,
            width: 2
          )
        ),
        hintText: hintText,
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.black
        ),
        prefixIcon: prefixIcon != null
        ? Icon(prefixIcon, color: Colors.black, )
        : null
    );
  }
}