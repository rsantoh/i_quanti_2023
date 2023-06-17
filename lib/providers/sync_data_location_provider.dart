// ignore_for_file: prefer_const_constructors, unnecessary_this, empty_catches, avoid_print, unnecessary_new, unused_local_variable

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:i_quanti_2023/models/bodegas.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../models/models.dart';
import '../services/dbLocal/localdb_service.dart';

class SyncDataLocationProvider extends ChangeNotifier
{
   final storage = new FlutterSecureStorage();

   SyncDataLocationProvider(){
      this.asyncDataLocal();    

   }


  bool status = false;

  String _infoUpdate = 'syncing data....';
  String infoScreen = 'Los datos han sido actualizados';

  bool statusUploadSync = false;


  Future<bool> asyncDataLocal() async{
       notifyListeners();
       //String a = await asyncTablasUbicacion();
      await Future.delayed(Duration(seconds: 1));      
      status = true;  
      notifyListeners();
    return true;
  }


   String get infoUpdate{
    return this._infoUpdate;
  }

  set infoUpdate(String i){
    this._infoUpdate = i;    
    notifyListeners();
  }
  String processStatus = '';



  final List<Bodegas> bodegas = []; 
  final List<DetalleSeuencia> detSecu = []; 
  

   Future <List<Bodegas>> aviableWarehouseListUpdate() async{
     String idBodega = '0';        
     try {       
          this.bodegas.clear();
      String _id = await storage.read(key: 'usuarioID') ?? '';  
      final String urlAPI = await DBProvider.db.GetApiUrl('getInventario');
      var request = http.Request('GET', Uri.parse(urlAPI+_id+'/'+idBodega.toString()+''));
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
      final resp = await response.stream.bytesToString(); 
      final respuesta = jsonDecode(resp);
      final resp2 = respuesta['table'];        
      print('Total datos online = ' + resp2.length.toString());
      bodegas.clear();      
      for (var i = 0; i < resp2.length; i++) {         
        final temp = Bodegas.fromMap(resp2[i]);  
        this.bodegas.add(temp);        
      } 
      }
      else {
        bodegas.clear(); 
      }    

     } catch (e) {
     }
    


