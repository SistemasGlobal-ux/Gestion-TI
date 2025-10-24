myUrls(String u) {
  const url = {
    "USERS": "usuarios.php",
    "USERBAJA": "usuarioBaja.php",
    "EQUIPOBAJA": "equipoBaja.php",
    "DELETEUSER": "deleteusuario.php",
    "EQUIPOS": "equipos.php",
    "MAILS": "mails.php",
    "TECNICOS": "tecnicos.php",
    "GENERAL": "general.php",
    "GENERALE": "generalEquipos.php",
    "ADDUSER": "addUsuario.php",
    "ADDMAIL": "addMail.php",
    "DELETEMAIL": "deleteMail.php",
    "ASIGNAREQUIPO": "asignarEquipo.php",
    "SOPORTESDATE":"soportes.php",
    "ADDSOPORTE":"addSoporte.php",
    "CONSULTAD" : "consultaDato.php",
    "ADDEQUIPO": "addEquipo.php",
    "ALLSOPORTES" : "allSoportes.php", 
    "CHEKTECNICO": "chekTecnico.php",
    "GETTECNICO": "getTecnico.php",
    "ADDEQUIPOUSER": "addequipoUser.php",
  };
  //var uringrok = Uri.parse("https://925c-2806-2f0-9261-9cb1-b046-78d4-41e4-b3de.ngrok-free.app/myphps/${url[u]}");
  //var uri = Uri.parse("http://localhost/pruebasphp/${url[u]}");
  var uri = Uri.parse("https://administracioncorporativabl1.com/globaldocs/${url[u]}");
  return uri;
}

mySk(){
  //uri socket https://administracioncorporativabl1.com/realtime/send.php
  //wss://ws-us2.pusher.com/app/92df15fa44931195761b?protocol=7&client=js&version=7.0.3&flash=false
  var uri = Uri.parse("https://administracioncorporativabl1.com/realtime/send.php");
  return uri;
}