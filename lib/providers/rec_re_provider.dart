// ignore_for_file: unused_local_variable, empty_catches, unnecessary_this

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../models/models.dart';
import '../services/dbLocal/localdb_service.dart';
import 'dart:convert';

class CapUIProvider extends ChangeNotifier{

  CapUIProvider(){

   // totalConsolidado();
  }


  int _invValue = 0;  
  int opcionLabel = 0;
   bool cargaTotal = false;

  int get invValue{
    return _invValue;
  }

  set invValue(int i){
    _invValue = i;
    
    if(i == 1){
     opcionLabel = opcionLabel -1;
    }
    else if(i == 2){
      opcionLabel = opcionLabel +1;

    }
    else{
      opcionLabel = 10;
    }
    notifyListeners();
  }

  bool verificaUbicacion = false;
  int ubicacionId = 0;
  String codigoProducto = '';

  int _selectedMenuOpt2 = 0;  
 
  int get selectedMenuOpt2{
    return this._selectedMenuOpt2;
  }

  set selectedMenuOpt2(int i){
    this._selectedMenuOpt2 = i;
    verificaUbicacion = false;
    codigoProducto = '';
    
    if(i != 2){
     
    }
    notifyListeners();
  }

  bool caputaActiva = false;

  String _totalBodega = '';

  String get totalBodega{
    return this._totalBodega;
  }

  set totalBodega(String i){
    this._totalBodega = i;   
    print(_totalBodega + ' Total bodehga' );
    notifyListeners();
  }
  final storage = const FlutterSecureStorage();

  String ubAux = "";
  Future totalConsolidado(String ubIdd) async{   
    
    if(ubIdd != ubAux){
      EasyLoading.show(status: '...');
      ubAux = ubIdd;
      print('Consume metodo de la bd');
       cargaTotal = false;     
    List<DetalleSeuencia> detSecu = []; 
     String idUbicacion = await storage.read(key: 'idUbicacion') ?? '';
     int ubId = int.parse(idUbicacion);
    double suma = 0;

     String _connMode = await storage.read(key: 'iConection') ?? '';
     if(_connMode == '0'){
       final  secuencia2 = await DBProvider.db.getAllDetailsSecuencia(ubId);
         for (var i = 0; i < secuencia2.length; i++) {                      
             detSecu.add(secuencia2[i]);  

          }
           for (var i = 0; i < detSecu.length; i++) {
              suma = suma + detSecu[i].cantidad!;
            }

     }
     else{
       try {     
         final String urlAPI = await DBProvider.db.GetApiUrl('DetalleByUbicacionId');    
         var request = http.Request('GET', Uri.parse(urlAPI+idUbicacion.toString()));

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
            for (var i = 0; i < detSecu.length; i++) {
              suma = suma + detSecu[i].cantidad!;
            }
          }
          else {
            detSecu.clear(); 
          } 


       } catch (e) {
       }
        
     }  
     EasyLoading.dismiss();
    int muestra = suma.toInt();
    cargaTotal = true;
    notifyListeners();
    opcionLabel = muestra; 
    totalBodega = muestra.toString();
    }
    else{
      print('No consume metodo de la bd');
    }

    
        
