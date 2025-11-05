
import 'package:application_sop/android_pages/usuarios_a_android.dart';
import 'package:application_sop/android_pages/usuarios_b_android.dart';
import 'package:application_sop/maps/maps.dart';
import 'package:application_sop/providers/providers.dart';
import 'package:application_sop/utils/personalizados.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class DashboardAndroid extends StatefulWidget {
  const DashboardAndroid({super.key});

  @override
  State<DashboardAndroid> createState() => _DashboardAndroidState();
}

class _DashboardAndroidState extends State<DashboardAndroid> {
    @override
  void initState() {
    super.initState();
    Provider.of<UsuariosListProvider>(context, listen: false).loadusers();
    Provider.of<EquiposListProvider>(context, listen: false).loadEquipos();
    Provider.of<CatalogosListProvider>(context, listen: false).loadCatalogos();
    Provider.of<CatalogosEquiposListProvider>(context, listen: false).loadCatalogosEqipos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF111827),
        title: Text("Gestión TI", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      //drawer: Drawer(),
      body: bodyDsbAndroid(context),
    );
  }
}



bodyDsbAndroid(context){
    List<Usuario> usuariosActivos = Provider.of<UsuariosListProvider>(context).users;
    List<Usuario> usuariosBaja = Provider.of<UsuariosListProvider>(context).usersBaja;
    //List<Usuario> listaMostrada = value == 'Activos' ? usuariosActivos : usuariosBaja;
    List<Equipo> equiposEnt = Provider.of<EquiposListProvider>(context).eEntregados;
    List<Equipo> equiposStock = Provider.of<EquiposListProvider>(context).estock;
    List<Equipo> equiposDanados = Provider.of<EquiposListProvider>(context).edanado;
    List<Equipo> equiposPDefinir = Provider.of<EquiposListProvider>(context).eporDefinir;
    //List<Equipo> otros = Provider.of<EquiposListProvider>(context).otros;
  
  return Container(
    margin: EdgeInsets.all(10),
    child: Column(
        children: [
        customResumenCard('Usuarios Activos', "${usuariosActivos.length}" , Icons.person, () =>
        Navigator.push(context,MaterialPageRoute(builder: (_) => UsariosAPageAndroid(usuarios: usuariosActivos)))),
        customResumenCard('Usuarios Baja', "${usuariosBaja.length}" , Icons.person_off_rounded, () => 
        Navigator.push(context,MaterialPageRoute(builder: (_) => UsariosBPageAndroid(usuarios: usuariosBaja)))),
        customResumenCard('Equipos Stock', "${equiposStock.length}" , Icons.inventory_2, (){}),
        customResumenCard('Equipos Entregados', "${equiposEnt.length}" , Icons.check_circle, (){}),
        customResumenCard('Equipos por definir', "${equiposPDefinir.length}" , Icons.pending, (){}),
        customResumenCard('Equipos dañados', "${equiposDanados.length}" , Icons.build, (){}),
        ]),
  );
}