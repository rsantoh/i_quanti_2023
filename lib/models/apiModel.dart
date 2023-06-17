import 'dart:convert';
class ApiQuanti {
    ApiQuanti({
       required this.url_Api,
       required this.nombreRuta,   
    });   
    String url_Api;
    String nombreRuta;  
    factory ApiQuanti.fromJson(String str) => ApiQuanti.fromMap(json.decode(str));
    String toJson() => json.encode(toMap());
    factory ApiQuanti.fromMap(Map<String, dynamic> json) => ApiQuanti(
        url_Api: json["url_Api"],
        nombreRuta: json["nombreRuta"],
    );
    Map<String, dynamic> toMap() => {
        "url_Api": url_Api,
        "nombreRuta": nombreRuta,       
    };
}