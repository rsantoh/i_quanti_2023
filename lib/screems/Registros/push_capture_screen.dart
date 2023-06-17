// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, unused_local_variable

import 'package:flutter/material.dart';
import 'package:i_quanti_2023/screems/Registros/records_screen.dart';
import 'package:i_quanti_2023/screems/widgets/Registros/float_action_rec_button.dart';
import 'package:i_quanti_2023/screems/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';


class PushCaptureScreen extends StatelessWidget {
  final String idUbicacion;
  final String internet;
  final String idUsuario;
  const PushCaptureScreen({ Key? key, required this.idUbicacion, required this.internet, required this.idUsuario }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UiReProvider>(context); 
    final String _idBodega = uiProvider.bodegaBusq.toString();  

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('CodigoUb: $_idBodega' , style: TextStyle(fontWeight: FontWeight.bold),),    
           actions: [
          Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(5),
            child: Center(
              child: Text(uiProvider.statusText,),
            )
          ),          
          // Switch.adaptive(
          //   value: uiProvider.status,             
          //   activeColor: Colors.green,
          //   inactiveTrackColor: Colors.red[100],
          //     onChanged: (value){                                  
          //         uiProvider.updateStatus(value);
          //     }            
          //   )        
        ],
        
        ),     
        body: _HomeRegBody(idUbicacion: idUbicacion, internet: internet, idUsuario: idUsuario,),
        bottomNavigationBar: CustomNavigationPushLocBar(),
        // floatingActionButton: ScanButton(idBodega: idUbicacion,)   ,
        // floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,    
    );    
  }
}


class _HomeRegBody extends StatelessWidget { 
  final String idUbicacion;
  final String internet;
  final String idUsuario;
  const _HomeRegBody({ Key? key, required this.idUbicacion, required this.internet, required this.idUsuario }) : super(key: key);
  @override
  @override
  Widget build(BuildContext context) {
    //get selectedmenu opt
    print(idUbicacion);
    print(idUsuario);
    final uiProvider = Provider.of<UiReProvider>(context);
    final cauiProvider = Provider.of<CapUIProvider>(context);
    //change to show the screem
    final currentIndex = cauiProvider.selectedMenuOpt2;
    final idBodega = uiProvider.bodegaBusq;
    switch(currentIndex){
       case 0:
        return CaptureRePage(idUsuario: idUsuario , internet: internet,);
      case 1:
        cauiProvider.ubAux = '';
        return ConsolidateReRePage();     
      case 2:
        cauiProvider.ubAux = '';
        return DetailsRePage();
      // case 3:
      //   return SyncUpUbicacionPage();     
      default: 
        return CaptureRePage(idUsuario: idUsuario , internet: internet,);
    }  
  }
}