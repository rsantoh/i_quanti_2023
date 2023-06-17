import 'dart:convert';
class Bodegas {
    Bodegas({
        this.inventarioConsecutivo,
        this.programacionInventarioConsecutivo,
        this.ubicacionCodigo,
        required this.ubicacionId,
        this.tipoUbicacionDescripcion,
        this.configuracionUbicaciones,    
        this.estado 
    });
    
    int? inventarioConsecutivo;
    int? programacionInventarioConsecutivo;
    String? ubicacionCodigo;
    int ubicacionId;
    String? tipoUbicacionDescripcion;
    String? configuracionUbicaciones; 
    String? estado;

    factory Bodegas.fromJson(String str) => Bodegas.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Bodegas.fromMap(Map<String, dynamic> json) => Bodegas(
        inventarioConsecutivo: json["inventarioConsecutivo"],
        programacionInventarioConsecutivo: json["programacionInventarioConsecutivo"],
        ubicacionCodigo: json["ubicacionCodigo"],
        ubicacionId: json["ubicacionId"],
        tipoUbicacionDescripcion: json["tipoUbicacionDescripcion"],
        configuracionUbicaciones: json["configuracionUbicaciones"], 
        estado: json["estado"], 
    );

    Map<String, dynamic> toMap() => {
        "inventarioConsecutivo": inventarioConsecutivo,
        "programacionInventarioConsecutivo": programacionInventarioConsecutivo,
        "ubicacionCodigo": ubicacionCodigo,
        "ubicacionId": ubicacionId,
        "tipoUbicacionDescripcion": tipoUbicacionDescripcion,
        "configuracionUbicaciones": configuracionUbicaciones,  
        "estado": estado,  
    };
}