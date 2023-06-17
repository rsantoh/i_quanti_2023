// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, avoid_print, use_key_in_widget_constructors, unnecessary_this, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:i_quanti_2023/providers/providers.dart';
import 'package:provider/provider.dart';

import '../../ui/input_decorations.dart';

class RegistrarProductoIndividual extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
       String codigoNuevo = '';
         final capProvider = Provider.of<CapUIProvider>(context);
// ignore: todo
//TODO: construir post
    return Scaffold(   
       appBar: AppBar( 
        title:Text('Registrar Producto Individual'), 
       ), body: SingleChildScrollView(
      child: Column(
          children: [
            Description('Registre el código de producto de forma individual en la base de datos del dispositivo.'),
             
          
            Form(              
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Container(
                padding: EdgeInsets.all(10),
                child:  TextFormField(  
                //                
                style: TextStyle(
                  color: Colors.black,
                   fontSize: 27
                ),
                autocorrect: false,
                keyboardType: TextInputType.text,//para poner teclado con @
                //controller: _controllerCodigo,
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Código producto',
                  labelText: 'Código producto',
                  prefixIcon: Icons.qr_code_2_outlined 
                ),//Consumimos el imput
                //Asignar valores a los providers
                //controller: _controllerCodigo,
                //onChanged: (value) => capProvider.codigoProducto = value,
                onChanged: (value){
                  
                 // capProvider.codigoProducto = value;
                  codigoNuevo = value;
                  
                } ,
                
               
              ),
              ),
            ),          
    
            //Description2(capProvider.opcionLabel.toString()),             
             Container(
               padding: EdgeInsets.only(right: 100, left: 100),

            child: Center(
              child: Container(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(25),
                    textStyle: TextStyle(fontSize: 15)
                  ),
                  child: Text('Guardar'),
                  //onPressed: () => FocusScope.of(context).unfocus(),
                  onPressed: () { 
                    if(codigoNuevo != ''){
                      capProvider.InsertaProductoCodigoInd(codigoNuevo);
                    }           
                    else{
                      EasyLoading.showError('Debe ingresar un código');
                    }                       
                  print(codigoNuevo);
                } 
              ),
            ),
          ),
        ),
             

              Container(
               padding: EdgeInsets.only(right: 100, left: 100),

            child: Center(
              child: Container(
                
                child: ElevatedButton(
                  
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(25),
                    textStyle: TextStyle(fontSize: 15),
                    
                  ),
                  child: Text('Ir a Registro'),
                  //onPressed: () => FocusScope.of(context).unfocus(),
                  onPressed: () {                                   
                  Navigator.pushReplacementNamed(context, 'home');
                } 
              ),
            ),
          ),
        ),
            //Description(''),
            // Description(capProvider.modoCaptura), 
          ],
        ),
    ),
    );
   
   
  }

  Future<dynamic> alertNotMatchLoc(BuildContext context) {
    return showDialog(
    context: context, 
      builder: (BuildContext context){
          return AlertDialog(
            title: Text('Error...'),
            content: SingleChildScrollView(child: ListBody(children: [Text('Verifique la ubicación ingresada coincida con el de la ubicación seleccionada')],)),
            actions: [
              TextButton(onPressed: () {
                print('salir');
                Navigator.of(context).pop();

              }, child: Text('Cerrar')),
            ],
        );
      });
  }
}

class Description extends StatelessWidget {
  final String data;

  const Description(this.data);

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.all(15),
      child: Text(this.data, style: TextStyle(fontSize: 20)),
    );
  }
}

class Description2 extends StatelessWidget {
  final String data;

  const Description2(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 25),
      child: Text(this.data, style: TextStyle(fontSize: 45)),
    );
  }
}


