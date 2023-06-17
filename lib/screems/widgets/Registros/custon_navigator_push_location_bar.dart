// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/providers.dart';



class CustomNavigationPushLocBar extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

  final uiProvider = Provider.of<CapUIProvider>(context);
    final currentIndex = uiProvider.selectedMenuOpt2;
    
    return BottomNavigationBar( 
      onTap: (int i) => uiProvider.selectedMenuOpt2 = i ,

      currentIndex: currentIndex,
      elevation: 0,
      items: <BottomNavigationBarItem>[       
         BottomNavigationBarItem(           
            icon: Icon(Icons.app_registration_outlined, color: Colors.blue),
            label: 'Captura',   
          ),
            BottomNavigationBarItem(
            icon: Icon(Icons.content_paste_outlined,  color: Colors.blue ),
            label: 'Consolidado'
          ),
              BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_sharp, color: Colors.blue),
            label: 'Detalles'
          ),
      //      BottomNavigationBarItem(
      //   icon: Icon(Icons.autorenew_sharp, color: Colors.blue),
      //   label: ''
      // ),
      ] 
            
      );

   

  
     
  }
}