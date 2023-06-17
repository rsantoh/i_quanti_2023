// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, avoid_unnecessary_containers, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:i_quanti_2023/providers/providers.dart';
import 'package:provider/provider.dart';


class SyncDataScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
     final uiProvider = Provider.of<SyncDataProvider>(context); 
     final uiReProvider = Provider.of<UiReProvider>(context); 
      //read local database
   
    if(uiProvider.status){
       return Scaffold(
            appBar: AppBar(
              title: Text('Products Sync...'),
            ),
            body: Column(
              children: [

                 Container(
                    padding: EdgeInsets.all(30),
                    child: Center(
                    child: Text('Los datos han sido sincronizados', style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 20),),
                  ),
                  ),

                  Container(
                    padding: EdgeInsets.all(30),
                  child: Center(
                    child: Text(uiProvider.infoScreen),
                  ),
                  ),
                
                Container(

                  child: MaterialButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  disabledColor: Colors.grey,
                  elevation: 0,
                  color: Colors.blueAccent,
                  
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                      child: Text(
                      'Continuar'                      
                      ), 
                    ),
                    onPressed: () {
                      uiProvider.status = false;
                      uiReProvider.selectedMenuOpt=0;
                      Navigator.pushReplacementNamed(context, 'home');                             
                    }
          ),
                )
               

              ],
              
            ),

          );

    }
    else
    {
        // uiProvider.asyncData();
       return Scaffold(
      appBar: AppBar(
        title: Text('Sync Data...'),
      ),
      body: Column(
        children: [

           Container(
            height: 70,
            width: 50,
            ),

             Container(
               padding: EdgeInsets.all(30),
            child: Center(
              child: Text('Sync Data'),
            ),
            ),

             Container(
               padding: EdgeInsets.all(30),
            child: Center(
              child: Text(uiProvider.infoUpdate),
            ),
            ),
          
          
          Container(
            padding: EdgeInsets.all(30),
           
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.indigo,
              )
            ),
          ),

        ],
        
      ),

    );
    }

   
  }
}