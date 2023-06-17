// ignore_for_file: prefer_const_constructors, avoid_single_cascade_in_expression_statements, unnecessary_this, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:i_quanti_2023/services/homeModule1/locationService.dart';
import 'package:provider/provider.dart';

import '../../models/bodegas.dart';
import '../../providers/rec_re_provider.dart';
import '../../providers/ui_re_provider.dart';
import '../../services/services.dart';
import '../screems.dart';

class LocationReRePage extends StatefulWidget {

   
  const LocationReRePage({ Key? key }) : super(key: key);

  @override
  State<LocationReRePage> createState() => _LocationReRePage();
}

class _LocationReRePage extends State<LocationReRePage> {

  List<Bodegas> temp = [];

  @override
  Widget build(BuildContext context) {
     final location = Provider.of<LocationService>(context);
      
     return FutureBuilder(
       future: location.aviableWarehouseList(),
       builder: (BuildContext context,  AsyncSnapshot<List<dynamic>> snapshot){
          if(!snapshot.hasData){
             return  Column(
               children: [
                 Center(
                    child: CircularProgressIndicator(
                      color: Colors.indigo,
                    ),
                    
                 ),
                 Container(
                   margin: EdgeInsets.symmetric(vertical: 25),
                   child: Text('Loading Data'),
                 )
               ],
             );
           }  
          
            return ListView(
             children: _list(snapshot.data!, context),
           );
       },       
      ); 
  }
  List<Widget> _list(List<dynamic> data, context){

    temp.clear();

      var _val = '';
    final location = Provider.of<LocationService>(context);
    final textController = TextEditingController();     
    final List<Widget> opciones = [];
    final wifgetTemp = Container(
      padding: EdgeInsets.only(right: 10, left: 10),
        width: MediaQuery.of(context).size.width*0.8,
        child: TextField(
          controller: textController,   
          keyboardType: TextInputType.text,  
           onChanged: (value)async{
             _val = value;  
            // print(value);
           }, 
           decoration: InputDecoration( 
             hintText: 'Ubicación',
              suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: ()async{  
                 await Future.delayed(Duration(milliseconds: 800));
                textController.clear();        
                location.querySe = _val;                
                setState(() {     
                  this.temp = temp;
                  location.aviableWarehouseList(); 
                });                              
              },
              ),
              )

        )
      );

    opciones..add(wifgetTemp);

    if(data.isEmpty){      
       final wifgetTemp = ListTile(
        title: Text('No data'),
        subtitle: Text('No information available'),
        leading: Icon(Icons.add_alert, color: Colors.blueGrey,),      
       );
        
        opciones..add(wifgetTemp);
     }
     else
     {
        opciones.add(Container(
          child: Text('Ubicaciones:  ' + data.length.toString() + ' Encontradas',  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20) ,),
          height: 40,
          padding: EdgeInsets.all(8),
        ));

           for (var i = 0; i < data.length; i++) {
            if(!temp.contains(data[i])){         
              temp.add(data[i]);
            }  
          } 
          
        for (var i = 0; i < data.length; i++) {  
          if(temp[i].estado == 'CERRADA'){

            final wifgetTemp = ListTile(

             leading: Icon(Icons.power_off_sharp, color: Colors.red,),
             title: Text(temp[i].inventarioConsecutivo.toString() + ' - Ubicacion: ' + temp[i].ubicacionCodigo.toString() + ' ' + temp[i].tipoUbicacionDescripcion.toString() + ' CERRADA OFFLINE', style: TextStyle(color: Colors.red) ),                                      
             );
              opciones..add(wifgetTemp);
          }
          else{
            final wifgetTemp = ListTile(
             leading: Icon(Icons.location_on, color: Colors.grey,),
             title: Text(temp[i].inventarioConsecutivo.toString() + ' - Ubicacion: ' + temp[i].ubicacionCodigo.toString() + ' ' + temp[i].tipoUbicacionDescripcion.toString() ),             
              trailing: Icon(Icons.arrow_right),
                  onTap: ()async {
                    
                    final cauiProvider = Provider.of<CapUIProvider>(context, listen: false);
                      final uiProvider = Provider.of<UiReProvider>(context, listen: false);   
                      final secProvider = Provider.of<DetailsSecuenceService>(context, listen: false);   
                       String re = await  location.saveIdLocation(temp[i].ubicacionCodigo.toString());
                       
                      final  internet = await uiProvider.readISt();
                      final idUsuario = await cauiProvider.readIdUser();

                      if(re == '1'){                        
                         uiProvider.bodegaBusq = temp[i].ubicacionCodigo.toString();
                         uiProvider.ubicacionId = temp[i].ubicacionId;
                         secProvider.idubicacion = temp[i].ubicacionId;
                         uiProvider.writeLocation(temp[i].ubicacionId);
                         cauiProvider.selectedMenuOpt2 = 0;
                         //Enviar el estado y el id del usuario
                         print(internet);
                         print(idUsuario);

                          Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context){
                              return PushCaptureScreen( idUbicacion: temp[i].ubicacionId.toString(), internet: internet, idUsuario: idUsuario,);
                            } 
                          ));
                       // uiProvider.selectedMenuOpt = 1;
                      }
                      else{
                          AlertDialog(
                          title: Text('Eliminar registros'),
                          content: SingleChildScrollView(child: ListBody(children: [Text('¿Está seguro?')],)),
                          actions: [
                            TextButton(onPressed: () {
                              
                              Navigator.of(context).pop();

                            }, child: Text('Cancelar')),

                            TextButton(onPressed: ()  {
                                                        

                            }, child: Text('Eliminar')),


                          ],
                        );
                      }
                  },             
             );
              opciones..add(wifgetTemp);
          }          
        }
     }
     return opciones;
  }

}

