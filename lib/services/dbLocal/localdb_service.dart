// ignore_for_file: empty_catches, avoid_print, unused_local_variable, import_of_legacy_library_into_null_safe

import 'dart:io';
import 'package:i_quanti_2023/models/bodegas.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../models/models.dart';

class DBProvider{

  static Database? _database;
  
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database>get database async{
    if(_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async{
    //path database 
    Directory docummentDirectory = await getApplicationDocumentsDirectory();
    //
    final path = join(docummentDirectory.path, 'quantiDB.db');
    print(path);
    //Create database   
    return await openDatabase(
      path,
      version: 9,
      onOpen: (db) {},
      onCreate: (Database db, int version)async {
        await db.execute('''
          CREATE TABLE Inventory(
            inventarioConsecutivo INTENGER,
            programacionInventarioConsecutivo INTENGER,
            ubicacionCodigo TEXT,
            ubicacionId INTENGER,
            tipoUbicacionDescripcion TEXT,
            configuracionUbicaciones TEXT,
            estado TEXT
          );    
        ''');

         await db.execute('''          
         CREATE TABLE InventoryDetailSequence(
            txRegistroId INTENGER,
            productoCodigo TEXT,
            productoDescripcion TEXT,
            ubicacionId INTENGER,
            cantidad REAL,
            fecha TEXT,
            estado TEXT
          );        
        ''');

         await db.execute('''
          CREATE TABLE UbicacionesCerradas(            
            ubicacionId INTENGER,           
            estado TEXT,
            ubicacionCodigo TEXT 
          );    
        ''');

         await db.execute('''
          CREATE TABLE Productos(   
            productoCodigo TEXT           
          );    
        ''');

           await db.execute('''
          CREATE TABLE QuantiAPI(   
            nombreRuta TEXT,  
            url_Api TEXT         
          );    
        ''');

      }
    );
  }


 Future<int> insertInfoInventory(Bodegas bodega) async {
    final db = await database;
    //final res = await db.insert('Inventory', bodega.toMap()); 
    //int count = Sqflite.firstIntValue(await database.rawQuery('SELECT COUNT(*) FROM Test'));
    int inventarioConsecutivo = bodega.inventarioConsecutivo!;
    int programacionInventarioConsecutivo = bodega.programacionInventarioConsecutivo!;
    String ubicacionCodigo = bodega.ubicacionCodigo!;
    int ubicacionId = bodega.ubicacionId;
    String tipoUbicacionDescripcion = bodega.tipoUbicacionDescripcion!;
    String configuracionUbicaciones = bodega.configuracionUbicaciones!;
    String estado = 'A';

    //final con = await db.query('Inventory', where: 'ubicacionId=?', whereArgs:[ubicacionId] );
     final con = await db.rawQuery('''
        SELECT  * FROM Inventory WHERE ubicacionId = '$ubicacionId'
      ''');
    
    if(con.isNotEmpty){   
      Bodegas.fromMap(con.first);  
      print('Hay registros');
    }
    else{      
      final res = await db.rawInsert('''
          INSERT INTO Inventory(inventarioConsecutivo,programacionInventarioConsecutivo,ubicacionCodigo,ubicacionId,tipoUbicacionDescripcion,configuracionUbicaciones, estado )
            VALUES($inventarioConsecutivo, '$programacionInventarioConsecutivo', '$ubicacionCodigo', '$ubicacionId','$tipoUbicacionDescripcion','$configuracionUbicaciones', '$estado' )
          ''');
    }
    return 1;
  }

  Future<List<Bodegas>> getInventoryLocal(String ubCodigo) async {
    final db = await database;
    String estado = 'A';
    final res = await db.rawQuery('''
        SELECT DISTINCT * FROM Inventory WHERE ubicacionCodigo like '%$ubCodigo%' AND estado = '$estado'
      ''');

    return res.isNotEmpty
        ? res.map((e) => Bodegas.fromMap(e)).toList()
        : [];

  }

   Future<List<Bodegas>> getAllInventoryData() async {
    final db = await database;
    //final res = await db.query('Inventory');
    String estado = 'A';
      final res = await db.rawQuery('''
        SELECT DISTINCT * FROM Inventory WHERE estado = '$estado'
      ''');
     return res.isNotEmpty
        ? res.map((e) => Bodegas.fromMap(e)).toList()
        : [];
  }

  Future<int> deleteInventory()async{
     final db = await database;
     final res = await db.delete('Inventory');
     return 1;
  }

   Future<List<Bodegas>> getUbicacionByIdUbicacion(int idUb) async {
    final db = await database;
    //final res = await db.query('Inventory');
    String estado = 'A';
      final res = await db.rawQuery('''
        SELECT DISTINCT * FROM Inventory WHERE ubicacionId = '$idUb'
      ''');
     return res.isNotEmpty
        ? res.map((e) => Bodegas.fromMap(e)).toList()
        : [];
  }


  Future<int> cerrarUbicacionOffline( int ubId, String ub) async {
     try {
       final db = await database;
        int ubicacionId = ubId;   
        String estado = 'CERRADO';  
        String ubicacion = ub;    
        //final con = await db.query('Inventory', where: 'ubicacionId=?', whereArgs:[ubicacionId] );
        // final res = await db.rawInsert('''
        //   UPDATE Inventory  SET estado = 'CERRADO' WHERE ubicacionId = '$ubicacionId'
        //   ''');  
         final res = await db.rawInsert('''
          INSERT INTO UbicacionesCerradas(ubicacionId, estado, ubicacionCodigo )
            VALUES($ubicacionId, '$estado','$ubicacion' )
          ''');

     } catch (e) {
     }    
       
    return 1;
  }
  //obtiene las ubicaciones cerradas de forma offline
   Future<List<Bodegas>> deleteAllInventoryClose() async {
    final db = await database;
    //final res = await db.query('Inventory');
    String estado = 'CERRADO'; 
      final res = await db.rawQuery('''
        SELECT DISTINCT * FROM UbicacionesCerradas WHERE estado = '$estado'
      ''');
     return res.isNotEmpty
        ? res.map((e) => Bodegas.fromMap(e)).toList()
        : [];
  }


   Future<int> deleteSequence()async{
     final db = await database;
     final res = await db.delete('InventoryDetailSequence');
     return 1;
  }

   Future<int> deleteCerradasOffline()async{
     final db = await database;
     final res = await db.delete('UbicacionesCerradas');
     return 1;
  }


   Future<int> deleteUbicacionCerradaOff(int ubId) async {
     try {
      final db = await database;      
      int ubicacionId = ubId;
    
      //final con = await db.query('Inventory', where: 'ubicacionId=?', whereArgs:[ubicacionId] );
      final res = await db.rawInsert('''
        DELETE FROM UbicacionesCerradas         
        WHERE ubicacionId = '$ubId'
        ''');  
      } catch (e) {
      }  
    return 1;
  }

  Future<int> deleteUploadSequenceUb(int idUbicacion ) async {
     try {
       final db = await database;
            
        int ubicacionId = idUbicacion;      
        
        String estado = 'OF';//D -- Descargado, U
        //final con = await db.query('Inventory', where: 'ubicacionId=?', whereArgs:[ubicacionId] );
        final res = await db.rawInsert('''
          DELETE FROM InventoryDetailSequence          
          WHERE  ubicacionId = '$ubicacionId' AND estado = '$estado'
          ''');  
     } catch (e) {
     }  
    return 1;
  }
  
  
   Future<int> insertProductsRow(String insert) async {
     try {
        final db = await database;
       final res = await db.rawInsert('''
          INSERT INTO Productos(productoCodigo)
            VALUES $insert
          ''');  

      //  final db = await database;
      //    final res = await db.insert('Productos', products.toMap());
        
     } catch (e) {
     }  
    return 1;
  }

   Future<int> deleteProductos()async{
     final db = await database;
     final res = await db.delete('Productos');
     return 1;
  }

   Future<List<Productos>> getProductosLocal(prodCod) async {
     List<Productos> productos = []; 
    final db = await database;
     
      final res = await db.rawQuery('''
        SELECT DISTINCT * FROM Productos WHERE productoCodigo = '$prodCod'
      ''');
     return res.isNotEmpty
        ? res.map((e) => Productos.fromMap(e)).toList()
        : [];
  }

    Future<int> deleteUploadSequenceUbUniqueSync(int idUbicacion, int txRegistroId, String productoCodigo, String fecha ) async {
     try {
       final db = await database;
            
        int ubicacionId = idUbicacion;      
        int txtRegistro = txRegistroId;      
        String productCod = productoCodigo;      
        String fech = fecha;      
        
        String estado = 'OF';//D -- Descargado, U
        //final con = await db.query('Inventory', where: 'ubicacionId=?', whereArgs:[ubicacionId] );
        final res = await db.rawInsert('''
          DELETE FROM InventoryDetailSequence          
          WHERE  ubicacionId = '$ubicacionId' AND estado = '$estado' AND txRegistroId = '$txtRegistro' AND productoCodigo = '$productCod' AND fecha = '$fech'
          ''');  
     } catch (e) {
     }  
    return 1;
  }

   Future<int> deletedUploadSequenceForIdUbicacionAndIdProducto(int idUbicacion, String productoCodigo ) async {
     try {
       final db = await database;
            
        int ubicacionId = idUbicacion;     
        String productCod = productoCodigo; 
        String estado = 'OF';//D -- Descargado, U
        //final con = await db.query('Inventory', where: 'ubicacionId=?', whereArgs:[ubicacionId] );
        final res = await db.rawInsert('''
          DELETE FROM InventoryDetailSequence          
          WHERE  ubicacionId = '$ubicacionId' AND estado = '$estado' AND productoCodigo = '$productCod'
          ''');  
     } catch (e) {
     }  
    return 1;
  }



  //  Future<int> insertInfoInvDetalleSecuencia(DetalleSeuencia detSec) async {
     
  //   final db = await database;
  //   //final res = await db.insert('Inventory', bodega.toMap()); 
  //   //int count = Sqflite.firstIntValue(await database.rawQuery('SELECT COUNT(*) FROM Test'));
  //   int txRegistroId = detSec.txRegistroId!;
  //   String productoCodigo = detSec.productoCodigo!;
  //   String productoDescripcion = detSec.productoDescripcion!;
  //   int ubicacionId = detSec.ubicacionId!;
  //   double cantidad = detSec.cantidad!;
  //   String fecha = detSec.fecha!;
  //   String estado = 'D';//D -- Descargado, U

  //   //final con = await db.query('Inventory', where: 'ubicacionId=?', whereArgs:[ubicacionId] );
  //    final con = await db.rawQuery('''
  //       SELECT * FROM InventoryDetailSequence WHERE txRegistroId = '$txRegistroId'
  //     ''');
    
  //   if(con.isNotEmpty){   
  //     Bodegas.fromMap(con.first);  
  //     print('Hay registros');
  //   }
  //   else{      
  //     final res = await db.rawInsert('''
  //         INSERT INTO InventoryDetailSequence(txRegistroId,productoCodigo,productoDescripcion,ubicacionId,cantidad,fecha,estado )
  //           VALUES($txRegistroId, '$productoCodigo', '$productoDescripcion', '$ubicacionId','$cantidad','$fecha','$estado' )
  //         ''');
  //   }
  //   return 1;
  // }


   Future<List<DetalleSeuencia>> getAllDetailsSecuencia(int idUbicacion) async {
    final db = await database;
      String estado= 'ON';
    //final res = await db.query('Inventory');
      final res = await db.rawQuery('''
        SELECT DISTINCT txRegistroId, productoCodigo, productoDescripcion, ubicacionId, cantidad, fecha, estado   FROM InventoryDetailSequence 

        WHERE ubicacionId ='$idUbicacion'
      
        ORDER BY fecha DESC
      ''');
     return res.isNotEmpty
        ? res.map((e) => DetalleSeuencia.fromMap(e)).toList()
        : [];
  }


    

   Future<int> insertInfoInvDetalleSecuenciaUnique(int txtRegistroId, String productoCod, String productoDes, int ubId, double cant, String fech, String tipo ) async {
     try {
       final db = await database;
        int txRegistroId = txtRegistroId;
        String productoCodigo = productoCod;
        String productoDescripcion = productoDes;
        int ubicacionId = ubId;
        double cantidad = cant;
        String fecha = fech;
        String estado = tipo;//D -- Descargado, U

        //final con = await db.query('Inventory', where: 'ubicacionId=?', whereArgs:[ubicacionId] );
        final res = await db.rawInsert('''
          INSERT INTO InventoryDetailSequence(txRegistroId,productoCodigo,productoDescripcion,ubicacionId,cantidad,fecha,estado )
            VALUES($txRegistroId, '$productoCodigo', '$productoDescripcion', '$ubicacionId','$cantidad','$fecha','$estado' )
          ''');  
          print(res);
          if(res == null){
           return -1;
         }
     } catch (e) {
     }    
       
    return 1;
  }

  Future<int> insertInfoInvUpdateSecuenciaUnique(int txtRegistroId, String productoCod, String productoDes, int ubId, double cant, String fech, String tipo ) async {
     try {
       final db = await database;
        int txRegistroId = txtRegistroId -1;
        String productoCodigo = productoCod;
        String productoDescripcion = productoDes;
        int ubicacionId = ubId;
        double cantidad = cant;
        String fecha = fech;
        String estado = tipo;//D -- Descargado, U
        //final con = await db.query('Inventory', where: 'ubicacionId=?', whereArgs:[ubicacionId] );
        final res = await db.rawInsert('''
          DELETE FROM InventoryDetailSequence          
          WHERE  ubicacionId = '$ubId' AND productoCodigo = '$productoCodigo' AND estado = '$estado' AND txRegistroId = '$txRegistroId'
          ''');  
         if(res == null){
           return -1;
         }
          
     } catch (e) {
     }  
    return 1;
  }

 Future<int> eliminaIndividualSecuenciaOffline(int txtRegistroId, int idUbicacion, String hr, String tipo ) async {
     try {
       final db = await database;
        int txRegistroId = txtRegistroId;      
        int ubicacionId = idUbicacion;      
        String fecha = hr;
        String estado = tipo;//D -- Descargado, U
        //final con = await db.query('Inventory', where: 'ubicacionId=?', whereArgs:[ubicacionId] );
        final res = await db.rawInsert('''
          DELETE FROM InventoryDetailSequence   
          WHERE  ubicacionId = '$ubicacionId' AND txRegistroId = '$txRegistroId' AND estado = '$estado' AND fecha = '$fecha'
          ''');  

     } catch (e) {
     }  
    return 1;
  }
 

   Future<List<DetalleSeuencia>> getAllDetailsSecuenciaLocal(int idUbicacion) async {
    final db = await database;
      String estado = 'OF';
      String estado2 = 'D';
    //final res = await db.query('Inventory');
      final res = await db.rawQuery('''
        SELECT DISTINCT * FROM InventoryDetailSequence 
        WHERE ubicacionId ='$idUbicacion' AND estado = '$estado'
        ORDER BY fecha DESC
      ''');
     return res.isNotEmpty
        ? res.map((e) => DetalleSeuencia.fromMap(e)).toList()
        : [];
  }


   Future<int> eliminaSecuenciaDespuesDeCargar(int idUbicacion,  String tipo, String tipo2 ) async {
     try {
       final db = await database;             
        int ubicacionId = idUbicacion;  
        String estado = tipo;//D -- Descargado, U
        String estado2 = tipo2;//D -- Descargado, U
        //final con = await db.query('Inventory', where: 'ubicacionId=?', whereArgs:[ubicacionId] );
        final res = await db.rawInsert('''
          DELETE FROM InventoryDetailSequence          
          WHERE  ubicacionId = '$ubicacionId' AND  estado = '$estado' OR estado = '$estado2'
          ''');  
     } catch (e) {
     }  
    return 1;
  }

   Future<int> insertProductsRowNew(String insert) async {
     try {
        final db = await database;
       final res = await db.rawInsert('''
          INSERT INTO Productos(productoCodigo)
            VALUES $insert
          ''');  
           if(res == null){
           return -1;
         }

      //  final db = await database;
      //    final res = await db.insert('Productos', products.toMap());
        
     } catch (e) {
     }  
    return 1;
  }

    Future<int> deleteUploadSequenceProductoUb(int idUbicacion, String codigoProd ) async {
     try {
       final db = await database;
            
        int ubicacionId = idUbicacion;      
        String codigoProdu = codigoProd;      
        
        String estado = 'OF';//D -- Descargado, U
        //final con = await db.query('Inventory', where: 'ubicacionId=?', whereArgs:[ubicacionId] );
        final res = await db.rawInsert('''
          DELETE FROM InventoryDetailSequence          
          WHERE  ubicacionId = '$ubicacionId' AND estado = '$estado' AND productoCodigo = '$codigoProdu'
          ''');  
     } catch (e) {
     }  
    return 1;
  }


 Future<int> insertApiQuanti(String urlApi, String nombre) async {
    final db = await database;
    //final res = await db.insert('Inventory', bodega.toMap()); 
    //int count = Sqflite.firstIntValue(await database.rawQuery('SELECT COUNT(*) FROM Test'));
    String nombreRuta = nombre;
    String urlAp = urlApi;   

    final res = await db.rawInsert('''
    INSERT INTO QuantiAPI(nombreRuta,url_Api )
      VALUES('$nombreRuta', '$urlApi' )
    '''); 

    return res;
  }

  Future<int> deleteQuantiAPI()async{
     final db = await database;
     final res = await db.delete('QuantiAPI');
     return 1;
  }
   
    Future<String> GetApiUrl(String routName) async {
    final db = await database;    
    //final res = await db.query('Inventory');
      final res = await db.rawQuery('''
        SELECT DISTINCT url_Api FROM QuantiAPI 
        WHERE nombreRuta ='$routName'       
      ''');
      return res.isNotEmpty
         ? res[0]['url_Api'].toString()
         : 'https://quanti.biz/quantiError/quantiError/api/GetError';
    
  }

    // Future<List<ApiQuanti>> GetApiUrl(String routName) async {
    // final db = await database;      
    // //final res = await db.query('Inventory');
    //   final res = await db.rawQuery('''
    //     SELECT url_Api FROM QuantiAPI
    //     WHERE nombreRuta ='$routName'               
    //   ''');
    //  return res.isNotEmpty
    //     ? res.map((e) => ApiQuanti.fromMap(e)).toList()
    //     : [];
    // }
  
}


