// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, avoid_print, use_key_in_widget_constructors, unnecessary_this, prefer_const_literals_to_create_immutables


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:i_quanti_2023/providers/providers.dart';
import 'package:provider/provider.dart';

import '../../ui/input_decorations.dart';



class CaptureRePage extends StatelessWidget {
   final String internet;
  final String idUsuario;
  CaptureRePage({Key? key, required this.internet, required this.idUsuario}) : super(key: key);

  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {

// ignore: todo
//TODO: construir post
    final uiProvider = Provider.of<UiReProvider>(context, listen: false);
    final capProvider = Provider.of<CapUIProvider>(context);

    capProvider.totalConsolidado(uiProvider.ubicacionId.toString());//llamarlo antes de que se dibuje el widget
    final idUbicacion = uiProvider.bodegaBusq.toString();
   
    print('el id del usuario es $idUsuario y la conexión a internet es $internet');

    return  SingleChildScrollView(
      
      child: Column(
          children: [
            Description('Ubicación: ' + uiProvider.bodegaBusq),
            // Description('Instalación Id: '+uiProvider.ubicacionId.toString() + ' - Ubicación: ' + uiProvider.bodegaBusq),
            Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Container(               

                padding: EdgeInsets.all(3),
                child:  TextFormField(
                //

                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18
                ),

                autocorrect: false,
                keyboardType: TextInputType.number,//para poner teclado con @
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Confirmar ubicación',
                  labelText: 'Confirmar ubicación',
                  prefixIcon: Icons.security,

                ),//Consumimos el imput
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (val) {
                  uiProvider.codigoTextCapt = val;
                },
                //Asignar valores a los providers
               // onChanged: (value) => uiProvider.codigoTextCapt = value,
                validator: (value) {
                  print('Validator');
                  if(idUbicacion == value){
                    capProvider.ubicacionId = uiProvider.ubicacionId;
                    capProvider.verificaUbicacion = true;
                      return null;
                  }
                  else
                  {
                    capProvider.verificaUbicacion = false;
                      return  'La ubicación no coincide';
                  }


                },

              ),
              ),


            ),

            CodigoQRLeidoValue(idUsuario: idUsuario, internet: internet,),

             Description2(capProvider.totalBodega.toString()),

            

            Container(

              child: Row(

                 mainAxisAlignment: MainAxisAlignment.spaceEvenly ,
                 children: <Widget>[

                  FloatingActionButton(
                     heroTag: "btn1",
                    elevation: 0,
                    child: Icon(Icons.remove_circle, size:50, color: Colors.red,),
                    onPressed: ()async{
                       if(capProvider.verificaUbicacion == false){
                           EasyLoading.showInfo('Debe confirmar la ubicacion');
                        }
                      capProvider.modoCaptura = 'Disminución';


                      print(uiProvider.ubicacionId);
                    }   ,
                    hoverColor: Colors.black87,
                    backgroundColor: Colors.white10,
                    ),

                     FloatingActionButton(
                       heroTag: "btn2",
                    elevation: 0,
                    child: Icon(Icons.add_circle, size:50, color: Colors.green,),
                    onPressed: ()async{
                     if(capProvider.verificaUbicacion == false){
                        EasyLoading.showInfo('Debe confirmar la ubicacion');
                      }
                       capProvider.modoCaptura = 'Aumento';


                    }   ,
                    hoverColor: Colors.black87,
                    backgroundColor: Colors.white10,
                    ),

                     FloatingActionButton(
                        heroTag: "btn3",
                    elevation: 0,
                    child: Icon(Icons.inventory_2_sharp, size:50, color: Colors.blue,),
                    onPressed: ()async{
                       if(capProvider.verificaUbicacion == false){
                          alertNotMatchLoc(context);
                        }
                        else
                        {
                          showDialog(
                            context: context,
                              builder: (BuildContext context){
                                  return AlertDialog(
                                    title: Text('Cerrar Ubicación'),
                                    content: SingleChildScrollView(child: ListBody(children: [Text('¿Seguro de cerrar la ubicación?')],)),
                                    actions: [
                                      TextButton(onPressed: () async {

                                            final uiProvider = Provider.of<UiReProvider>(context, listen: false);
                                              uiProvider.selectedMenuOpt = 0;
                                              EasyLoading.show(status: 'Loading...');
                                              String cerrar = await capProvider.cerrarUbicacion(capProvider.ubicacionId,uiProvider.bodegaBusq);
                                              if(cerrar == ''){
                                                EasyLoading.showSuccess('Ubicación cerrada');
                                                Navigator.of(context).pop();
                                                Navigator.pushReplacementNamed(context, 'home');
                                              }
                                              else{
                                                EasyLoading.showError(cerrar.toString());
                                              }

                                    }, child: const Text('Continuar')),
                                      TextButton(onPressed: () {
                                      Navigator.of(context).pop();
                                    }, child: const Text('Cancelar')),
                                  ],
                                );
                              });

                        }

                    }   ,
                    hoverColor: Colors.black87,
                    backgroundColor: Colors.white10,
                    ),

                 ],

              ),
            ),
            Description('Action: '+capProvider.modoCaptura),
        //      Container(
        //        padding: EdgeInsets.only(right: 100, left: 100),
//TODO: Volver en acción de cámara
        //     child: Center(
        //       child: Container(
        //         child: ElevatedButton(
        //           style: ElevatedButton.styleFrom(
        //             minimumSize: Size.fromHeight(20),
        //             textStyle: TextStyle(fontSize: 10)
        //           ),
        //           child: Text('Ocultar teclado'),
        //           //onPressed: () => FocusScope.of(context).unfocus(),
        //           onPressed: () {                                   
                    
        //         //     if(capProvider.shoHideKey == 'O'){                    
        //         //       capProvider.shoHideKey = "M";
        //         //     }
        //         //     else{                    
        //         //       capProvider.shoHideKey = "O";                    
        //         //     }

        //         //     if(capProvider.shoHideKey=='O'){
        //         //       print('Cambia a ocultar');
        //         //       SystemChannels.textInput.invokeMethod('TextInput.hide'); 
        //         //       SystemChannels.textInput.invokeMethod('TextInput.hide');                                      

        //         //     }
        //         //     else{
        //         //       print('Cambia a mostrar');
        //         //     // focusNode.requestFocus();
        //         //     }
        //         //     SystemChannels.textInput.invokeMethod('TextInput.hide'); 
        //         //       SystemChannels.textInput.invokeMethod('TextInput.hide'); 
        //         //  // FocusScope.of(context).requestFocus(focusNode);
                 

        //         } 
        //       ),
        //     ),
        //   ),
        // ),
        
            //Description(''),

          ],
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
      margin: EdgeInsets.symmetric(vertical: 10),
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
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Text(this.data, style: TextStyle(fontSize: 45)),
    );
  }
}


