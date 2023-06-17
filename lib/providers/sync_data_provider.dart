// ignore_for_file: prefer_const_constructors, unnecessary_this, empty_catches, avoid_print, unnecessary_new, unused_local_variable

import 'dart:convert';
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:i_quanti_2023/models/bodegas.dart';
import 'package:http/http.dart' as http;
import 'package:i_quanti_2023/services/dbLocal/localdb_service.dart';
import 'package:path_provider/path_provider.dart';

import '../models/models.dart';

class SyncDataProvider extends ChangeNotifier
{
   final storage = new FlutterSecureStorage();
  bool status = false;
   SyncDataProvider(){
      // this.asyncData();    

   }  

  String _infoUpdate = 'syncing data....';
  String infoScreen = 'Los datos han sido actualizados';


  Future<bool> asyncData() async{
       notifyListeners();
       String a = await asyncTablas();       
      notifyListeners();
    return status;
  }


   String get infoUpdate{
    return this._infoUpdate;
  }

  set infoUpdate(String i){
    this._infoUpdate = i;    
    notifyListeners();
  }



  final List<Bodegas> bodegas = []; 
  final List<DetalleSeuencia> detSecu = []; 
  final List<Productos> productos = []; 

  Future<String> asyncTablas() async{     
     
            
      try {      
        infoUpdate = 'Iniciando sincronización';//Se verifica información offline
            
        infoUpdate = 'Iniciando sincronización....... \n\n\n Descargando información de productos de la base de datos, asegurese de que su conexión a internet sea estable. \n\nPuede tardar varios minutos';           
       final products = await availableInventoryProductosupdate();
        await Future.delayed(Duration(seconds: 1));
        await DBProvider.db.deleteProductos();
        DBProvider.db.deleteInventory();
         DBProvider.db.deleteSequence();  
         DBProvider.db.deleteProductos();
        DBProvider.db.deleteAllInventoryClose();      
        DBProvider.db.deleteCerradasOffline();      
        // final products = await DBProvider.db.getProductosLocal();
        List<Productos> detSecu1 = []; 
         var seen = Set<String>();
        List<Productos> uniquelist = detSecu1.where((bod) => seen.add(bod.productoCodigo.toString())).toList(); 
        String total2 = uniquelist.length.toString();
        //Vamos a construir querys de 100 registros
        int tot = int.parse(total2);
        String values = '';
        int cursor = 0;
        for (var i = 0; i < products.length; i++) {
            String productoCodigo = products[i].productoCodigo.toString();

            if(cursor <= 100){
              values = values + '''('$productoCodigo')''';
              if(cursor < 100-1 && i < products.length-1 ){
                values = values + ',';
              }
              if(i == products.length-1){
                await DBProvider.db.insertProductsRow(values);
              }
              cursor++;
            }            
            if(cursor == 100){
              //Debe almacenar la info
              // print(values);
              await DBProvider.db.insertProductsRow(values);
              values = '';
              cursor = 0;
              if(i % 100 == 0){
                 double porc = (100/products.length)*i;
               int shpor = porc.toInt();
               infoUpdate = shpor.toString() + '% Sincronizado'; 
              }
             
            }    
            if(products.length <= 100){               
                await DBProvider.db.insertProductsRow('''('$productoCodigo')''');
            }                  
           
           
        }
        
       
         String total =products.length.toString();
       
              
        await Future.delayed(Duration(seconds: 1));        
        infoUpdate = 'Finalizando Sincronización '  + total + ' productos fueron sincronizados.' ; 
        await Future.delayed(Duration(seconds: 1));
        // infoScreen = infoTemp + infoUbicaciones;
        infoScreen = total + ' productos fueron sincronizados.' ; 
        infoUpdate = infoScreen + '\n\nFinalizando Sincronización ' + total2 + ' productos fueron sincronizados.' ;  
        status = true;
        notifyListeners();
      } catch (e) {
      }
     var tempDir = await getTemporaryDirectory();
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
      // var appDocDir = await getApplicationDocumentsDirectory();
      // if (appDocDir.existsSync()) {
      //   appDocDir.deleteSync(recursive: true);
      // }

      
    return '1';
  }

   Future <List<Productos>> availableInventoryProductosupdate() async{
      this.productos.clear();
     
        try {
       String idInstalacion =  await storage.read(key: 'instalacionId') ?? '0';
        this.detSecu.clear();
         final String urlAPI = await DBProvider.db.GetApiUrl('getProductos'); 
        var request = http.Request('GET', Uri.parse(urlAPI+'$idInstalacion'));
        http.StreamedResponse response = await request.send();   

         if (response.statusCode == 200) {
          final resp = await response.stream.bytesToString(); 
          final respuesta = jsonDecode(resp);
          final resp2 = respuesta['table'];   

          print('Total datos productos= ' + resp2.length.toString());
           this.detSecu.clear();
            for (var i = 0; i < resp2.length; i++) {                   
            final temp = Productos.fromMap(resp2[i]);  
            this.productos.add(temp);        
          } 
          }
          else {
            EasyLoading.showError('API NOT FOUND');
            detSecu.clear(); 
          }  
          List<Productos> detSecu1 = []; 
         var seen = Set<String>();
          List<Productos> uniquelist = productos.where((bod) => seen.add(bod.productoCodigo.toString())).toList(); 
           
          return uniquelist.toList();

        } catch (e) {
        }
     
      return this.productos.toList();   
  }

    List<Respuesta> rex = [];
  



   



}