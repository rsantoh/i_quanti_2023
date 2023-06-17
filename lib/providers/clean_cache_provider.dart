
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../services/dbLocal/localdb_service.dart';
//ChangeNotifier va permitinos que la clase sea puesta en un multiprovider o un checkprovider
class CleanCacheProvider extends ChangeNotifier{

  //para conectar los valores del login con esta clase
  //si stroy dentro de un form es FormState y si es scaffold ScafoldState etc
    Future <String> cleanCache()async{
      EasyLoading.show(status: 'Limpiando...');
      await Future.delayed(Duration(seconds: 2));
     
      await DBProvider.db.deleteCerradasOffline();
      await DBProvider.db.deleteAllInventoryClose();
      await DBProvider.db.deleteSequence();
      EasyLoading.dismiss();
      EasyLoading.showSuccess('Listo');
      return '1';
    }

}