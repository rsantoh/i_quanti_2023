import 'dart:convert';
class RespuestaSync {
    RespuestaSync({
       
           
       required this.ubicacionId,   
        this.productoCodigo,  
        this.operacion,    
        this.errorDescripcion, 
        this.status   
    });   
    
    int ubicacionId;  
    String? productoCodigo;  
    bool? operacion;  
    String? errorDescripcion;  
    int? status;
    factory RespuestaSync.fromJson(String str) => RespuestaSync.fromMap(json.decode(str));
    String toJson() => json.encode(toMap());
    factory RespuestaSync.fromMap(Map<String, dynamic> json) => RespuestaSync(
        
        ubicacionId: json["ubicacionId"],
        productoCodigo: json["productoCodigo"],
        operacion: json["operacion"],
        errorDescripcion: json["errorDescripcion"],
        status: json["status"],
    );
    Map<String, dynamic> toMap() => {
             
        "ubicacionId": ubicacionId,       
        "productoCodigo": productoCodigo,       
        "operacion": operacion,       
        "errorDescripcion": errorDescripcion,       
        "status": status,       
    };
}