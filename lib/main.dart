
import 'package:application_sop/pages/pre_login.dart';
import 'package:application_sop/providers/365_list.dart';
import 'package:application_sop/providers/equipos_list.dart';
import 'package:application_sop/providers/general_list.dart';
import 'package:application_sop/providers/tech_support_list.dart';
import 'package:application_sop/providers/usuarios_list.dart';
import 'package:application_sop/services/logger.dart';
import 'package:application_sop/services/share_preferences.dart';
import 'package:application_sop/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.init();
  await LoggerService.init();
  await SocketService().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

 const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TechSupporListProvider()),
       ChangeNotifierProvider(create: (_) => UsuariosListProvider()),
       ChangeNotifierProvider(create: (_) => EquiposListProvider()),
       ChangeNotifierProvider(create: (_) => CatalogosListProvider()),
       ChangeNotifierProvider(create: (_) => C365Listproviders()),
      ],
      child: MaterialApp(
          title: 'Gestión TI',
          theme: ThemeData(primarySwatch: Colors.blue),
          supportedLocales: const [
            Locale('es', 'ES'), // Español
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: Locale('es', 'ES'),
          home: PreLogin(),
          debugShowCheckedModeBanner: false,
      ),
    );
  }
}
