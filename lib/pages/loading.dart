import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hola_uninorte/api_repository/login_repository.dart';
import 'package:hola_uninorte/widgets/navbar.dart';
import 'package:hola_uninorte/controllers/navbar_controller.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

// ############################################
// View para la pantalla de carga mientras se
// verifica si el usuario tiene un token
// ############################################

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  String? sessionToken;
  double _progress = 0.0;
  final navBarController = NavBarController();

  @override
  void initState() {
    super.initState();
    // _gettoken();
    _updateProgress();
  }

  // ############################################
  // Función para verificar si el usuario tiene
  // un token guardado en el dispositivo
  // ############################################

  void _updateProgress() async {
    setState(() {
      _progress += 0.2;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    sessionToken = prefs.getString('sessionToken');
    if (_progress >= 1.0) {
      if (sessionToken != null) {
        // ignore: avoid_print
        print('Token found in shared preferences');
        await loginUserWithToken(sessionToken!);
        // ignore: use_build_context_synchronously
        Get.offAll(() => NavBar(
              key: navBarController.navBarKey,
            ));
      } else {
        // ignore: avoid_print
        print('No token found in shared preferences');
        Get.off(() => const Login());
      }
    } else {
      // Si el progreso no ha llegado a 1, se espera un segundo y se llama a la función de nuevo
      Future.delayed(const Duration(seconds: 1), () {
        _updateProgress();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png', // Ruta de la imagen
                width: double.infinity, // Alto deseado para la imagen
              ),
            ],
          ),
        ),
      ),
    );
  }
}
