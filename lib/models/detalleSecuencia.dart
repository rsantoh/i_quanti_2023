// ignore_for_file: file_names

import 'dart:convert';
class DetalleSeuencia {

    DetalleSeuencia({
        this.txRegistroId,
        this.productoCodigo,
        this.productoDescripcion,
        this.ubicacionId,
        this.cantidad,
        this.fecha,     
        this.estado,     
    });    

    int? txRegistroId;
    String? productoCodigo;
    String? productoDescripcion;
    int? ubicacionId;
    double? cantidad;
    String? fecha; 
    String? estado;

    factory DetalleSeuencia.fromJson(String str) => DetalleSeuencia.fromMap(json.decode(str));
    String toJson() => json.encode(toMap());

    factory DetalleSeuencia.fromMap(Map<String, dynamic> json) => DetalleSeuencia(
        txRegistroId: json["txRegistroId"],
        productoCodigo: json["productoCodigo"],
        productoDescripcion: json["productoDescripcion"],
        ubicacionId: json["ubicacionId"],
        cantidad: json["cantidad"],
        fecha: json["fecha"], 
        estado: json["estado"], 
    );

    Map<String, dynamic> toMap() => {
        "txRegistroId": txRegistroId,
        "productoCodigo": productoCodigo,
        "productoDescripcion": productoDescripcion,
        "ubicacionId": ubicacionId,
        "cantidad": cantidad,
        "fecha": fecha,  
        "estado": estado,  
    };
}