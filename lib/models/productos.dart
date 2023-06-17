import 'dart:convert';
class Productos {
    Productos({
       // this.productoId,
        this.productoCodigo,   
       // this.productoDescripcion,   
    });   
   // int? productoId;
    String? productoCodigo;  
   // String? productoDescripcion;  
    factory Productos.fromJson(String str) => Productos.fromMap(json.decode(str));
    String toJson() => json.encode(toMap());
    factory Productos.fromMap(Map<String, dynamic> json) => Productos(
        //productoId: json["productoId"],
        productoCodigo: json["productoCodigo"],
       // productoDescripcion: json["productoDescripcion"],
    );
    Map<String, dynamic> toMap() => {
       // "productoId": productoId,
        "productoCodigo": productoCodigo,       
        //"productoDescripcion": productoDescripcion,       
    };
}