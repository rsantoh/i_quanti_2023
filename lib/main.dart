import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:i_quanti_2023/providers/clean_cache_provider.dart';
import 'package:i_quanti_2023/providers/rec_re_provider.dart';
import 'package:i_quanti_2023/providers/sync_data_location_provider.dart';
import 'package:i_quanti_2023/providers/sync_data_provider.dart';
import 'package:i_quanti_2023/providers/ui_re_provider.dart';
import 'package:i_quanti_2023/screems/Registros/capture_product_ind.dart';
import 'package:i_quanti_2023/services/homeModule1/detailsSecuenceService.dart';
import 'package:i_quanti_2023/services/homeModule1/locationService.dart';
import 'package:provider/provider.dart';

import 'screems/screems.dart';
import 'services/login_service.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
   runApp(MyApp());
  configLoading();

} 

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
    //..customAnimation = CustomAnimation();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(      
      providers: [
        ChangeNotifierProvider(create: (_) => UiReProvider()),
        ChangeNotifierProvider(create: (_)=> AuthService()),
        ChangeNotifierProvider(create: (_)=> CapUIProvider()),
        ChangeNotifierProvider(create: (_)=> LocationService()),
        ChangeNotifierProvider(create: (_)=> SyncDataProvider()),        
        ChangeNotifierProvider(create: (_)=> DetailsSecuenceService()),
        ChangeNotifierProvider(create: (_)=> SyncDataLocationProvider()),
        ChangeNotifierProvider(create: (_)=> CleanCacheProvider()),
        
      ],

      child: MaterialApp(        
        
        title: 'Quanti',
        initialRoute: 'checking',
        routes: {
          'home':(_) => HomePage(),
          // 'mapa':(_) => MapaPage(),
          'login':(_) => LoginScreen(),
          'forgotPassword': (_) => ForgotScreen(),
          'checking': (_) => CheckAuthScreen(),
          'sync_all' : (_) => SyncDataScreen(),
          //'pushRecord' : (_) => PushCaptureScreen(),
          'sync_location' : (_) => SyncDataLocationScreen(),   
          'Reg_prod_individual' : (_) => RegistrarProductoIndividual(),   
          //'capture_cam' : (_) => CameraCaptureBarcoderScreen(),   
            
        },
        theme: ThemeData.light(),
        //  theme: ThemeData(
        //   primaryColor: Colors.blueGrey,
        //   floatingActionButtonTheme: FloatingActionButtonThemeData(
        //     backgroundColor: Colors.blueGrey
        //   ),
        //   brightness: Brightness.light,
        //   primarySwatch: Colors.blueGrey,
        //   //accentColor: Colors.grey
        // ),
        // darkTheme: ThemeData(
        //      primaryColor: Colors.black,
        //     floatingActionButtonTheme: FloatingActionButtonThemeData(
        //       backgroundColor: Colors.pink
        //     ),
           
        //     brightness: Brightness.dark,
        //     primarySwatch: Colors.pink,
          
            
        //   ),
      
         debugShowCheckedModeBanner: false,

         builder: EasyLoading.init(),
      ),
    );
  }
}
