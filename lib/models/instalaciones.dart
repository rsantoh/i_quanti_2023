import 'dart:convert';
class Instalaciones {
    Instalaciones({
        this.instalacionId,
        this.instalacionCodigo,
        this.instalacionDescripcion,
    });    
    int? instalacionId;
    String? instalacionCodigo;
    String? instalacionDescripcion;   
    factory Instalaciones.fromJson(String str) => Instalaciones.fromMap(json.decode(str));
    String toJson() => json.encode(toMap());
    factory Instalaciones.fromMap(Map<String, dynamic> json) => Instalaciones(
        instalacionId: json["instalacionId"],
        instalacionCodigo: json["instalacionCodigo"],
        instalacionDescripcion: json["instalacionDescripcion"],       
    );
    Map<String, dynamic> toMap() => {
        "instalacionId": instalacionId,
        "instalacionCodigo": instalacionCodigo,
        "instalacionDescripcion": instalacionDescripcion,       
    };
}