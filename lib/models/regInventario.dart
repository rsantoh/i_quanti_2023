import 'dart:convert';
class RegistroInventario {
    RegistroInventario({
       required this.ubicacionI,
       required this.productoCodigo,
       required this.usuarioId,
       required this.cantidad,
       required this.operacion,
       required this.tipoRegistro,
       this.descripcion,
    });    
    int ubicacionI;
    String productoCodigo;
    int usuarioId;   
    double cantidad;   
    int operacion;   
    int tipoRegistro;   
    String? descripcion;   
    factory RegistroInventario.fromJson(String str) => RegistroInventario.fromMap(json.decode(str));
    String toJson() => json.encode(toMap());
    factory RegistroInventario.fromMap(Map<String, dynamic> json) => RegistroInventario(
        ubicacionI: json["ubicacionI"],
        productoCodigo: json["productoCodigo"],
        usuarioId: json["usuarioId"],       
        cantidad: json["cantidad"],       
        operacion: json["operacion"],       
        tipoRegistro: json["tipoRegistro"],       
    );
    Map<String, dynamic> toMap() => {
        "ubicacionI": ubicacionI,
        "productoCodigo": productoCodigo,
        "usuarioId": usuarioId,       
        "cantidad": cantidad,       
        "operacion": operacion,       
        "tipoRegistro": tipoRegistro,       
    };
}