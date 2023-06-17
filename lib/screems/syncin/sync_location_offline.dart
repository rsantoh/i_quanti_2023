// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../services/services.dart';


class SyncUpLocationOfflinePage extends StatelessWidget {
  const SyncUpLocationOfflinePage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {    
    final syncpro = Provider.of<SyncDataLocationProvider>(context); 
    syncpro.statusUploadSync = false;
    return  FutureBuilder(
      future: syncpro.offlineDataSave(),
       builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot){
           if(!snapshot.hasData){             
             return  Center(
               child: CircularProgressIndicator(
                      color: Colors.indigo,
                    ),
             );
           }        
        
           return ListView(
             children: _litaDetalleConsolidado(snapshot.data!, context),
           );

         } ,
    );


   
  }
}

List<Widget> _litaDetalleConsolidado(List<dynamic> data, context){
     final List<Widget> opciones = [];
      List<DetalleSeuencia> temp = [];
      final uiProvider = Provider.of<UiReProvider>(context); 
     if(data.isEmpty){
       final wifgetTemp = ListTile(
        title: Text('No tiene información en ubicaciones almacenadas de forma offline, cuando tenga datos almacenados de forma offline los podrá visualizar en está pantalla y sincronizar'),
        subtitle: Text('No hay información pendiente por sincronizar'),
        leading: Icon(Icons.add_alert, color: Colors.blueGrey,),      
        onTap: (){

         uiProvider.selectedMenuOpt = 0;

        },
       );
        opciones..add(wifgetTemp);
     }
     else{
       print(data.length);
        opciones.add(Container(
          padding: EdgeInsets.all(20),
          child: Center(
            child: MaterialButton(
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                disabledColor: Colors.grey,
                elevation: 0,
                color: Colors.blueAccent,
                 child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                // ignore: prefer_const_constructors
                child: Text(
                  'Sincronizar Ubicaciones',textAlign: TextAlign.center,
                  )
                ),
                onPressed: () {  

                 if(uiProvider.status){
                   
                   showDialog(
                    context: context, 
                    builder: (BuildContext context){
                        return AlertDialog(
                          title: Text('¿Seguro?'),
                          content: SingleChildScrollView(child: ListBody(children: [Text('Sincronizar datos, ¿está seguro?')],)),
                          actions: [
                            TextButton(onPressed: () {
                            
                              Navigator.of(context).pop();

                            }, child: Text('Cancelar')),

                            TextButton(onPressed: ()  {
                               final syncpro = Provider.of<SyncDataLocationProvider>(context, listen: false); 
                              syncpro.status = false;
                              syncpro.statusUploadSync = true;
                              if(syncpro.statusUploadSync){
                                syncpro.uploadDatosOffline();
                                // syncpro.asyncTablasUbicacion();
                                 Navigator.pushReplacementNamed(context, 'sync_location'); 

                              }
                            }, child: Text('Continuar')),
                          ],

                        );
                    }
                    );
                }
                else{                  
                  showDialog(
                  context: context, 
                    builder: (BuildContext context){
                        return AlertDialog(
                          title: const Text('Error'),
                          content: SingleChildScrollView(child: ListBody(children: [const Text('Estás offline')],)),
                          actions: [
                            TextButton(onPressed: () {
                              //print('salir');
                              Navigator.of(context).pop();

                            }, child: const Text('Cerrar')),
                          ],
                      );
                    });

                }

                }

            ),  
          ),         
        ));
        opciones.add(Container(
          child: Text('Ubicaciones encontradas',  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20) ,),
          height: 40,
          padding: EdgeInsets.all(8),
        ));

          for (var i = 0; i < data.length; i++) {
          if(!temp.contains(data[i])){         
            temp.add(data[i]);
          }  
        } 
        for (var i = 0; i < data.length; i++) {  

             final wifgetTemp = ListTile(
             title: Text('Sincronizar Ubicación ' + temp[i].productoDescripcion.toString() ),             
             subtitle: Text('Cantidad: ' + temp[i].cantidad.toString()),             
             
             );
         
          opciones..add(wifgetTemp);
        }
        
     }
    
    return opciones;
}
