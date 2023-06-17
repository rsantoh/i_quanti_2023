// ignore_for_file: iterable_contains_unrelated_type, empty_catches, prefer_collection_literals, prefer_const_constructors, avoid_print, unused_local_variable, unnecessary_this, file_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:i_quanti_2023/services/dbLocal/localdb_service.dart';


import '../../models/models.dart';


class DetailsSecuenceService extends ChangeNotifier{


  int idubicacion = 0;  
  final storage = const FlutterSecureStorage();
  
  final List<DetalleSeuencia> detSecu = []; 

   Future <List<DetalleSeuencia>> availableDatailInventoryGet() async{
     print(idubicacion);
     
    
       detSecu.clear();
      // String _id = await storage.read(key: 'usuarioID') ?? '';      

       String _connMode = await storage.read(key: 'iConection') ?? '';
      if(_connMode == '0'){
        // DBProvider.db.deleteInventory();
         final  secuencia2 = await DBProvider.db.getAllDetailsSecuencia(idubicacion);
          for (var i = 0; i < secuencia2.length; i++) {
            detSecu.add(secuencia2[i]);
          }
          print('Total datos Secuencia offline = ' + detSecu.length.toString());
          
         

      }
      else if(_connMode == '1'){
         final String urlAPI = await DBProvider.db.GetApiUrl('DetalleSecuenciaRegistro');           
        print(urlAPI);
        print(urlAPI);
        var request = http.Request('GET', Uri.parse(urlAPI+idubicacion.toString()));

        http.StreamedResponse response = await request.send();
         if (response.statusCode == 200) {
          final resp = await response.stream.bytesToString(); 
          final respuesta = jsonDecode(resp);
          final resp2 = respuesta['table'];     
          print('Total datos Secuencia= ' + resp2.length.toString());
           detSecu.clear();
            for (var i = 0; i < resp2.length; i++) { 
                  
            final temp = DetalleSeuencia.fromMap(resp2[i]);  
            detSecu.add(temp);        
          } 
          }
          else {
            EasyLoading.showError('API NOT FOUND');
            detSecu.clear(); 
          } 
      }
      ChangeNotifier();
      return detSecu.toList();

  }       



   Future <List<DetalleSeuencia>> consolidacionInventario() async{
     //print(idubicacion);    
     try {
        detSecu.clear();
      // String _id = await storage.read(key: 'usuarioID') ?? '';      

       String _connMode = await storage.read(key: 'iConection') ?? '';
      if(_connMode == '0'){
        // DBProvider.db.deleteInventory();
         final  secuencia2 = await DBProvider.db.getAllDetailsSecuencia(idubicacion);         
          for (var i = 0; i < secuencia2.length; i++) {                      
             detSecu.add(secuencia2[i]); 
             
          }   
          var seen = Set<String>();
          List<DetalleSeuencia> uniquelist = detSecu.where((bod) => seen.add(bod.productoCodigo.toString())).toList();          
          for (var i = 0; i < uniquelist.length; i++) {
            uniquelist[i].cantidad = 0;
          }
          for (var i = 0; i < uniquelist.length; i++) {
           
            for (var a = 0; a < detSecu.length; a++) {               
              if(detSecu[a].productoCodigo == uniquelist[i].productoCodigo)
              {   
                double valorSuma = uniquelist[i].cantidad!;
                valorSuma ++;
                uniquelist[i].cantidad = valorSuma;
              }
              else{
               // print('Diferente');
              }
            }
          }
          detSecu.clear();
           for (var i = 0; i < uniquelist.length; i++) {
            detSecu.add(uniquelist[i]);
          }        
        
      }
      else if(_connMode == '1'){
        final String urlAPI = await DBProvider.db.GetApiUrl('DetalleByUbicacionId');  
        var request = http.Request('GET', Uri.parse(urlAPI+idubicacion.toString()));

        http.StreamedResponse response = await request.send();
         if (response.statusCode == 200) {
          final resp = await response.stream.bytesToString(); 
          final respuesta = jsonDecode(resp);
          final resp2 = respuesta['table'];     
          //print('Total datos Secuencia= ' + resp2.length.toString());
           detSecu.clear();
            for (var i = 0; i < resp2.length; i++) { 
                  
            final temp = DetalleSeuencia.fromMap(resp2[i]);  
            detSecu.add(temp);        
          } 
          }
          else {
            EasyLoading.showError('API NOT FOUND');
            detSecu.clear(); 
          } 
      }

       
     } catch (e) {
     }
    
      
      ChangeNotifier();
      return detSecu.toList();

  } 
   List<Respuesta> rex = [];
  Future<String> eliminarRegistro(int idUbicacion, int registroId, String hr) async {
    //Si es offline se debe eliminar el registro, adicionar identificador de fecha
    String respo = '';
     rex.clear();
    try {
        String _connMode = await storage.read(key: 'iConection') ?? '';
        String _id = await storage.read(key: 'usuarioID') ?? ''; 
        int usrId = int.parse(_id);
      if(_connMode == '0'){
        //base de datos local
       final  secuencia2 =  await DBProvider.db.eliminaIndividualSecuenciaOffline(registroId,idUbicacion,hr,'OF');   
      }
      else
      {
        final String urlAPI = await DBProvider.db.GetApiUrl('EliminarRegistroSecuencia');  

         var headers = {
            'Content-Type': 'application/json'
          };
          var request = http.Request('POST', Uri.parse(urlAPI));
          request.body = json.encode({
            "ubicacionId": idUbicacion,
            "usuarioId": usrId,
            "RegistroId": registroId,
            "registroDetalleId": 0
          });
          request.headers.addAll(headers);
          http.StreamedResponse response = await request.send();

          if (response.statusCode == 200) {

            final resp = await response.stream.bytesToString();        
            final respuesta = jsonDecode(resp);
            final resp2 = respuesta['table'];  
            for (var i = 0; i < resp2.length; i++) { 
                    
              final temp = Respuesta.fromMap(resp2[i]);  
              this.rex.add(temp);        
            } 
            String resp1 = rex[0].resultado.toString();           
            if(resp1 == ""){
              // final  secuencia2 = await DBProvider.db.eliminaIndividualSecuenciaOnlineLocal(registroId,idUbicacion,hr);
            }
            else
            {
              respo =  rex[0].resultado.toString();
            }            
          }
          else{
            EasyLoading.showError('API NOT FOUND');
            respo = 'Error... 404 NOT FOUND';
          }  


      }
      
    } catch (e) {
    }

    return respo;
  }

