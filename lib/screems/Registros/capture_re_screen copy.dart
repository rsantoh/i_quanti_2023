// // ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, avoid_print, use_key_in_widget_constructors, unnecessary_this, prefer_const_literals_to_create_immutables

// import 'dart:ffi';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:i_quanti/providers/providers.dart';
// import 'package:provider/provider.dart';

// import '../../ui/input_decorations.dart';

// class CaptureRePage extends StatelessWidget {

//   final _textController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {

// // ignore: todo
// //TODO: construir post
//     final uiProvider = Provider.of<UiReProvider>(context);
//     final capProvider = Provider.of<CapUIProvider>(context);

//     capProvider.totalConsolidado(uiProvider.ubicacionId.toString());
//     final idUbicacion = uiProvider.bodegaBusq.toString();


//     return  SingleChildScrollView(
//       child: Column(
//           children: [
//             Description('Instalación Id: '+uiProvider.ubicacionId.toString() + ' - Ubicación: ' + uiProvider.bodegaBusq),
//             Form(
//               autovalidateMode: AutovalidateMode.onUserInteraction,
//               child: Container(

//                 padding: EdgeInsets.all(3),
//                 child:  TextFormField(
//                 //

//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 18
//                 ),

//                 autocorrect: false,
//                 keyboardType: TextInputType.text,//para poner teclado con @
//                 decoration: InputDecorations.authInputDecoration(
//                   hintText: 'Confirmar ubicación',
//                   labelText: 'Confirmar ubicación',
//                   prefixIcon: Icons.security,

//                 ),//Consumimos el imput
//                 //Asignar valores a los providers
//                 onChanged: (value) => uiProvider.codigoTextCapt = value,
//                 validator: (value) {

//                   if(idUbicacion == value){
//                     capProvider.ubicacionId = uiProvider.ubicacionId;
//                     capProvider.verificaUbicacion = true;
//                       return null;
//                   }
//                   else
//                   {
//                     capProvider.verificaUbicacion = false;
//                       return  'La ubicación no coincide';
//                   }


//                 },

//               ),
//               ),


//             ),

//             CodigoQRLeidoValue(),

//             Description2(capProvider.opcionLabel.toString()),

            

//             Container(

//               child: Row(

//                  mainAxisAlignment: MainAxisAlignment.spaceEvenly ,
//                  children: <Widget>[

//                   FloatingActionButton(
//                      heroTag: "btn1",
//                     elevation: 0,
//                     child: Icon(Icons.remove_circle, size:50, color: Colors.red,),
//                     onPressed: ()async{
//                        if(capProvider.verificaUbicacion == false){
//                            EasyLoading.showInfo('Debe confirmar la ubicacion');
//                         }
//                       capProvider.modoCaptura = 'Disminución';


//                       print(uiProvider.ubicacionId);
//                     }   ,
//                     hoverColor: Colors.black87,
//                     backgroundColor: Colors.white10,
//                     ),

//                      FloatingActionButton(
//                        heroTag: "btn2",
//                     elevation: 0,
//                     child: Icon(Icons.add_circle, size:50, color: Colors.green,),
//                     onPressed: ()async{
//                      if(capProvider.verificaUbicacion == false){
//                         EasyLoading.showInfo('Debe confirmar la ubicacion');
//                       }
//                        capProvider.modoCaptura = 'Aumento';


//                     }   ,
//                     hoverColor: Colors.black87,
//                     backgroundColor: Colors.white10,
//                     ),

//                      FloatingActionButton(
//                         heroTag: "btn3",
//                     elevation: 0,
//                     child: Icon(Icons.inventory_2_sharp, size:50, color: Colors.blue,),
//                     onPressed: ()async{
//                        if(capProvider.verificaUbicacion == false){
//                           alertNotMatchLoc(context);
//                         }
//                         else
//                         {
//                           showDialog(
//                             context: context,
//                               builder: (BuildContext context){
//                                   return AlertDialog(
//                                     title: Text('Cerrar Ubicación'),
//                                     content: SingleChildScrollView(child: ListBody(children: [Text('¿Seguro de cerrar la ubicación?')],)),
//                                     actions: [
//                                       TextButton(onPressed: () async {

//                                             final uiProvider = Provider.of<UiReProvider>(context, listen: false);
//                                               uiProvider.selectedMenuOpt = 0;
//                                               EasyLoading.show(status: 'Loading...');
//                                               String cerrar = await capProvider.cerrarUbicacion(capProvider.ubicacionId,uiProvider.bodegaBusq);
//                                               if(cerrar == ''){
//                                                 EasyLoading.showSuccess('Ubicación cerrada');
//                                                 Navigator.of(context).pop();
//                                                 Navigator.pushReplacementNamed(context, 'home');
//                                               }
//                                               else{
//                                                 EasyLoading.showError(cerrar.toString());
//                                               }

