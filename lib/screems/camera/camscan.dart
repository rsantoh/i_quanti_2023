// import 'package:fast_barcode_scanner/fast_barcode_scanner.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:i_quanti_2023/providers/rec_re_provider.dart';
// import 'package:provider/provider.dart';

// import 'package:audioplayers/audioplayers.dart';
// import 'package:audioplayers/src/audio_cache.dart';

// class MyScannerScreen extends StatelessWidget {
//   final String idUbicacion;

//   const MyScannerScreen({Key? key, required this.idUbicacion}) : super(key: key);
//     @override
//     Widget build(BuildContext context) {
//       final capProvider = Provider.of<CapUIProvider>(context, listen: false);
//       bool enabl = true;
//       int idUb = int.parse(idUbicacion);
//         return BarcodeCamera(
//                 types: const [
//                     BarcodeType.ean8,
//                     BarcodeType.ean13,
//                     BarcodeType.code128
//                 ],  
//                 resolution: Resolution.hd1080,
//                 framerate: Framerate.fps30,
//                 mode: DetectionMode.pauseDetection,  
//                onScan: (code)async{      
//                  EasyLoading.show(status: '...');
//                  String value = code.value; 
//                 // CameraController.instance.pauseDetector(); 
//                  await Future.delayed(Duration(seconds: 1)); 
//                  //print(value);              
//                  if(capProvider.modoCaptura == 'Aumento'){
//                   EasyLoading.show(status: 'Aumentando...');
//                   String enviar = '1';
//                   // String enviar = await capProvider.sumaRestaInventario(idUb, value, 1);
//                   if(enviar == ''){      
//                     final player = AudioCache();  
//                     player.play('Sound_beep.mp3');          
//                     EasyLoading.dismiss();  
//                     CameraController.instance.resumeDetector();                            
//                   }
//                   else{
//                   EasyLoading.dismiss();
//                   final player = AudioCache();  
//                     player.play('Sound_Error_2.mp3');   
//                   // _textController.clear();
//                   showDialog(
//                   context: context,
//                     builder: (BuildContext context){
//                         return AlertDialog(
//                           title: Text('ERROR'),
//                           content: SingleChildScrollView(child: ListBody(children: [Text(enviar +'\n\nValor leido: '+ value, )],)),
//                           actions: [                                     
//                             TextButton(onPressed: () {
//                             CameraController.instance.resumeDetector();                                      
//                             Navigator.of(context).pop();
//                           }, child: const Text('Aceptar')),
//                         ],
//                       );
//                     });
//                   }

//                  }
//                  else{
//                    EasyLoading.show(status: 'Disminuyendo...');
//                    EasyLoading.show(status: 'Loading...');
//                   // String enviar = await capProvider.sumaRestaInventario(idUb, value, 0);
//                   String enviar = '1';
//                   if(enviar == ''){
//                     final player = AudioCache();  
//                     player.play('Sound_beep.mp3');   
//                     EasyLoading.dismiss();
//                     CameraController.instance.resumeDetector();    
//                   }
//                   else
//                   {
//                    final player = AudioCache();  
//                     player.play('Sound_Error_2.mp3'); 
//                     EasyLoading.dismiss();

//                     showDialog(
//                     context: context,
//                     builder: (BuildContext context){
//                         return AlertDialog(
//                           title: Text('ERROR'),
//                           content: SingleChildScrollView(child: ListBody(children: [Text(enviar +'\n\nValor leido: '+value )],)),
//                           actions: [                                     
//                             TextButton(onPressed: () {
//                             CameraController.instance.resumeDetector();    
//                             Navigator.of(context).pop();
//                           }, child: const Text('Aceptar')),
//                         ],
//                       );
//                     });        
//                   } 


//                  }

                         
//                },
//                 children: [
//                     MaterialPreviewOverlay(animateDetection: true),
//                     BlurPreviewOverlay(),                  
//                 ],
//             );
//     }
// }