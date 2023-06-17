// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, avoid_unnecessary_containers, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:i_quanti_2023/services/dbLocal/localdb_service.dart';
import 'package:provider/provider.dart';
import '../../providers/providers.dart';

class SyncDataLocationScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<SyncDataLocationProvider>(context);    
     final capProvider = Provider.of<CapUIProvider>(context); 
      //read local database
       uiProvider.statusUploadSync = false;
    
     DBProvider.db.database; 
     if(uiProvider.status){
       return Scaffold(
            appBar: AppBar(
              title: Text('Datos Sincronizados'),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
            
                   Container(
                      padding: EdgeInsets.all(30),
                      child: Center(
                      child: Text(uiProvider.processStatus, style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 20),),
                    ),
                    ),
            
                    Container(
                      padding: EdgeInsets.all(20),
                    child: Center(
                      child: Text(uiProvider.infoUpdate),
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
                        capProvider.selectedMenuOpt2=1;
                        Navigator.pushReplacementNamed(context, 'home');                             
                      }
                 ),
                 )  ,
               

                 
                ],              
              ),
            ),
          );
    }
    else
    {

       return Scaffold(
      appBar: AppBar(
        title: Text('Sync Data...'),
        automaticallyImplyLeading: false,
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