// ignore_for_file: prefer_const_constructors, unused_local_variable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/ui_re_provider.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

  final uiProvider = Provider.of<UiReProvider>(context);
    final currentIndex = uiProvider.selectedMenuOpt;
    final idBodega = uiProvider.bodegaBusq;

    if(uiProvider.status == false){

        return BottomNavigationBar( 
      onTap: (int i) => uiProvider.selectedMenuOpt = i ,
        
      currentIndex: 0,
      elevation: 0,
      // ignore: prefer_const_literals_to_create_immutables
      items: <BottomNavigationBarItem>[
       
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on,color: Colors.blue,),
            label: 'Ubicaciones'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.autorenew_sharp,color: Colors.grey,),
            label: 'Sinc. Ubicaciones',
            //activeIcon: false
          ),
        ] 
            
      );


    }
    else{

        return BottomNavigationBar( 
      onTap: (int i) => uiProvider.selectedMenuOpt = i ,

      currentIndex: currentIndex,
      elevation: 0,
      // ignore: prefer_const_literals_to_create_immutables
      items: <BottomNavigationBarItem>[
       
         BottomNavigationBarItem(
          icon: Icon(Icons.location_on,color: Colors.blue,),
          label: 'Ubicaciones'
        ),
         BottomNavigationBarItem(
          icon: Icon(Icons.autorenew_sharp,color: Colors.blue,),
          label: 'Sinc. Ubicaciones'
        ),
      ] 
            
      );


    }
       
  }
}