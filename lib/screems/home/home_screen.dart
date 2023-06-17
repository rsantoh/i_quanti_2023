// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, unused_local_variable, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:i_quanti_2023/providers/providers.dart';
import 'package:i_quanti_2023/providers/ui_re_provider.dart';
import 'package:i_quanti_2023/screems/Registros/records_screen.dart';
import 'package:i_quanti_2023/screems/screems.dart';
import 'package:provider/provider.dart';

import '../../providers/rec_re_provider.dart';
import '../../providers/sync_data_provider.dart';
import '../../services/dbLocal/localdb_service.dart';
import '../../services/login_service.dart';
import '../syncin/sync_location_offline.dart';

class HomePage extends StatelessWidget {
   
  const HomePage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
       final uiProvider = Provider.of<UiReProvider>(context); 
        // uiProvider.readUser();
      //  WidgetsFlutterBinding.ensureInitialized(); 
    // DBProvider.db.database; 
    return Scaffold(     

      appBar: AppBar(        
        elevation: 0,
        title:Text(uiProvider.nombreUser),
        actions: [
          Container(
            child: Center(
              child: Text(uiProvider.statusText,),
            )
          ),          
          Switch.adaptive(
            value: uiProvider.status,             
            activeColor: Colors.green,
            inactiveTrackColor: Color.fromARGB(255, 232, 47, 66),
              onChanged: (value)async{     
                uiProvider.updateStatus(value);
                 final capProvider = Provider.of<CapUIProvider>(context, listen: false);
                 capProvider.ubAux = '';                      
                 
              }            
            ),
            Container(

            )        
        ],
        
      ),
      drawer: MenuWidget(),
      body: _HomeRegBody(),
      bottomNavigationBar: CustomNavigationBar(),
    );
  }
}
class MenuWidget extends StatelessWidget {
  //retornamos el menú   
  @override
  Widget build(BuildContext context) {  
final uiProvider = Provider.of<UiReProvider>(context); 
     final loginForm = Provider.of<AuthService>(context, listen: false);   
     
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,//La imagen coge la barra de notificaciones
        children: [

          Container(
             padding: EdgeInsets.all(5),
            child: DrawerHeader(
              child: Container(               
                child: Container(
                  child: Text(''),
                ),
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/menu-img.png'),
                  fit: BoxFit.fitWidth//expande la imagen
                )
              ),
              ),
          ),
            //Ponemos opciones del menú      
             ListTile(
              // leading: Icon(Icons.person, color: Colors.grey),
              title: Text(uiProvider.nombreUser),
              trailing: Icon(Icons.person, color: Colors.grey),
              //Movemos el navigator a la pantalla de settings             

            ),

            ListTile(
              leading: Icon(Icons.inventory_rounded, color: Colors.grey),
              title: Text('Registrar Inventario'),
              //Movemos el navigator a la pantalla de settings
              onTap: () {
               //Navigator.pop(context);
               //esto es utils para logearse
               Navigator.pushReplacementNamed(context, 'home');

              } 

            ),

            

           

            ListTile(
              leading: Icon(Icons.sync_outlined, color: Colors.green),
              title: Text('Sincronizar base de datos'),
              //Movemos el navigator a la pantalla de settings
              onTap: () async {    

                 if(uiProvider.status){
                   final syncProvider = Provider.of<SyncDataProvider>(context, listen: false); 
                    syncProvider.asyncTablas();
                    Navigator.pushReplacementNamed(context, 'sync_all');
                 }
                 else
                 {
                     EasyLoading.showError('Debe estar en modo online');
                 }
                              
              } 
             ),

            //   ListTile(
            //   leading: Icon(Icons.insert_drive_file_outlined, color: Colors.red),
            //   title: Text('Reg. Producto Individual'),
            //   //Movemos el navigator a la pantalla de settings
            //   onTap: () {
            //    //Navigator.pop(context);
            //    //esto es utils para logearse
            //    Navigator.pushNamed(context, 'Reg_prod_individual');

            //   } 

            // ),

            //   ListTile(
            //   leading: Icon(Icons.cleaning_services_rounded, color: Colors.red),
            //   title: Text('Limpiar caché'),
            //   //Movemos el navigator a la pantalla de settings
            //   onTap: () {

            //   showDialog(
            //     context: context, 
            //     builder: (BuildContext context){
            //         return AlertDialog(
            //           title: Text('Seguro'),
            //           content: SingleChildScrollView(child: ListBody(children: [Text('Al limpiar el cache eliminara los registros que tenga capturados y se abriran las ubicaciones que se encuentren cerradas offline, ¿está seguro?')],)),
            //           actions: [
            //             TextButton(onPressed: () {
                        
            //               Navigator.of(context).pop();

            //             }, child: Text('Cancelar')),

            //             TextButton(onPressed: ()  {
            //                final cleanProvider = Provider.of<CleanCacheProvider>(context, listen: false); 
            //                 cleanProvider.cleanCache();
            //                final capProvv = Provider.of<CapUIProvider>(context, listen: false); 
            //                capProvv.ubAux = '';
            //                Navigator.of(context).pop();
            //             }, child: Text('Continuar')),


            //           ],

            //       );
            //     }
            //   );
            //    //Navigator.pop(context);
            //    //esto es utils para logearse
               
            //   } 

            // ),
           
            ListTile(
              leading: Icon(Icons.login_outlined, color: Colors.blue),
              title: Text('Cerrar Sesión'),
              onTap: (){

                  showDialog(
              context: context, 
              builder: (BuildContext context){
                  return AlertDialog(
                    title: Text('Cerrar Sesión'),
                    content: SingleChildScrollView(child: ListBody(children: [Text('Cerrar sesión, ¿está seguro?')],)),
                    actions: [
                      TextButton(onPressed: () {
                       
                        Navigator.of(context).pop();

                      }, child: Text('Cancelar')),

                       TextButton(onPressed: ()  {
                       final loginForm = Provider.of<AuthService>(context, listen: false);
                        loginForm.logout();
                        Navigator.pushReplacementNamed(context, 'login');

                      }, child: Text('Salir')),


                    ],


                  );
              }
              );

              },

            ),

            ListTile(
              // leading: Icon(Icons.verified_user_rounded, color: Colors.red),
              title: Text('QUANTI v.1.2.0'),
              //Movemos el navigator a la pantalla de settings
            

            ),
        ],
      ),
    );
  }
}

class _HomeRegBody extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    //get selectedmenu opt
    final uiProvider = Provider.of<UiReProvider>(context);
    //change to show the screem

    final currentIndex = uiProvider.selectedMenuOpt;    

    if(uiProvider.status == false){
      
      if(uiProvider.status == false && currentIndex==1){
        EasyLoading.showError('Debe estar en modo online');
        
      }      

     switch(0){
      case 0:
        return LocationReRePage();  
     
      default: 
        return LocationReRePage();
    } 

    }
    else{

        switch(currentIndex){
      case 0:
        return LocationReRePage();
     
      case 1:
        return SyncUpLocationOfflinePage();
     
      default: 
        return LocationReRePage();
    } 


    }
  
  }
}
