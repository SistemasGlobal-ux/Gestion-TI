
import 'package:application_sop/desktop/pages/home.dart';
import 'package:application_sop/pages/login.dart';
import 'package:application_sop/providers/tech_support_list.dart';
import 'package:application_sop/services/share_preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PreLogin extends StatelessWidget {
  const PreLogin({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: checkLoginState(context),
            builder: (context, snapshot) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 250),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text("Cargando...",
                              style:
                                  TextStyle(fontSize: 27, color: Colors.blue)),
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('Estamos validando tus datos',
                              style: TextStyle(fontSize: 12)),
                        ]),
                    const SizedBox(height: 270),
                  ]);
            }));
  }

Future checkLoginState(BuildContext context) async {
  if (Preferences.token.isNotEmpty) {
    await Provider.of<TechSupporListProvider>(context, listen: false)
        .loadTecnico(Preferences.token);
    // Ejecutar después del build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => GestionTIHome(),
          transitionDuration: const Duration(milliseconds: 0),
        ),
      );
    });
  } else {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => LoginPage(),
          transitionDuration: const Duration(milliseconds: 0),
        ),
      );
    });
  }
}

}