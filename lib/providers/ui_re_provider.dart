// ignore_for_file: unnecessary_this, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/bodegas.dart';
import '../services/dbLocal/localdb_service.dart';
import '../services/services.dart';

class UiReProvider extends ChangeNotifier{


  UiReProvider(){
    this.readISt();
    readUser();
    
  }

  final storage = const FlutterSecureStorage();


  bool status = true;
  int _selectedMenuOpt = 0;  
  String _nombreUser = '';
  String bodegaBusq = '0';
  int ubicacionId = 0;
  String codigoTextCapt = '0';
  String estadoInternet = '0';

  int get selectedMenuOpt{
    return this._selectedMenuOpt;
  }

  set selectedMenuOpt(int i){
    this._selectedMenuOpt = i;
    
    if(i != 2){
     
    }
    notifyListeners();
  }

   String get nombreUser{
    return this._nombreUser;
  }

  set nombreUser(String i){
    this._nombreUser = i;  
    notifyListeners();
  }

  
  
  bool muestraSincronizar = false;



    
    String statusText = 'Online';     
    updateStatus(bool value)async{
      print(value);
           
        this.status = value;    
        notifyListeners();
      if(!value){    
        EasyLoading.show(status: 'Actualizando ubicaciones offline...');
        selectedMenuOpt = 0;
        statusText = 'Offline';       
        storage.write(key: 'iConection', value: '0');
        notifyListeners();
        aviableWarehouseListUpdate();
        final bodegas = await aviableWarehouseListUpdate();
        for (var i = 0; i < bodegas.length; i++) {
          await DBProvider.db.insertInfoInventory(bodegas[i]); 
          double total = ((i/ bodegas.length) * 100)*0.01; 
          int valor = total.toInt() * 1000;
          print(valor);
          EasyLoading.showProgress(total, status: 'Ubicaciones descargadas: '+ i.toString() );           
        }
        EasyLoading.dismiss();
         EasyLoading.showSuccess('Ubicaciones Actualizadas');
       
        statusText = 'Offline';
        notifyListeners();
        selectedMenuOpt = 0;
      }
      else{
        statusText = 'Online';
        storage.write(key: 'iConection', value: '1');
        //
      
      }    
      this.status = value;
     
      EasyLoading.dismiss();
   
     
      notifyListeners();
  }

  Future<String> readISt() async{
    String _internet = await storage.read(key: 'iConection') ?? '';
    print(_internet);
    if(_internet == '1'){
      status = true;    
      statusText = 'Online'; 
      
    }else{
      statusText = 'Offline';
      status = false;
    }
    estadoInternet = _internet;
    notifyListeners();
   return _internet;
  }

   Future<String> readUser() async{
     String _usern = await storage.read(key: 'usuarioNombre') ?? '';
     nombreUser = _usern;
     notifyListeners();
      return _usern;
  }

    writeLocation(int val)async{       
     storage.write(key: 'idUbicacion', value: '$val');
         
   }

  final List<Bodegas> bodegas = []; 
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
  
}






