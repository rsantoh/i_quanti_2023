// ignore_for_file: prefer_const_constructors, unnecessary_new, unnecessary_this, prefer_collection_literals, avoid_print, empty_catches, file_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:i_quanti_2023/models/bodegas.dart';
import 'package:http/http.dart' as http;
import 'package:i_quanti_2023/services/dbLocal/localdb_service.dart';


class LocationService extends ChangeNotifier{
 final storage = new FlutterSecureStorage();
  final List<Bodegas> bodegas = [];  
  String querySe = '';
  String queryAx = '';

  Future <List<Bodegas>> aviableWarehouseList() async{
    String idBodega = querySe ;
  
    // if( queryAx ){

    // }

    List<Bodegas> bodegas2 = [];
          bodegas2 = await DBProvider.db.deleteAllInventoryClose();  
     if(idBodega == '')
      {
        idBodega = '0';
      }      
       this.bodegas.clear();
      String _id = await storage.read(key: 'usuarioID') ?? '';      

      String _connMode = await storage.read(key: 'iConection') ?? '';
      //TODO: 
      //_connMode = '1';
      if(_connMode == '0'){
        // DBProvider.db.deleteInventory();
        this.bodegas.clear();
         if(idBodega == '0'){           
           this.bodegas.clear();
           final  bodegas2 = await DBProvider.db.getAllInventoryData();
          for (var i = 0; i < bodegas2.length; i++)  {
          //insert reg
            this.bodegas.add(bodegas2[i]); 
          } 
         }else{
           this.bodegas.clear();
          final bodegas2 = await DBProvider.db.getInventoryLocal(idBodega);
          for (var i = 0; i < bodegas2.length; i++)  {
          //insert reg
            this.bodegas.add(bodegas2[i]); 
          } 
         }
          var seen = Set<String>();
          List<Bodegas> uniquelist = bodegas.where((bod) => seen.add(bod.ubicacionId.toString())).toList();
          this.bodegas.clear();
          for (var i = 0; i < uniquelist.length; i++)  {
          //insert reg
            this.bodegas.add(uniquelist[i]); 
          }  
          print('Total datos unique offline = ' + uniquelist.length.toString());
          
      }
      else if(_connMode == '1'){
        final String urlAPI = await DBProvider.db.GetApiUrl('getInventario');           
        print(urlAPI);
          try {
             var request = http.Request('GET', Uri.parse(urlAPI+_id+'/'+idBodega.toString()+''));
            http.StreamedResponse response = await request.send();
            if (response.statusCode == 200) {
            final resp = await response.stream.bytesToString(); 
            final respuesta = jsonDecode(resp);
            final resp2 = respuesta['table'];        
            print('Total datos = ' + resp2.length.toString());
            bodegas.clear();      
            for (var i = 0; i < resp2.length; i++) { 
                    
              final temp = Bodegas.fromMap(resp2[i]);  
              this.bodegas.add(temp);
            } 
            }
            else {
              EasyLoading.showError('API NOT FOUND');
              bodegas.clear(); 
            }  
          } catch (e) {
          }
          
      }

      for (var i = 0; i < bodegas.length; i++) {
            for (var a = 0; a < bodegas2.length; a++) {
               if(bodegas[i].ubicacionId == bodegas2[a].ubicacionId){
                 //No muestra en pantalla la bodega cerrada
                 bodegas[i].estado = 'CERRADA';

               }
            } 
          }


      return this.bodegas.toList();   
  }        
    

   Future<String> saveIdLocation(String idValor) async {

    storage.write(key: 'locationId', value: idValor);

    return '1';

  }

}




