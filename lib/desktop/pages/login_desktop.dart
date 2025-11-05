// ignore_for_file: use_build_context_synchronously

import 'package:application_sop/desktop/pages/home.dart';
import 'package:application_sop/providers/tech_support_list.dart';
import 'package:application_sop/services/share_preferences.dart';
import 'package:application_sop/utils/personalizados.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPageDesktop extends StatefulWidget {
   const LoginPageDesktop({super.key});

  @override
  State<LoginPageDesktop> createState() => _LoginPageDesktopState();
}

class _LoginPageDesktopState extends State<LoginPageDesktop> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  bool mantenerSesion = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Panel izquierdo (Logo / Branding)
          Expanded(
            flex: 2,
            child: Container(
              color: const Color(0xFF1E73BE), // Azul corporativo
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.person_pin,
                      size: 100,
                      color: Colors.white,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'TECH SUPPORT',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Panel derecho (Formulario)
          Expanded(
            flex: 3,
            child: Center(
              child: SizedBox(
                width: 350,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Iniciar sesión',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Campo Email
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Correo electrónico',
                        hintText: 'tu.correo@empresa.com',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),

                    // Campo Password
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    CheckboxListTile(
                    title: Text("Mantener sesión iniciada"),
                    value: mantenerSesion,
                    onChanged: (bool? value) {
                       setState(() {
                         mantenerSesion = value!;
                       });
                      },
                     ),
                    const SizedBox(height: 25),
                    // Botón Iniciar Sesión
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E73BE),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async{
                          dialogo(context, "Validando datos...");
                          final mail = _emailController.text.trim();
                          final psw = _passwordController.text.trim();
                          final token = await Provider.of<TechSupporListProvider>(context, listen: false).checkTecnico(mail, psw);
                          if (token["status"] == true) {
                           await Provider.of<TechSupporListProvider>(context, listen: false).loadTecnico(token["response"]);
                           mantenerSesion == true ? Preferences.token = token["response"] : null;
                           Navigator.pop(context);
                          Navigator.pushReplacement(context, PageRouteBuilder( pageBuilder: (_, __, ___) => GestionTIHome(),transitionDuration: const Duration(milliseconds: 0)));
                          }else{
                            await Future.delayed(Duration(seconds: 1));
                            Navigator.pop(context);
                            dialogoError(context, token["response"]);
                            await Future.delayed(Duration(seconds: 1));
                            Navigator.pop(context);
                          }
                          },
                        child: const Text(
                          'Iniciar sesión',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Olvidaste contraseña (solo visual)
                    Center(
                      child: TextButton(
                        onPressed: () {
                          // Navegar a recuperación si deseas en el futuro
                        },
                        child: const Text(
                          '¿Olvidaste tu contraseña?',
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
