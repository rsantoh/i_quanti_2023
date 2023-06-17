// ignore_for_file: prefer_const_constructors, avoid_single_cascade_in_expression_statements, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:i_quanti_2023/services/services.dart';
import 'package:provider/provider.dart';
import '../../models/detalleSecuencia.dart';


class DetailsRePage extends StatelessWidget {
  const DetailsRePage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
     
     final secProvider = Provider.of<DetailsSecuenceService>(context); 
     
     return  FutureBuilder(
         future: secProvider.availableDatailInventoryGet(),
        // initialData: [],
         builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot){
           if(!snapshot.hasData){
             return  Center(
               child: CircularProgressIndicator(
                      color: Colors.indigo,
                    ),
             );
           }   
           return ListView(
             children: _listaDetalleSecuencia(snapshot.data!, context),
           );

         } ,
      );    
     

     
  }
}

List<Widget> _listaDetalleSecuencia(List<dynamic> data, context){
     final List<Widget> opciones = [];
      List<DetalleSeuencia> temp = [];
      final secProvider = Provider.of<DetailsSecuenceService>(context); 

     if(data.isEmpty){

       final wifgetTemp = ListTile(
        title: Text('No se ha ingresado información en la ubicación seleccionada'),
        subtitle: Text('Puede ingresar información en la opción de captura'),
        leading: Icon(Icons.add_alert, color: Colors.blueGrey,),
        
       );
        opciones..add(wifgetTemp);
     }
     else{       
        for (var i = 0; i < data.length; i++) {
          if(!temp.contains(data[i])){         
            temp.add(data[i]);
          }  
        } 
         
        final wifgetTemp  =ListTile(
          title: Text(data.length.toString() + ' Registros encontrados', style: TextStyle( fontSize: 25, fontWeight: FontWeight. bold) ),
          trailing: Icon(Icons.delete_sweep_outlined, size: 40, color: Colors.red,),
          onTap: (){
            showDialog(
            context: context, 
              builder: (BuildContext context){
                  return AlertDialog(
                    title: const Text('Eliminar todos los registro'),
                    content: SingleChildScrollView(child: ListBody(children: [Text('¿Quiere eliminar todos los registros de la bodega?')],)),
                    actions: [
                      TextButton(onPressed: () {                            
                        Navigator.of(context).pop();
                      }, child: const Text('Cancelar')),
                        TextButton(onPressed: () async {
                          Navigator.of(context).pop();
                          EasyLoading.show(status: 'Loading...');
                          String eliminado = await secProvider.eliminarTodo(temp);
                          if(eliminado == '')
                          {
                            EasyLoading.showSuccess('Registros eliminados');                            
                          }
                          else{
                            EasyLoading.showError(eliminado);

                          }
                          
                        
                      },child: const Text('Eliminar')),
                    ],
                );
              });
            
          },

        );
         opciones..add(wifgetTemp);
        for (var i = 0; i < data.length; i++) {  
          
             final wifgetTemp = ListTile(
             title: Text('Código: '+ temp[i].productoCodigo.toString() +  '\n Hora: ' + temp[i].fecha.toString()),             
             subtitle: Text('CANTIDAD: ' + temp[i].cantidad.toString() + '\n' +temp[i].productoDescripcion.toString()),
              trailing: Icon(Icons.delete_forever_outlined, color: Colors.red,),
              onTap: ()async {
                //print(temp[i].txRegistroId.toString());
                showDialog(
                context: context, 
                  builder: (BuildContext context){
                      return AlertDialog(
                        title: Text('Eliminar registro'),
                        content: SingleChildScrollView(child: ListBody(children: [Text('¿seguro?')],)),
                        actions: [
                          TextButton(onPressed: () {
                            
                            Navigator.of(context).pop();

                          }, child: Text('Cancelar')),
                           TextButton(onPressed: () async { 
                              Navigator.of(context).pop();  
                             EasyLoading.show(status: 'Loading...');
                             String eliminado = await secProvider.eliminarRegistrosIndividual(temp[i].ubicacionId!, temp[i].txRegistroId!, temp[i].fecha!);

                            if(eliminado == '')
                            {
                               EasyLoading.showSuccess('Eliminado');                                

                            }
                            else{   
                              EasyLoading.showError(eliminado);
                            }
                            

                          },child: Text('Eliminar')),
                        ],
                    );
                  });

              },
             
             );
         
          opciones..add(wifgetTemp);
        }
        
     }
    
    return opciones;
}