//                                     }, child: const Text('Continuar')),
//                                       TextButton(onPressed: () {
//                                       Navigator.of(context).pop();
//                                     }, child: const Text('Cancelar')),
//                                   ],
//                                 );
//                               });

//                         }

//                     }   ,
//                     hoverColor: Colors.black87,
//                     backgroundColor: Colors.white10,
//                     ),

//                  ],

//               ),
//             ),
//             Description('Action: '+capProvider.modoCaptura),
//              Container(
//             child: Center(
//               child: Container(
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     minimumSize: Size.fromHeight(20),
//                     textStyle: TextStyle(fontSize: 10)
//                   ),
//                   child: Text('Ocultar / mostrar teclado'),
//                   //onPressed: () => FocusScope.of(context).unfocus(),
//                   onPressed: () {                                   
                    
//                     if(capProvider.shoHideKey == 'O'){                    
//                       capProvider.shoHideKey = "M";
//                     }
//                     else{                    
//                       capProvider.shoHideKey = "O";                    
//                     }

//                     if(capProvider.shoHideKey=='O'){
//                       print('Cambia a ocultar');
//                       SystemChannels.textInput.invokeMethod('TextInput.hide'); 
//                       SystemChannels.textInput.invokeMethod('TextInput.hide');                                      

//                     }
//                     else{
//                       print('Cambia a mostrar');
//                     // focusNode.requestFocus();
//                     }
//                  // FocusScope.of(context).requestFocus(focusNode);
                 

//                 } 
//               ),
//             ),
//           ),
//         ),
        
//             //Description(''),

//           ],
//         ),
//     );
//   }

//   Future<dynamic> alertNotMatchLoc(BuildContext context) {
//     return showDialog(
//     context: context,
//       builder: (BuildContext context){
//           return AlertDialog(
//             title: Text('Error...'),
//             content: SingleChildScrollView(child: ListBody(children: [Text('Verifique la ubicación ingresada coincida con el de la ubicación seleccionada')],)),
//             actions: [
//               TextButton(onPressed: () {
//                 print('salir');
//                 Navigator.of(context).pop();

//               }, child: Text('Cerrar')),
//             ],
//         );
//       });
//   }
// }

// class Description extends StatelessWidget {
//   final String data;

//   const Description(this.data);

//   @override
//   Widget build(BuildContext context) {

//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 10),
//       child: Text(this.data, style: TextStyle(fontSize: 20)),
//     );
//   }
// }

// class Description2 extends StatelessWidget {
//   final String data;

//   const Description2(this.data);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 20),
//       child: Text(this.data, style: TextStyle(fontSize: 45)),
//     );
//   }
// }


// class CodigoQRLeidoValue extends StatefulWidget {

//   _MyCodigoQrLeido createState() => new _MyCodigoQrLeido();
// }

// class _MyCodigoQrLeido extends State<CodigoQRLeidoValue> {
//   FocusNode focusNode = FocusNode();

//   //late FocusNode myFocusNode;

//   @override
//   void initState() {
//     super.initState();
//     focusNode = FocusNode();
//   }

//   @override
//   void dispose() {
//     // Limpia el nodo focus cuando se haga dispose al formulario
//     focusNode.dispose();        
//     super.dispose();
//   }

//   final TextEditingController _textController = new TextEditingController();
//   // @override
//   // Void dispose(){
//   //   focusNode.dispose();

//   //   super.dispose();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     final uiProvider = Provider.of<UiReProvider>(context, listen: false);
//     final capProvider = Provider.of<CapUIProvider>(context, listen: false);
//    // _textController.text = 'Hello Flutter'; //Set value
//     return Column(
//       children :[

//           Container(
//           padding: EdgeInsets.all(10),
//             child:  TextFormField(
//              enabled: true,
//             autofocus: true,
//             focusNode: focusNode,
//           //  textInputAction: TextInputAction.done,
//             //
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 27
//               ),              
//               autocorrect: false,
//               keyboardType: TextInputType.url,//para poner teclado con @
//               controller: _textController,
//               decoration: InputDecorations.authInputDecoration(
//                 hintText: 'Código producto',
//                 labelText: 'Código producto',
//                 prefixIcon: Icons.qr_code_2_outlined
//               ),//Consumimos el imput
//               onTap: (){
//                 print(capProvider.shoHideKey);
//                 if(capProvider.shoHideKey == 'O'){
//                     SystemChannels.textInput.invokeMethod('TextInput.hide'); 
//                     SystemChannels.textInput.invokeMethod('TextInput.hide');
             
                                  
//                 }
//                 else
//                 {
//                   focusNode.requestFocus();
//                 }
//                  FocusScope.of(context).requestFocus(focusNode);
//               },
//               //Asignar valores a los providers
//             // controller: _textController,
//               //onChanged: (value) => capProvider.valorQRCaptura = value,
//               // onFieldSubmitted: (val) {