  Future<String> eliminarTodo(List<DetalleSeuencia> detSecu) async {
    print(detSecu.length);
    String respo = '';
    for (var i = 0; i < detSecu.length; i++) {
     String send = await eliminarRegistro(detSecu[i].ubicacionId!, detSecu[i].txRegistroId!, detSecu[i].fecha!);
     if(send != ''){
       respo = send;
       break;
     }     
    }   
    notifyListeners();    
    return respo;
  }


  Future<String> eliminarRegistrosIndividual(int idUbicacion, int registroId, String hr) async {
    //Si es offline se debe eliminar el registro, adicionar identificador de fecha
    String respo = '';
     rex.clear();
    try {
        String _connMode = await storage.read(key: 'iConection') ?? '';
        String _id = await storage.read(key: 'usuarioID') ?? ''; 
        int usrId = int.parse(_id);
      if(_connMode == '0'){
        final  secuencia2 = await DBProvider.db.eliminaIndividualSecuenciaOffline(registroId,idUbicacion,hr,'OF');  
      }
      else
      {
         final String urlAPI = await DBProvider.db.GetApiUrl('EliminarRegistroSecuencia');
          var headers = {
            'Content-Type': 'application/json'
          };
          var request = http.Request('POST', Uri.parse(urlAPI));
         request.body = json.encode({
            "ubicacionId": idUbicacion,
            "usuarioId": usrId,
            "RegistroId": registroId,
            "registroDetalleId": 0
          });
          request.headers.addAll(headers);

          http.StreamedResponse response = await request.send();

          if (response.statusCode == 200) {

            final resp = await response.stream.bytesToString();        
            final respuesta = jsonDecode(resp);
            final resp2 = respuesta['table'];  
            for (var i = 0; i < resp2.length; i++) { 
                    
              final temp = Respuesta.fromMap(resp2[i]);  
              this.rex.add(temp);        
            } 
            String resp1 = rex[0].resultado.toString();           
            if(resp1 == ""){
               //final  secuencia2 = await DBProvider.db.eliminaIndividualSecuenciaOnlineLocal(registroId,idUbicacion,hr );
            }
            else
            {
              respo =  rex[0].resultado.toString();
            }            
          }
          else{
            respo = 'Error... 404 NOT FOUND';
            EasyLoading.showError('API NOT FOUND');
          }   
        
      }
      
    } catch (e) {
    }
    notifyListeners();

    return respo;
  }





}


