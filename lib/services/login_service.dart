// ignore_for_file: unnecessary_new, prefer_const_constructors

import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:i_quanti_2023/models/models.dart';
import 'package:path_provider/path_provider.dart';

import '../models/bodegas.dart';
import 'dbLocal/localdb_service.dart';

class AuthService extends ChangeNotifier{

  final storage = new FlutterSecureStorage();
 
  bool isLoading = true; 
  
 
  final List<Instalaciones> instalaciones = []; 
  final List<Bodegas> bodegas = []; 

  Future<String?> singIn(String email, String password, String bodega) async {
    EasyLoading.show(status: 'Espere...');
  //   await DBProvider.db.deleteQuantiAPI();
  //   //GET INFO API
  //   int apiGet = await ApisURLInsert(email);
  //   if(apiGet == 0){
  //     EasyLoading.dismiss();
  //     EasyLoading.showError('Ha ocurrido un error');
  //     return '-0'; 
  //   }
  //   //GET ID BODEGA
  //   //  List<ApiQuanti> ruta = await DBProvider.db.GetApiUrl('getInstalacion');
  //  final  String urlAPI = await DBProvider.db.GetApiUrl('getInstalacion');
var requesta = http.Request('GET', Uri.parse('https://quanti.biz/PruebaPermoda/quantiservice/api/getInstalaciones'));


http.StreamedResponse responseaa = await requesta.send();

  
    String _id  = '0'; 
     String _idAlmacen  = '0'; 
    instalaciones.clear();
    // var request1 = http.Request('GET', Uri.parse(urlAPI));
    var request1 = http.Request('GET', Uri.parse('https://quanti.biz/PruebaPermoda/quantiservice/api/getInstalaciones'));
    http.StreamedResponse response2 =  await request1.send();
    if (response2.statusCode == 200) {
         final resp = await response2.stream.bytesToString(); 
         final respuesta = jsonDecode(resp);    
         final resp2 = respuesta['table'];  
          for (var i = 0; i < resp2.length; i++) {                   
            final temp = Instalaciones.fromMap(resp2[i]);  
            this.instalaciones.add(temp);        
          }   

    }
    else {
       EasyLoading.showError('API NOT FOUND');
        print(response2.reasonPhrase);
    }
    await Future.delayed(Duration(seconds: 1)); 
    //se busca el id de la bodega
    for (var i = 0; i < instalaciones.length; i++) {
      if(instalaciones[i].instalacionCodigo == bodega){
        _idAlmacen = instalaciones[i].instalacionId.toString();
      }
    }
    instalaciones.clear();
    if(_idAlmacen == '0'){
    EasyLoading.dismiss();
         return _idAlmacen;

    }
    var headers = {
      'Content-Type': 'application/json'
    };
    // final String urlAPIlO = await DBProvider.db.GetApiUrl('Login');
    // var request = http.Request('POST', Uri.parse(urlAPIlO));
    var request = http.Request('POST', Uri.parse('https://quanti.biz/PruebaPermoda/quantiservice/api/getUsuarioLoginAsync'));
    request.body = json.encode({
      "usuarioUser": email,
      "usuarioPassword": password,
      "instalacionId": _idAlmacen
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    
    if (response.statusCode == 200) {

       final resp = await response.stream.bytesToString(); 
       
       final respuesta = jsonDecode(resp);  
       storage.write(key: 'usuarioID', value: respuesta['usuarioId'].toString());
       storage.write(key: 'instalacionId', value: respuesta['instalacionId'].toString());
       storage.write(key: 'usuarioNombre', value: respuesta['usuarioNombre'].toString());
       storage.write(key: 'iConection', value: '1');
        _id = respuesta['usuarioId'].toString();
      //  final resp2 = await response.stream.bytesToString(); 
      //  final respuesta = jsonDecode(resp2);
      //   print(resp2[0].toString());

    }
    else {
      // ignore: avoid_print
       EasyLoading.showError('API NOT FOUND');
      print(response.reasonPhrase);
    }
    //Sincronizar bodegas con bd local
    // final bodegas = await aviableWarehouseListUpdate();
    // for (var i = 0; i < bodegas.length; i++) {
    //   await DBProvider.db.insertInfoInventory(bodegas[i]);      
    // }
    EasyLoading.dismiss();


      return _id;
  }

  // Future<String?> singIn(String email, String password, String bodega) async {
  //   EasyLoading.show(status: 'Espere...');
  //   await DBProvider.db.deleteQuantiAPI();
  //   //GET INFO API
  //   int apiGet = await ApisURLInsert(email);
  //   if(apiGet == 0){
  //     EasyLoading.dismiss();
  //     EasyLoading.showError('Ha ocurrido un error');
  //     return '-0'; 
  //   }
  //   //GET ID BODEGA
  //   //  List<ApiQuanti> ruta = await DBProvider.db.GetApiUrl('getInstalacion');
  //  final  String urlAPI = await DBProvider.db.GetApiUrl('getInstalacion');
  //   String _id  = '0'; 
  //    String _idAlmacen  = '0'; 
  //   instalaciones.clear();
  //   var request1 = http.Request('GET', Uri.parse(urlAPI));
  //   http.StreamedResponse response2 = await request1.send();
  //   if (response2.statusCode == 200) {
  //        final resp = await response2.stream.bytesToString(); 
  //        final respuesta = jsonDecode(resp);    
  //        final resp2 = respuesta['table'];  
  //         for (var i = 0; i < resp2.length; i++) {                   
  //           final temp = Instalaciones.fromMap(resp2[i]);  
  //           this.instalaciones.add(temp);        
  //         }   

  //   }
  //   else {
  //      EasyLoading.showError('API NOT FOUND');
  //       print(response2.reasonPhrase);
  //   }
  //   await Future.delayed(Duration(seconds: 1)); 
  //   //se busca el id de la bodega
  //   for (var i = 0; i < instalaciones.length; i++) {
  //     if(instalaciones[i].instalacionCodigo == bodega){
  //       _idAlmacen = instalaciones[i].instalacionId.toString();
  //     }
  //   }
  //   instalaciones.clear();
  //   if(_idAlmacen == '0'){
  //   EasyLoading.dismiss();
  //        return _idAlmacen;

  //   }
  //   var headers = {
  //     'Content-Type': 'application/json'
  //   };
  //   final String urlAPIlO = await DBProvider.db.GetApiUrl('Login');
  //   var request = http.Request('POST', Uri.parse(urlAPIlO));
  //   request.body = json.encode({
  //     "usuarioUser": email,
  //     "usuarioPassword": password,
  //     "instalacionId": _idAlmacen
  //   });
  //   request.headers.addAll(headers);
  //   http.StreamedResponse response = await request.send();

    
  //   if (response.statusCode == 200) {

  //      final resp = await response.stream.bytesToString(); 
       
  //      final respuesta = jsonDecode(resp);  
  //      storage.write(key: 'usuarioID', value: respuesta['usuarioId'].toString());
  //      storage.write(key: 'instalacionId', value: respuesta['instalacionId'].toString());
  //      storage.write(key: 'usuarioNombre', value: respuesta['usuarioNombre'].toString());
  //      storage.write(key: 'iConection', value: '1');
  //       _id = respuesta['usuarioId'].toString();
  //     //  final resp2 = await response.stream.bytesToString(); 
  //     //  final respuesta = jsonDecode(resp2);
  //     //   print(resp2[0].toString());

  //   }
  //   else {
  //     // ignore: avoid_print
  //      EasyLoading.showError('API NOT FOUND');
  //     print(response.reasonPhrase);
  //   }
  //   //Sincronizar bodegas con bd local
  //   // final bodegas = await aviableWarehouseListUpdate();
  //   // for (var i = 0; i < bodegas.length; i++) {
  //   //   await DBProvider.db.insertInfoInventory(bodegas[i]);      
  //   // }
  //   EasyLoading.dismiss();


  //     return _id;
  // }

  Future logout() async {

    await storage.deleteAll();
    var tempDir = await getTemporaryDirectory();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }  
    return;
  }

  Future<String> readToken() async{
      return await storage.read(key: 'usuarioID') ?? '';
  }

   Future<String> readUserName() async{
      return await storage.read(key: 'usuarioNombre') ?? '';
  }

   Future <List<Bodegas>> aviableWarehouseListUpdate() async{
     await DBProvider.db.deleteInventory(); 
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
         EasyLoading.showError('API NOT FOUND');
        bodegas.clear(); 
      }    

     } catch (e) {
     }
    


      return this.bodegas.toList();   
  }
  final List<ApiQuanti> api = []; 
  Future<int> ApisURLInsert(String user)async{
    //0 = Ocurrio error
    int respApiLo = 0;
    try {
      
      api.clear();
      //ELIMINAR Y AGREGAR DATOS DE LA API
      var request = http.Request('GET', Uri.parse('https://quanti.biz/QuantiService/api/getClientesUrlsByUsuarioUser/'+ user));
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        final resp = await response.stream.bytesToString(); 
        final respuesta = jsonDecode(resp);
        final resp2 = respuesta['table'];  
        for (var i = 0; i < resp2.length; i++) {         
        final temp = ApiQuanti.fromMap(resp2[i]);  
        this.api.add(temp);        
        }  
        //Inserta API URL en la BASE DE DATOS LOCAL
        for (var i = 0; i < api.length; i++) {
          int saveLocal = await  DBProvider.db.insertApiQuanti(api[i].url_Api, api[i].nombreRuta);
          if(saveLocal == 0){
            
            return 0;
          }
          else{
            respApiLo = 1;
          }
        }
      }
      else {
        return 0;        
      }
    } catch (e) {
      return 0;  
    }
    return respApiLo;
  }

}


