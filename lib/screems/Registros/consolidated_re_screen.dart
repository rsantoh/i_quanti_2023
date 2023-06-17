// ignore_for_file: prefer_const_constructors, avoid_single_cascade_in_expression_statements, avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/models.dart';
import '../../services/homeModule1/detailsSecuenceService.dart';

class ConsolidateReRePage extends StatelessWidget {
  const ConsolidateReRePage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final secProvider = Provider.of<DetailsSecuenceService>(context); 
     
    return  FutureBuilder(
      future: secProvider.consolidacionInventario(),
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
     if(data.isEmpty){
       final wifgetTemp = ListTile(
        title: Text('No se ha ingresado información en la ubicación seleccionada'),
        subtitle: Text('Puede ingresar información en la opción de captura'),
        leading: Icon(Icons.add_alert, color: Colors.blueGrey,),      
        onTap: (){
         

        },
       );
        opciones..add(wifgetTemp);
     }
     else{
       print(data.length);
        opciones.add(Container(
          child: Text('Consolidado',  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20) ,),
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
             title: Text(temp[i].productoDescripcion.toString() ),             
             subtitle: Text('Cantidad: ' + temp[i].cantidad.toString() +'\nCOD: ' +  temp[i].productoCodigo.toString() ),
              // trailing: Icon(Icons.delete, color: Colors.red,),
              // onTap: ()async {
                

              // },
             
             );
         
          opciones..add(wifgetTemp);
        }
        
     }
    
    return opciones;
}

