
import 'package:application_sop/desktop/pages/dashboard_desktop.dart';
import 'package:application_sop/desktop/pages/equipos.dart';
import 'package:application_sop/desktop/pages/usuarios.dart';
import 'package:application_sop/maps/maps.dart';
import 'package:application_sop/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GestionTIHome extends StatefulWidget {
  const GestionTIHome({super.key});

  @override
  State<GestionTIHome> createState() => _GestionTIHomeState();
}

class _GestionTIHomeState extends State<GestionTIHome> {
 
  @override
  void initState() {
    super.initState();
    Provider.of<UsuariosListProvider>(context, listen: false).loadusers();
    Provider.of<EquiposListProvider>(context, listen: false).loadEquipos();
    Provider.of<CatalogosListProvider>(context, listen: false).loadCatalogos();
    Provider.of<CatalogosEquiposListProvider>(context, listen: false).loadCatalogosEqipos();
  }

  int selectedIndex = 0;

  final List<Widget> pages = [
    DashboardDesktop(),
    UsuariosPage(),
    EquiposPage(),
    Center(child: Text("Insumos", style: TextStyle(fontSize: 24))),
    Center(child: Text("Archivos", style: TextStyle(fontSize: 24))),
    Center(child: Text("Bitácoras", style: TextStyle(fontSize: 24))),
    Center(child: Text("Admin tecnicos", style: TextStyle(fontSize: 24))),
    Center(child: Text("Configuración", style: TextStyle(fontSize: 24))),
  ];

  @override
  Widget build(BuildContext context) {
    
    TechSuppor tecnico = Provider.of<TechSupporListProvider>(context, listen: false).tecnico;
    
    return Scaffold(
        body: Row(
          children: [
            /// ---------------- Sidebar ----------------
            Container(
              width: 190,
              color: Color(0xFF111827),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text("Gestión TI",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  const SizedBox(height: 40),
                  /// Menú lateral
                  Expanded(
                    child: ListView(
                      children: [
                        _menuItem(Icons.dashboard, "Dashboard", 0),
                        _menuItem(Icons.person, "Usuarios", 1),
                        _menuItem(Icons.laptop, "Equipos", 2),
                        _menuItem(Icons.memory, "Insumos", 3),
                        _menuItem(Icons.picture_as_pdf, "Archivos", 4),
                        _menuItem(Icons.list_alt, "Bitácoras", 5),
                        tecnico.rol == "admin" ? _menuItem(Icons.admin_panel_settings, "Admin", 6) : Container()
                      ],
                    ),
                  ),
                        const Divider(color: Colors.white24),
                        _menuItem(Icons.settings, "Configuración", 7),
                        _menuItem(Icons.exit_to_app, "Salir", 99),
                        const SizedBox(height: 20),
                        Text("Version 1.0.0.5", style: TextStyle(color: Colors.white54),),
                        const SizedBox(height: 10),
                ],
              ),
            ),
      
            /// ---------------- Contenido dinámico ----------------
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: pages[selectedIndex],
              ),
            ),
          ],
        ),
    );
  }

  Widget _menuItem(IconData icon, String title, int index) {
    final bool isSelected = selectedIndex == index;
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.white : Colors.white54),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white70,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: Colors.white10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () {
        if (index == 99) {
          //TODO: Acción de salir
          return;
        }
        setState(() {
          selectedIndex = index;
        });
      },
    );
  }
}