//               //    FocusScope.of(context).requestFocus(focusNode);
//               //     capProvider.codigoProducto = val;
//               //     capProvider.valorQRCaptura = val;
//               // },

//               onChanged: (value) async {
//                 if(capProvider.verificaUbicacion == false){
//                   _textController.clear();
//                   EasyLoading.showInfo('Debe confirmar la ubicacion');
//                 }
//                 else
//                 {
//                     if(capProvider.shoHideKey == 'O'){
//                       SystemChannels.textInput.invokeMethod('TextInput.hide'); 
//                       SystemChannels.textInput.invokeMethod('TextInput.hide');                     
                                
//                     }
//                     else
//                     {
//                       focusNode.requestFocus();
//                     }
//                   //Realiza acción de guardar la info
//                     if(value.length == 13){
//                       print('Se cumple la condición');
//                        String enviar = ''; 
//                       if(capProvider.modoCaptura == 'Aumento'){
//                             EasyLoading.show(status: 'Loading...');
//                             // String enviar = await capProvider.sumaRestaInventario(capProvider.ubicacionId, value, 1);
//                             if(enviar == ''){
//                                 // EasyLoading.showSuccess('Almacenado');
//                                 EasyLoading.dismiss();
//                                 _textController.clear();
//                             }
//                             else
//                             {
//                               EasyLoading.dismiss();
                              
//                              // EasyLoading.showError(enviar.toString());
//                               _textController.clear();
//                                showDialog(
//                               context: context,
//                                 builder: (BuildContext context){
//                                     return AlertDialog(
//                                       title: Text('ERROR'),
//                                       content: SingleChildScrollView(child: ListBody(children: [Text(enviar +'\n\nValor leido: '+value )],)),
//                                       actions: [                                     
//                                         TextButton(onPressed: () {
//                                         _textController.clear();                                        
//                                         Navigator.of(context).pop();
//                                       }, child: const Text('Aceptar')),
//                                     ],
//                                   );
//                                 });
        
//                             }
//                       }
//                       else
//                       {
//                         EasyLoading.show(status: 'Loading...');
//                         // String enviar = await capProvider.sumaRestaInventario(capProvider.ubicacionId, value, 0);
//                         if(enviar == ''){
//                               EasyLoading.dismiss();
//                             _textController.clear();


//                         }
//                         else
//                         {
//                           EasyLoading.dismiss();
//                           //  EasyLoading.showError(enviar.toString());
//                             _textController.clear();

//                             showDialog(
//                             context: context,
//                               builder: (BuildContext context){
//                                   return AlertDialog(
//                                     title: Text('ERROR'),
//                                     content: SingleChildScrollView(child: ListBody(children: [Text(enviar +'\n\nValor leido: '+value )],)),
//                                     actions: [                                     
//                                       TextButton(onPressed: () {
//                                         _textController.clear();
//                                         //FocusScope.of(context).requestFocus(focusNode);
//                                       Navigator.of(context).pop();
//                                     }, child: const Text('Aceptar')),
//                                   ],
//                                 );
//                               });        
//                         }        
//                       }
//                       print(value); 
//                     }
                   
      
//                 }
//                 FocusScope.of(context).requestFocus(focusNode);
//                 capProvider.codigoProducto = value;
//                 capProvider.valorQRCaptura = value;
//               } ,
//           ),
      
//         ),

//         // Container(
//         //   child: Center(
//         //     child: Container(
//         //       child: ElevatedButton(
//         //         style: ElevatedButton.styleFrom(
//         //           minimumSize: Size.fromHeight(20),
//         //           textStyle: TextStyle(fontSize: 10)
//         //         ),
//         //         child: Text('Ocultar / mostrar teclado'),
//         //         //onPressed: () => FocusScope.of(context).unfocus(),
//         //         onPressed: () {
                  
                 
                  
//         //           if(capProvider.shoHideKey == 'O'){                    
//         //             capProvider.shoHideKey = "M";
//         //           }
//         //           else{                    
//         //             capProvider.shoHideKey = "O";                    
//         //           }

//         //           if(capProvider.shoHideKey=='O'){
//         //             print('Cambia a ocultar');
//         //             SystemChannels.textInput.invokeMethod('TextInput.hide'); 
//         //             SystemChannels.textInput.invokeMethod('TextInput.hide'); 
                                      

//         //           }
//         //           else{
//         //             print('Cambia a mostrar');
//         //             focusNode.requestFocus();

//         //           }
//         //           FocusScope.of(context).requestFocus(focusNode);
                 

//         //         } 
//         //       ),
//         //     ),
//         //   ),
//         // )

        
//       ]
//     );
//   }
// }

