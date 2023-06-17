// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/providers.dart';
// import 'camscan.dart';

// class CameraCaptureBarcoderScreen extends StatelessWidget {
//   final String idBodega;
//   const CameraCaptureBarcoderScreen({ Key? key, required this.idBodega }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//      final capProvider = Provider.of<CapUIProvider>(context);
//      return Scaffold(
//         appBar: AppBar(     
          
//           elevation: 0,  
//           title: Text('Cam barcode reader',  style: const TextStyle(fontWeight: FontWeight.bold),),   
//         //  leading: GestureDetector(
//         //       onTap: () { 
//         //        // Navigator.pushReplacementNamed(context, 'pushRecord');
//         //         Navigator.of(context).pushNamedAndRemoveUntil('pushRecord', (Route<dynamic> route) => false);
//         //       },
//         //       child: Icon(
//         //         Icons.arrow_back_rounded,  // add custom icons also
//         //       ),
//         //     ),
          
//           ),     
//           body:  Column(
//             children: [
//               Expanded(
//                 flex: 4,
//                 child:Container(
//                   child: MyScannerScreen(idUbicacion:idBodega ,),
//                 )
//               ),
              
//                Expanded(
//                  flex: 2,
//                  child: Container(       
//                    color: Colors.white,                 
//                   child: Row(          
//                      mainAxisAlignment: MainAxisAlignment.spaceEvenly ,
//                      children: <Widget>[          
//                       FloatingActionButton(
//                          heroTag: "btn1",
//                         elevation: 0,
//                         child: Icon(Icons.remove_circle, size:50, color: Colors.red,),
//                         onPressed: ()async{                      
//                           capProvider.modoCaptura = 'Disminución';                      
//                         }   ,
//                         hoverColor: Colors.black87,
//                         backgroundColor: Colors.white10,
//                         ),
                         
                       
                        
                         
//                          FloatingActionButton(
//                            heroTag: "btn2",
//                         elevation: 0,
//                         child: Icon(Icons.add_circle, size:50, color: Colors.green,),
//                         onPressed: ()async{                    
//                            capProvider.modoCaptura = 'Aumento';
//                         }   ,
//                         hoverColor: Colors.black87,
//                         backgroundColor: Colors.white10,
//                         ),
//                      ],
                         
//                   ),
//                              ),
//                ),
//                Expanded(                 
//                 flex: 2,
//                 child: Description('Cantidad:  '+ capProvider.opcionLabel.toString() + '\n\n\nAction: '+capProvider.modoCaptura ),
                 
//                ),

              
               
//             ]),
//           // bottomNavigationBar: CustomNavigationBar()
//         ); 
//   }



// }

// class Description extends StatelessWidget {
//   final String data;

//   const Description(this.data);

//   @override
//   Widget build(BuildContext context) {

//     return Container(
//       width: double.infinity,
//       color: Colors.white,  
//       margin: EdgeInsets.symmetric(vertical: 10),
//       child: Text(this.data, style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
//     );
//   }
// }

