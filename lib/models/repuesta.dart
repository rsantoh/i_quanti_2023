import 'dart:convert';
class Respuesta {
    Respuesta({
        this.productocodigo,
        this.resultado,   
    });   
    String? productocodigo;
    String? resultado;  
    factory Respuesta.fromJson(String str) => Respuesta.fromMap(json.decode(str));
    String toJson() => json.encode(toMap());
    factory Respuesta.fromMap(Map<String, dynamic> json) => Respuesta(
        productocodigo: json["productocodigo"],
        resultado: json["resultado"],
    );
    Map<String, dynamic> toMap() => {
        "productocodigo": productocodigo,
        "resultado": resultado,       
    };
}