      return this.bodegas.toList();   
  }


   Future <List<DetalleSeuencia>> availableInventoryDetailSeUpdate(int idUbicacion) async{
      this.detSecu.clear();

        try {
          final String urlAPI = await DBProvider.db.GetApiUrl('DetalleSecuenciaRegistro');

          var request = http.Request('GET', Uri.parse(urlAPI+idUbicacion.toString()));

        http.StreamedResponse response = await request.send();
         if (response.statusCode == 200) {
          final resp = await response.stream.bytesToString(); 
          final respuesta = jsonDecode(resp);
          final resp2 = respuesta['table'];     
          print('Total datos Secuencia= ' + resp2.length.toString());
           this.detSecu.clear();
            for (var i = 0; i < resp2.length; i++) { 
                  
            final temp = DetalleSeuencia.fromMap(resp2[i]);  
            this.detSecu.add(temp);        
          } 
          }
          else {
            detSecu.clear(); 
          }  

          
        } catch (e) {
        }

     
      return this.detSecu.toList();   
  }

    List<Respuesta> rex = [];
    Future<String> cerrarUbicacion(int idUbicacion) async {
    String respo = '';
    String _usr = await storage.read(key: 'usuarioID') ?? '';    
    int _idUsr = int.parse(_usr);
    //print(idUbicacion);

    try {
       var headers = {
        'Content-Type': 'application/json'
      };
      final String urlAPI = await DBProvider.db.GetApiUrl('cerrarubicacion');
      var request = http.Request('POST', Uri.parse(urlAPI));
      request.body = json.encode({
        "ubicacionId": idUbicacion,
        "usuarioId": _idUsr,
        "tipoRegistro": 0
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
          respo = rex[0].resultado.toString();
          if(respo == ""){
            
          }
          else{

          }    

      }
      else {
        //print(response.reasonPhrase);
        respo = 'Ha ocurrido un error';
      
      }
      
    } catch (e) {

    }         
    return respo;
  }




   Future<String> insertaInventarioUpload(int idUbicacion, String producCode, int operacion, double cantidad) async {
     String respo = '';
     try {
       
        String _usr = await storage.read(key: 'usuarioID') ?? '';    
        int _idUsr = int.parse(_usr);
        rex.clear();

          var headers = {
          'Content-Type': 'application/json'
        };
        final String urlAPI = await DBProvider.db.GetApiUrl('RegistrarInventario');
         var request = http.Request('POST', Uri.parse(urlAPI));
        request.body = json.encode({
          "ubicacionId": idUbicacion,
          "productoCodigo": producCode,
          "usuarioId": _idUsr,
          "cantidad": cantidad,
          "operacion": operacion,
          "tipoRegistro": 0
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
          respo = rex[0].resultado.toString();

         }
         else{
          respo = response.reasonPhrase.toString();

         }

     } catch (e) {

     }


     return respo;

  }



   Future <List<DetalleSeuencia>> offlineDataSave() async{
      List<Bodegas> ubicacionesOffline = []; 
       List<DetalleSeuencia> detSecu1 = []; 
     try {
       ubicacionesOffline = await DBProvider.db.deleteAllInventoryClose();
         if(ubicacionesOffline.isNotEmpty){
            for (var i = 0; i < ubicacionesOffline.length; i++) {
              print(ubicacionesOffline[i].ubicacionId);
              List<DetalleSeuencia> detSecu2 = []; 
               detSecu2 = await DBProvider.db.getAllDetailsSecuenciaLocal(ubicacionesOffline[i].ubicacionId);              
               for (var a = 0; a < detSecu2.length; a++) {
                 detSecu2[a].productoDescripcion = ubicacionesOffline[i].ubicacionCodigo;
                 detSecu1.add(detSecu2[a]);
               }
            }  
        }  
     } catch (e) {

     }
     var seen = Set<String>();
     List<DetalleSeuencia> uniquelist = detSecu1.where((bod) => seen.add(bod.productoDescripcion.toString())).toList(); 
      for (var i = 0; i < uniquelist.length; i++) {
        uniquelist[i].cantidad = 0;
      } 
      for (var i = 0; i < uniquelist.length; i++) {        
        for (var a = 0; a < detSecu1.length; a++) {               
          if(detSecu1[a].productoDescripcion == uniquelist[i].productoDescripcion)
          {   
            double valorSuma = uniquelist[i].cantidad!;
            valorSuma ++;
            uniquelist[i].cantidad = valorSuma;
          }
          else{
            
          }
        }
      }
      detSecu1.clear();
      for (var i = 0; i < uniquelist.length; i++) {
        detSecu1.add(uniquelist[i]);
      }      
     return detSecu1;
   }

  List<RespuestaSync> rexSync = [];
  String insertaBien = '1';


  Future <String> uploadDatosOffline()async{
    String mensajeError = '\n\n';
    int productosSyncCount = 0;
      infoUpdate = 'Iniciando...';
      await Future.delayed(Duration(seconds: 1));
      try {
        infoUpdate = 'Verificando datos de ubicaciones en el dispositivo';   
        await Future.delayed(Duration(seconds: 1)); 
        List<Bodegas> ubicacionesOffline = []; 
        List<RegistroInventario> regInv = [];
        regInv.clear();
        //Se consultan ubicaciones almacenadas de forma offline que esten cerradas
        ubicacionesOffline = await DBProvider.db.deleteAllInventoryClose();
        infoUpdate = ubicacionesOffline.length.toString() + ' Ubicaciones offline cerradas encontradas en el dispositivo'; 
        await Future.delayed(Duration(seconds: 1)); 
        if(ubicacionesOffline.isNotEmpty){
          for (var i = 0; i < ubicacionesOffline.length; i++) {
            List<DetalleSeuencia> detSecuoff = [];
              print(ubicacionesOffline[i].ubicacionId);
              //Buscar el nombre de la ubicacion
               List<Bodegas> nombreUbicaciones = []; 
               String nombreUb = '';
               nombreUbicaciones = await DBProvider.db.getUbicacionByIdUbicacion(ubicacionesOffline[i].ubicacionId);
               for (var i = 0; i < nombreUbicaciones.length; i++) {
                 nombreUb = nombreUbicaciones[i].inventarioConsecutivo.toString() + ' ' +  nombreUbicaciones[i].ubicacionCodigo.toString() + ' ' + nombreUbicaciones[i].tipoUbicacionDescripcion.toString();
               }
              List<DetalleSeuencia> detSecu2 = []; 
              detSecu2 = await DBProvider.db.getAllDetailsSecuenciaLocal(ubicacionesOffline[i].ubicacionId);              
              for (var a = 0; a < detSecu2.length; a++) {
                detSecu2[a].ubicacionId = ubicacionesOffline[i].ubicacionId;
                detSecuoff.add(detSecu2[a]);
              }
                var seen = Set<String>();
                List<DetalleSeuencia> uniquelist = [];
               uniquelist = detSecuoff.where((bod) => seen.add(bod.productoCodigo.toString())).toList(); 
                for (var i = 0; i < uniquelist.length; i++) {
                  uniquelist[i].cantidad = 0;
                } 
                infoUpdate = 'preparando información de la ubicación ' + nombreUb +' para sincronizar.';   
                await Future.delayed(Duration(seconds: 1));  

                for (var i = 0; i < uniquelist.length; i++) {        
                  for (var a = 0; a < detSecuoff.length; a++) {               
                    if(detSecuoff[a].productoCodigo == uniquelist[i].productoCodigo)
                    {   
                      double valorSuma = uniquelist[i].cantidad!;
                      valorSuma ++;
                      uniquelist[i].cantidad = valorSuma;
                    }
                    else{                      
                    }
                  }
                }

                detSecuoff.clear();
                  for (var i = 0; i < uniquelist.length; i++) {
                  detSecuoff.add(uniquelist[i]);
                } 

               if(detSecuoff.length>0){
                 
                 //llenar la data de todas las ubicaciones a cerrar para hacer un unico llamado
                  String _usr = await storage.read(key: 'usuarioID') ?? '';    
                   int _idUsr = int.parse(_usr);
                   //Vacear la tabla que va a ser llenada
                  for (var i = 0; i < detSecuoff.length; i++) {  
                    RegistroInventario reg = RegistroInventario(ubicacionI:detSecuoff[i].ubicacionId!, productoCodigo: detSecuoff[i].productoCodigo!, usuarioId: _idUsr,cantidad: detSecuoff[i].cantidad!, operacion: 1, tipoRegistro: 0  );
                    regInv.add(reg);                
                    
                  }
               }
          }
          
          print(regInv);
           if(regInv.length > 0){            
             final guardar = await insertaInventarioOfflineUploadV2(regInv);
               if(insertaBien == '1'){
                 EasyLoading.show(status: 'Finalizando...');
                 if(guardar.isNotEmpty){
                   for (var i = 0; i < guardar.length; i++) {                     
                     if(guardar[i].status == 1){
                       //guardado exitoso, elimina los productos de la base de datos local
                       await DBProvider.db.deleteUploadSequenceProductoUb(guardar[i].ubicacionId, guardar[i].productoCodigo.toString());
                       productosSyncCount++;
                     }
                     else if(guardar[i].status == 0){
                       //falla al guardar
                       mensajeError = mensajeError + '\n'+ 'El producto ' + guardar[i].productoCodigo.toString() +' de la ubicación ' + guardar[i].ubicacionId.toString() + ' No pudo ser sincronizado - ERROR: ' + guardar[i].errorDescripcion.toString();  
                        for (var a = 0; a < ubicacionesOffline.length; a++) {
                          if(ubicacionesOffline[a].ubicacionId == guardar[i].ubicacionId){                  
                              ubicacionesOffline[a].tipoUbicacionDescripcion = 'NO CIERRA';
                            }  
                        }
                     }
                   }  
                   //CIERRA UBICACIONES
                  for (var a = 0; a < ubicacionesOffline.length; a++) {
                    if(ubicacionesOffline[a].tipoUbicacionDescripcion == 'NO CIERRA'){
                      print('No Cierra');
                                                
                    } 
                    else
                    {
                      await DBProvider.db.deleteUbicacionCerradaOff(ubicacionesOffline[a].ubicacionId); 

                    }                       
                  }

                  EasyLoading.dismiss();



                 }else{
                   EasyLoading.dismiss();
                   status = true;
                   infoUpdate = 'Proceso finalizado. \n' + responseMesaje;
 
                   return '1';
                 }  
                 EasyLoading.dismiss();         
               }
               else{
                 status = true;
                 EasyLoading.showError(responseMesaje);
                 infoUpdate = 'No se pudo establecer conexión con el servidor \n\n' + responseMesaje +'\n\n Por favor, vuelva a intentarlo';
                return '1';
               }
           }
           else{
             infoUpdate = 'NO HAY INVENTARIO PENDIENTE DE SINCRONIZAR';
           }
        }
        else{
          infoUpdate = 'NO SE HAN ENCONTRADO UBICACIONES CERRADAS';
        }
      } catch (e) {
         status = true;
         infoUpdate = 'Proceso finalizado...\n'  + mensajeError + ' OCURRIO UN ERROR';
      }

      // DBProvider.db.deleteCerradasOffline(); 
      status = true;
      infoUpdate = 'Proceso finalizado...\n'  + mensajeError + '\n'+productosSyncCount.toString()+ ' SYNC - STATUS: ' + responseMesaje ;
    var tempDir = await getTemporaryDirectory();
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }    
    return '1';
  }
  String responseMesaje = '';
   Future<List<RespuestaSync>> insertaInventarioOfflineUploadV2( List<RegistroInventario> regInv ) async {
     //TODO: hacer un timeout request para la respuesta de la transmisión
     String respo = '-1';
     responseMesaje = '';
     try {       
        rexSync.clear();

        var headers = {
          'Content-Type': 'application/json'
        };
        final String urlAPI = await DBProvider.db.GetApiUrl('UbSync');
        var request = http.Request('POST', Uri.parse(urlAPI));
                
         request.body = json.encode(regInv);
         
         String cadenaSend = '[';
         for (var i = 0; i < regInv.length; i++) {
           int ubId = regInv[i].ubicacionI;
           String prodCod = regInv[i].productoCodigo;
           int user = regInv[i].usuarioId;
           double cant = regInv[i].cantidad;
           cadenaSend = cadenaSend +  '''{"ubicacionId":$ubId,"productoCodigo":"$prodCod","usuarioId":$user,"cantidad":$cant,"operacion":1,"tipoRegistro":0}''';
           if(i < regInv.length -1){
             cadenaSend = cadenaSend + ',';
           }           
         }
         cadenaSend = cadenaSend + ']';
         print(cadenaSend);
         request.headers.addAll(headers);   
         request.body = cadenaSend;
        //http.StreamedResponse response = await request.send(); 

         http.StreamedResponse response = await request.send().timeout(
           const Duration(seconds: 60)     
         );


        responseMesaje = response.statusCode.toString() + ' ' + response.reasonPhrase.toString();     
         if (response.statusCode == 200 || response.statusCode == 201) {
            insertaBien = '1';
          final resp = await response.stream.bytesToString();        
          final respuesta = jsonDecode(resp);
          final resp2 = respuesta['table'];
          for (var i = 0; i < resp2.length; i++) { 
                  
            final temp = RespuestaSync.fromMap(resp2[i]);  
            this.rexSync.add(temp);        
          }   
         }     
         else{
           responseMesaje = response.statusCode.toString() + ' ' + response.reasonPhrase.toString();
           insertaBien = 'Ha ocurrido un error en la sincronización ERROR: ' + response.statusCode.toString();   
         }  
         processStatus = 'Operación finalizada'; 
     } catch (e) {
       processStatus = 'Sincronización Fallida, Intentelo de Nuevo'; 
       responseMesaje = '\nEl tiempo de espera se ha agotado y no se ha logrado establecer la conexión con el servidor.... Por favor, intentelo de nuevo.\n\n\n';
     }
     return rexSync;
  }
}