    return;
  }  

  

  Future<String> cerrarUbicacion(int idUbicacion, String codUb) async {
    String respo = '';
    String _usr = await storage.read(key: 'usuarioID') ?? '';    
    int _idUsr = int.parse(_usr);
     String idUb = await storage.read(key: 'idUbicacion') ?? '';
     int ubId = int.parse(idUb);
    //print(idUbicacion);
    try {

      String _connMode = await storage.read(key: 'iConection') ?? '';
     if(_connMode == '0'){
       //Cambiar Estado de la ubicación
       final cierra =  await DBProvider.db.cerrarUbicacionOffline(ubId,codUb);  
     }
     else
     {
         var headers = {
        'Content-Type': 'application/json'
          };
          final String urlAPI = await DBProvider.db.GetApiUrl('cerrarubicacion');
           var request = http.Request('POST', Uri.parse(urlAPI));
            request.body = json.encode({
              "ubicacionId": ubId,
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
              else
              {

              }  
          }
          else {
            //print(response.reasonPhrase);
            respo = response.reasonPhrase.toString();
          
          }
     }
    } catch (e) {

    }         
    return respo;
  }

  List<Respuesta> rex = [];

  Future<String> sumaRestaInventario(int idUbicacion, String producCode, int operacion, String internet, String idUsu) async {
    String respo = '';
    // String _usr = await storage.read(key: 'usuarioID') ?? '';    

    int _idUsr = int.parse(idUsu);
    String _connMode = internet; //await storage.read(key: 'iConection') ?? '';

    int optin2 = int.parse(totalBodega);
    final fec = DateTime.now().toUtc();
    final now = DateTime(fec.year,fec.month,fec.day,fec.hour, fec.minute, fec.second);
    // print(optin2);
    //print(now);

  try {

    if(_connMode == '0'){

      final verificaBDLocal = await DBProvider.db.getProductosLocal(producCode);
      if(verificaBDLocal.length>0){

         if(operacion == 0){
          
          final insert = await DBProvider.db.insertInfoInvUpdateSecuenciaUnique(optin2,producCode,'Sincronizar',idUbicacion,1,now.toString(),'OF' );
          if(insert == -1){
            EasyLoading.showError('Ocurrio un problema eliminando el registro, intentelo desde la vista de detalles');
          }else{
            optin2 = optin2 -1;
           totalBodega = optin2.toString();
          }
          
          //  String total = await totalConsolidado(idUbicacion.toString()); 
        }
        else
        {
         
          final  insert = await DBProvider.db.insertInfoInvDetalleSecuenciaUnique(optin2,producCode,'Sincronizar',idUbicacion,1,now.toString(),'OF' );
          if(insert == -1){
            EasyLoading.showError('Ocurrio un problema almacenando el registro');
          }else{
            optin2 = optin2 +1;
          totalBodega = optin2.toString();
          }
           
          //  String total = await totalConsolidado(idUbicacion.toString()); 
          
        }   
       

      } else{

        return 'El producto no se encuentra en la base de datos local \nPor favor sincronizar para actualizar la lista de productos que puede trabajar de forma offline';
      }

       //Base de datos local       
       
       //opcionLabel + 1;
     }
     else
     {
         rex.clear();
       try {
         var headers = {
          'Content-Type': 'application/json'
        };
        final String urlAPI = await DBProvider.db.GetApiUrl('RegistrarInventario');
        var request = http.Request('POST', Uri.parse(urlAPI));
        request.body = json.encode({
          "ubicacionId": idUbicacion,
          "productoCodigo": producCode,
          "usuarioId": _idUsr,
          "cantidad": 1,
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
          String resp1 = rex[0].resultado.toString();
          respo = resp1.toString();
          if(resp1 == ""){
            //guardar en base de datos local
             
            //final  insert = await DBProvider.db.insertInfoInvDetalleSecuenciaUnique(200,producCode,'Sincronice para ver',idUbicacion,1,'HH:MM','D' );
            if(operacion == 0){
             optin2 = optin2 -1;
              totalBodega = optin2.toString();
             // final  insert = await DBProvider.db.insertInfoInvUpdateSecuenciaUnique(optin2,producCode,'Sincronizar',idUbicacion,1,now.toString(),'ON' );
            }
            else
            {
              //final  insert = await DBProvider.db.insertInfoInvDetalleSecuenciaUnique(optin2,producCode,'Sincronizar',idUbicacion,1,now.toString(),'ON' );
             optin2 =  optin2 +1;
              totalBodega = optin2.toString();
            }
          }
          else{

          }     
        }
        else {
          EasyLoading.showError('Ha ocurrido un error');
          respo = 'Ha ocurrido un error';

        }
         
       
       } catch (e) {
         
       }
        
      
      
     }

    
  } catch (e) {
  }

        var appDir = (await getTemporaryDirectory()).path;
    new Directory(appDir).delete(recursive: true);
     
    return respo;
  }

  String _modoCaptura = 'Aumento';

   String get modoCaptura{
    return this._modoCaptura;
  }

  set modoCaptura(String i){
    this._modoCaptura = i;   
    notifyListeners();
  }


   String _valorQRCaptura = '0';

   String get valorQRCaptura{
    return this._valorQRCaptura;
  }

  set valorQRCaptura(String i){
    this._valorQRCaptura = i;   
    notifyListeners();
  }

  
   String _showHideKeyb = 'O';

   String get shoHideKey{
    return this._showHideKeyb;
  }

  set shoHideKey(String i){
    this._showHideKeyb = i;   
    notifyListeners();
  }


  Future<String> InsertaProductoCodigoInd(String producCode) async {
   try {
     EasyLoading.show(status: 'Guardando...');
     final verificaBDLocal = await DBProvider.db.getProductosLocal(producCode);
     if(verificaBDLocal.length>0){
       EasyLoading.showError('El producto ya se encuentra registrado');
     }
     else{
      String values =  '''('$producCode')''';
        final insert = await DBProvider.db.insertProductsRowNew(values);
        if(insert != '-1'){
          EasyLoading.dismiss();
          EasyLoading.showSuccess('Registro ingresado');
        }
        else{
          EasyLoading.dismiss();
          EasyLoading.showError('Ocurrio un error realizando el registro');
        }

     }
   } catch (e) {
   } 
    return '';
  }

  Future<String> readIdUser() async{
    String _idUser = await storage.read(key: 'usuarioID') ?? '';   
   return _idUser;
  }



 }




