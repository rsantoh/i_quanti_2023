import 'package:flutter/material.dart';
import 'package:i_quanti_2023/screems/camera/camera_qr_scan.dart';
import 'dart:developer';

import 'package:i_quanti_2023/screems/camera/qr_scan_cam.dart';

class ScanButton extends StatelessWidget {
  final String idBodega;
  const ScanButton({Key? key, required this.idBodega}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      focusColor: Colors.amber,
      child: Icon(Icons.camera_alt_rounded),
      onPressed: (){
        print(idBodega);
         Navigator.of(context).push(MaterialPageRoute<Null>(
          builder: (BuildContext context){
            // return CameraCaptureBarcoderScreen(idBodega: idBodega);
            return Container();
          } 
        ));
        // Future.delayed(Duration.zero, () {

        //   //  WidgetsBinding.instance?.addPostFrameCallback((_) {
        //   //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => CameraCaptureBarcoderScreen(idBodega:idBodega,)));
        //   // });

                   
        //   // Navigator.of(context).pushNamedAndRemoveUntil('capture_cam', (Route<dynamic> route) => false);
          
        // });
          // Future.delayed(Duration.zero, () {
          //    Navigator.of(context).push(MaterialPageRoute<Null>(
          //     builder: (BuildContext context){
          //       return QRViewCapture();
          //     } 
          //   ));
          // });

          // WidgetsBinding.instance?.addPostFrameCallback((_) {
          //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => QRViewCapture()));
          // });

          // Navigator.of(context).push(MaterialPageRoute<Null>(
          //   builder: (BuildContext context){
          //     return CameraCaptureBarcoderScreen(idBodega: idBodega );
          //   } 
          // ));


        }      
      );
  }
}

