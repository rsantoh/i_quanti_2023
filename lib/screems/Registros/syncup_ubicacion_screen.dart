// ignore_for_file: avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';


class SyncUpUbicacionPage extends StatelessWidget {
  const SyncUpUbicacionPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UiReProvider>(context); 
    return Center(
        child: Container(
          child: MaterialButton(
             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
             disabledColor: Colors.grey,
             elevation: 0,
             color: Colors.blueAccent,
             child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                // ignore: prefer_const_constructors
                child: Text(
                'Sincronizar la Ubicacion '
                )
              ),
              onPressed: () {
                if(uiProvider.status){
                  
                  final syncpro = Provider.of<SyncDataLocationProvider>(context, listen: false); 
                  syncpro.status = false;
                  // syncpro.asyncDataLocal();
                  Navigator.pushReplacementNamed(context, 'sync_location'); 
                }
                else{                  
                  showDialog(
                  context: context, 
                    builder: (BuildContext context){
                        return AlertDialog(
                          title: const Text('Error...'),
                          content: SingleChildScrollView(child: ListBody(children: [const Text('Verifique el estado de su conexión')],)),
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
        )
      );
  }
}