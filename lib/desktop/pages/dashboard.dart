import 'package:application_sop/cargas/generar_archivos.dart';
import 'package:application_sop/maps/equipos.dart';
import 'package:application_sop/maps/tech_suppor.dart';
import 'package:application_sop/maps/usuarios.dart';
import 'package:application_sop/providers/equipos_list.dart';
import 'package:application_sop/providers/tech_support_list.dart';
import 'package:application_sop/providers/usuarios_list.dart';
import 'package:application_sop/utils/colors_area.dart';
import 'package:application_sop/utils/personalizados.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Datos de ejemplo — reemplaza por datos reales de tu BD
  String value = 'Activos';
  Usuario? usuarioSeleccionado;
  String equipoV = "Stock";
  Equipo? equipoSeleccionado;

  @override
  Widget build(BuildContext context) {
    DateTime hoy = DateTime.now();
    int diaSemana = hoy.weekday;
      // Calcular lunes y viernes de la misma semana
    DateTime lunes = hoy.subtract(Duration(days: diaSemana - 1));
    DateTime viernes = hoy.add(Duration(days: 5 - diaSemana));
    
    List<Usuario> usuariosActivos = Provider.of<UsuariosListProvider>(context).users;
    List<Usuario> usuariosBaja = Provider.of<UsuariosListProvider>(context).usersBaja;
    List<Usuario> listaMostrada = value == 'Activos' ? usuariosActivos : usuariosBaja;
    List<Equipo> equiposEnt = Provider.of<EquiposListProvider>(context).eEntregados;
    List<Equipo> equiposStock = Provider.of<EquiposListProvider>(context).estock;
    List<Equipo> equiposDanados = Provider.of<EquiposListProvider>(context).edanado;
    List<Equipo> equiposPDefinir = Provider.of<EquiposListProvider>(context).eporDefinir;
    List<Equipo> otros = Provider.of<EquiposListProvider>(context).otros;

    List<Equipo> listaMostradaEquipos = equipoV == "Stock" ? equiposStock 
    : equipoV == "Entregados" ? equiposEnt 
    :  equipoV == "Dañados" ? equiposPDefinir 
    : equipoV == "PDefirnir" ? equiposDanados 
    : otros;

    TechSuppor tecnico = Provider.of<TechSupporListProvider>(context, listen: false).tecnico;



    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: Row(
        children: [
          // MAIN CONTENT
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                          Expanded(
                            flex: 6,
                            child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Buscar usuario, equipo, serie o ticket...',
                                  isDense: true,
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0), borderSide: BorderSide.none),
                                  prefixIcon: const Icon(Icons.search),
                                ),
                              ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: iconButtonCustom("Generar resguardo", Icons.picture_as_pdf, _onGenerarResguardo)),
                          //const SizedBox(width: 8),
                          //iconButtonCustom("Escanear QR", Icons.qr_code, _onEscanearQr),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // CARDS RESUMEN
                  Row(
                    children: [
                      customResumenCard('Usuarios Activos', "${usuariosActivos.length}" , Icons.person, () {}),
                      const SizedBox(width: 12),
                      customResumenCard('Usuarios Baja',"${usuariosBaja.length}", Icons.person_off, () {}),
                      const SizedBox(width: 12),
                      //customResumenCard('Cuentas 365','pendiente',Icons.account_box_rounded, () {}),
                      //const SizedBox(width: 12),
                      customResumenCard('Equipos Entregados', "${equiposEnt.length}", Icons.tv_outlined, () {}),
                      const SizedBox(width: 12),
                      customResumenCard('Equipos Stock',"${equiposStock.length}", Icons.computer_rounded, () {}),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Row(
                      children: [
                        // Izquierda
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              // Tabla usuarios equipos
                              Expanded(
                                flex: 2,
                                child: Card(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                  elevation: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(11.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text('Usuarios', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                            Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              DropdownButton<String>(
                                                value: value,
                                                items: [
                                                  DropdownMenuItem(value: 'Activos', child: Text('Activos')), 
                                                  DropdownMenuItem(value: 'Baja', child: Text('Baja'))
                                                  ],
                                                  onChanged: (String? newValue) {if (newValue == null) return; setState(() {value = newValue;});},
                                              ),
                                              SizedBox(width: 10),
                                              TextButton(onPressed: () => exportUsersToExcel(listaMostrada,value,"Generando Excel...", context), child: const Text('Exportar'))
                                            ],
                                          ),
                                        Expanded(
                                          child: SingleChildScrollView(
                                            child: DataTable(
                                              showCheckboxColumn: false,
                                              columnSpacing: 13,
                                              headingRowHeight: 20,
                                              //dividerThickness: 1,
                                              border: TableBorder.all(color: Colors.black),
                                              //showBottomBorder: true,
                                              //horizontalMargin: 5,
                                              headingRowColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {return const Color.fromARGB(255, 69, 153, 192);}),
                                              columns: const [
                                                DataColumn(label: Text('AREA')),
                                                DataColumn(label: Text("NOMBRE")),
                                                DataColumn(label: Text("APELLIDOS")),
                                                DataColumn(label: Text("EMAIL")),
                                                DataColumn(label: Text('EQUIPO')),
                                              ],
                                              rows: listaMostrada.map((e) => 
                                                  DataRow(
                                                  color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {return myColor(e.area);}),
                                                  cells: [
                                                  DataCell(Text(e.area)),
                                                  DataCell(Text(e.nombres)),
                                                  DataCell(Text(e.apellidos)),
                                                  DataCell(Text(e.correo!)),
                                                  DataCell(Text(e.snEquipo)),
                                                    ]),
                                                  ).toList(),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Tabla Tickets (resumen rápido)
                              Expanded(
                                flex: 1,
                                child: Card(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                  elevation: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(11.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Equipos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                            Text('-', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                            DropdownButton<String>(
                                                value: equipoV,
                                                items: [
                                                  DropdownMenuItem(value: 'Stock', child: Text('Stock')), 
                                                  DropdownMenuItem(value: 'Entregados', child: Text('Entregados')),
                                                  DropdownMenuItem(value: 'Dañados', child: Text('Dañados')),
                                                  DropdownMenuItem(value: 'PDefirnir', child: Text('Por definir'))
                                                  ],
                                                  onChanged: (String? newValue) {if (newValue == null) return; setState(() {equipoV = newValue;});},
                                              ),
                                          ],
                                        ),
                                        Expanded(
                                          child: SingleChildScrollView(
                                            child: DataTable(
                                              //showCheckboxColumn: false,
                                              columnSpacing: 13,
                                              headingRowHeight: 20,
                                              //dividerThickness: 1,
                                              border: TableBorder.all(color: Colors.black),
                                              //showBottomBorder: true,
                                              //horizontalMargin: 5,
                                              headingRowColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {return const Color.fromARGB(255, 69, 153, 192);}),
                                              columns: const [
                                                DataColumn(label: Text('RECEPCION')),
                                                DataColumn(label: Text('ESTADO')),
                                                DataColumn(label: Text("SEDE")),
                                                DataColumn(label: Text('TIPO')),
                                                DataColumn(label: Text("MARCA")),
                                                DataColumn(label: Text("MODELO")),
                                                DataColumn(label: Text('NS')),
                                              ],
                                              rows: listaMostradaEquipos.map((e) => 
                                                  DataRow(
                                                  color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {return myColor(e.estado!);}),
                                                  cells: [
                                                  DataCell(Text(e.recepcion!)),
                                                  DataCell(Text(e.estado!)),
                                                  DataCell(Text(e.sede!)),
                                                  DataCell(Text(e.tipo!)),
                                                  DataCell(Text(e.marca!)),
                                                  DataCell(Text(e.modelo!)),
                                                  DataCell(Text(e.numeroSerie!)),
                                                    ]),
                                                  ).toList(),
                                            )
                                            )
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        // Derecha: Insumos + Bitácora
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              Expanded(
                                child: Card(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                  elevation: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(11.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Insumos --- pendiente', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                        const Divider(),
                                        Expanded(
                                          child: ListView(
                                            children: const [
                                              ListTile(leading: Icon(Icons.usb), title: Text('Memoria USB 32GB'), trailing: Text('~')),
                                              ListTile(leading: Icon(Icons.mouse), title: Text('Mouse Inalambrico'), trailing: Text('~')),
                                              ListTile(leading: Icon(Icons.keyboard), title: Text('Teclado'), trailing: Text('~')),
                                            ],
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: myElevatedB("Ir a Insumos", (){}),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              Expanded(
                                child: Card(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                  elevation: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(11.0),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                           Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [Expanded( flex: 5, child: const Text('Bitácora semanal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))]),
                                          Row( mainAxisAlignment: MainAxisAlignment.end,
                                            children: [iconButtonCustom("Nuevo Ticket", Icons.add_box_rounded, _onNuevoTicket)]),
                                              Text("Hoy: ${myDate(hoy.toLocal())}"),
                                              const Divider(height: 20),
                                              Text("Tecnico: ${tecnico.nombres} ${tecnico.apellidos}"),
                                              const SizedBox(height: 5),
                                              Text("Correo: ${tecnico.mail}"),
                                              const SizedBox(height: 5),
                                              const Text('Semana actual:'),
                                              Text("Lunes ${myDate(lunes.toLocal())} al Viernes ${myDate(viernes.toLocal())}"),
                                             const SizedBox(height: 15),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                            children: [
                                              Expanded(
                                                flex: 4,
                                                child: iconButtonCustom("Generar bitacora", Icons.picture_as_pdf, _onGenerarBitacora)),
                                              const SizedBox(width: 15),
                                              Expanded(
                                                flex: 2,
                                                child: myElevatedB("ver bitacoras", (){}))
                                            ],
                                          )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // --- Handlers ---
  void _onGenerarResguardo() {
    // Implementa generación de PDF: toma datos del equipo/usuario y crea el resguardo
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Generando resguardo...')));
  }

  //void _onEscanearQr() {
    // Para escritorio: abrir modal para ingresar código QR manualmente
    // Para móvil: abrir lector de cámara (usa paquete qr_code_scanner o similar)
  //}

  void _onNuevoTicket() {
    // Abre modal para registrar ticket rápido
  }

  void _onGenerarBitacora() {
    // Implementa la lógica para compilar tickets de la semana y generar PDF
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Generando bitácora semanal...')));
  }
}