class CodigoQRLeidoValue extends StatefulWidget {
  final String internet;
  final String idUsuario;

  CodigoQRLeidoValue({Key? key, required this.internet, required this.idUsuario}) : super(key: key);

  _MyCodigoQrLeido createState() => new _MyCodigoQrLeido();
}

class _MyCodigoQrLeido extends State<CodigoQRLeidoValue> {
  FocusNode focusNode = FocusNode();

  //late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    // Limpia el nodo focus cuando se haga dispose al formulario
    focusNode.dispose();        
    super.dispose();
  }

  final TextEditingController _textController = new TextEditingController();


  @override
  Widget build(BuildContext context) {
  //  final uiProvider = Provider.of<UiReProvider>(context, listen: false);
    final capProvider = Provider.of<CapUIProvider>(context, listen: false);
    
    
    bool enabl = true;
   // _textController.text = 'Hello Flutter'; //Set value
    return Column(
      children :[
          Container(
          padding: EdgeInsets.all(10),
            child:  TextFormField(
             enabled: enabl,
            autofocus: true,
            focusNode: focusNode,
          //  textInputAction: TextInputAction.done,
            //
              style: TextStyle(
                color: Colors.black,
                fontSize: 27
              ),              
              autocorrect: false,
              keyboardType: TextInputType.number,//para poner teclado con @
              controller: _textController,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'Código producto',
                labelText: 'Código producto',
                prefixIcon: Icons.qr_code_2_outlined
              ),    
                                    
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (value) async {
                print(value);
                EasyLoading.show(status: 'Loading...');
                if(value == ''){
                  EasyLoading.dismiss();
                  EasyLoading.dismiss();
                  EasyLoading.showError('NO DATA');
                }
                
                if(capProvider.verificaUbicacion == false){
                  _textController.clear();
                  EasyLoading.showInfo('Debe confirmar la ubicacion');
                }
                else{              
                  if(value.length > 0)
                  {
                    print(widget.idUsuario);
                    print(widget.internet);
                    //  
                      if(capProvider.modoCaptura == 'Aumento'){
                        print(value);
                         String enviar = await capProvider.sumaRestaInventario(capProvider.ubicacionId, value, 1, widget.internet, widget.idUsuario);
                          if(enviar == ''){
                                // EasyLoading.showSuccess('Almacenado');
                                EasyLoading.dismiss();
                              //  _textController.clear();
                         }
                         else{
                          EasyLoading.dismiss();
                         // _textController.clear();
                          showDialog(
                          context: context,
                            builder: (BuildContext context){
                                return AlertDialog(
                                  title: Text('ERROR'),
                                  content: SingleChildScrollView(child: ListBody(children: [Text(enviar +'\n\nValor leido: '+value )],)),
                                  actions: [                                     
                                    TextButton(onPressed: () {
                                    //_textController.clear();                                        
                                    Navigator.of(context).pop();
                                  }, child: const Text('Aceptar')),
                                ],
                              );
                            });
                         }
                           FocusScope.of(context).requestFocus(focusNode);  
                         _textController.clear(); 

                      }
                      else{

                        EasyLoading.show(status: 'Loading...');
                        String enviar = await capProvider.sumaRestaInventario(capProvider.ubicacionId, value, 0, widget.internet, widget.idUsuario);
                        if(enviar == ''){
                              EasyLoading.dismiss();
                           // _textController.clear();
                        }
                        else
                        {
                          EasyLoading.dismiss();
                          //  EasyLoading.showError(enviar.toString());
                            //_textController.clear();

                            showDialog(
                            context: context,
                              builder: (BuildContext context){
                                  return AlertDialog(
                                    title: Text('ERROR'),
                                    content: SingleChildScrollView(child: ListBody(children: [Text(enviar +'\n\nValor leido: '+value )],)),
                                    actions: [                                     
                                      TextButton(onPressed: () {
                                        //_textController.clear();
                                        //FocusScope.of(context).requestFocus(focusNode);
                                      Navigator.of(context).pop();
                                    }, child: const Text('Aceptar')),
                                  ],
                                );
                              });        
                        } 

                        FocusScope.of(context).requestFocus(focusNode);  
                        

                      }
                       EasyLoading.dismiss();
                        _textController.clear(); 
                    //   setState(() { enabl = true; });
                   // _textController.clear();

                  }
               
                }

              },
            
          ),
      
        ),

       

        
      ]
    );
  }
}

