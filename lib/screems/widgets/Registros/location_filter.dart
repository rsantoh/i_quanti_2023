// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class LocationFilter extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5, right: 5, top: 5),
      child: Container(
        decoration: _boxDecoration(),
        width: double.infinity,
        height: 130,
        
      ),
    );
  }

  BoxDecoration _boxDecoration() => BoxDecoration(
    color: Colors.red,
    borderRadius: BorderRadius.only( topLeft: Radius.circular(15), topRight: Radius.circular(15)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: Offset(0,5)
      )
    ]
  );
}