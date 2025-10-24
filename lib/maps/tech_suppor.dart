class TechSuppor {
  String? token, nombres, apellidos, mail, sede, rol, activo;

  TechSuppor({
    required this.token,
    required this.nombres,
    required this.apellidos,
    required this.mail,
    //required this.psw,
    required this.sede,
    required this.rol,
    //required this.creado,
    required this.activo,
  });

  // Método para crear un TechSuppor desde un mapa (como el que viene del JSON)
  factory TechSuppor.fromJson(Map<String, dynamic> json) {
    return TechSuppor(
     token: json["token"] ?? "",  
     nombres: json["nombre"] ?? "",  
     apellidos: json["apellido"] ?? "",  
     mail: json["correo"] ?? "",
     //psw: json["psw"] ?? "", 
     sede: json["sede"] ?? "", 
     rol: json["rol"] ?? "", 
     //creado: json["creado"] ?? "",    
     activo: json["activo"] ?? "",    
    );
  }

  // Método para convertir un Usuario a JSON
  Map<String, dynamic> toJson() {
    return {
      "token": token,
      "nombre": nombres,
      "apellido": apellidos,
      "correo": mail,
     // "psw": psw,
      "sede": sede,
      "rol": rol,
      //"creado": creado,
      "activo": activo,
    };
  }

  TechSuppor.empty()
  : token = "",
  nombres = "",
  apellidos = "",
  mail = "",
  //psw = "",
  sede = "",
  rol = "",
  //creado = "",
  activo = null;


}
