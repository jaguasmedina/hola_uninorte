// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:hola_uninorte/api_repository/login_repository.dart';
import 'package:hola_uninorte/pages/recover.dart';
import 'package:hola_uninorte/widgets/navbar.dart';
import 'package:hola_uninorte/controllers/navbar_controller.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

// ##########################################################
// Esta pantalla es la encargada de realizar el login del
// usuario, para ello se utiliza un formulario con dos
// campos de texto, uno para el correo y otro para el
// código de acceso. Al presionar el botón de entrar se
// realiza la petición al API y se guarda el token en el
// almacenamiento local del dispositivo.
// ##########################################################

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _codigoAccesoController = TextEditingController();
  final navBarController = NavBarController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Color.fromRGBO(1, 172, 226, 1)
            ], // Colores del degradado
            begin: Alignment(
                0.0, 0.0), // Punto de inicio del degradado (parte inferior)
            end: Alignment(
                0.0, 0.1), // Punto de final del degradado (parte superior)
          ),
        ),
        child: ListView(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(
                40,
              ),
              child: Image.asset('assets/images/logo.png'),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(1, 172, 226, 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                ),
              ),
              child: Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                        top: 40,
                        bottom: 0,
                        right: 55,
                        left: 55,
                      ),
                      child: const Text(
                        'Todo lo que necesitas para tu ingreso a Uninorte',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 0,
                        right: 50,
                        left: 50,
                      ),
                      child: Column(
                        children: [
                          Form(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                TextFormField(
                                  controller: _usuarioController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Usuario',
                                    labelStyle: TextStyle(
                                        color: Colors
                                            .yellow), // Cambiar el color del texto
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .yellow), // Cambiar el color de la línea cuando el campo no está enfocado
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .yellow), // Cambiar el color de la línea cuando el campo está enfocado
                                    ),
                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor ingrese su usuario';
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  controller: _codigoAccesoController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Código de acceso',
                                    labelStyle: TextStyle(
                                        color: Colors
                                            .yellow), // Cambiar el color del texto
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .yellow), // Cambiar el color de la línea cuando el campo no está enfocado
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .yellow), // Cambiar el color de la línea cuando el campo está enfocado
                                    ),
                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor ingrese su código de acceso';
                                    }
                                    return null;
                                  },
                                  obscureText: true,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 22.0),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        await runProccess();
                                      },
                                      style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.black),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.yellow),
                                      ),
                                      child: const Text('¡ENTRAR!'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.yellow),
                      ),
                      onPressed: () {
                        // navegar a la pantalla de recuperar código de acceso
                        Get.to(() => const Recover());
                      },
                      child: const Text('Recuperar  código de acceso'),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.yellow),
                      ),
                      onPressed: () {
                        handleAyuda();
                      },
                      child: const Text('¿Cómo puedo ingresar a la APP?'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> handleAyuda() async {
    const url =
        'https://www.uninorte.edu.co/web/bienestar-universitario-2/como-ingresar-a-la-app';
    if (!await launch(url.toString())) {
      Get.snackbar("Error", "No se pudo abrir el enlace en el navegador",
          duration: const Duration(seconds: 5));
    }
  }

  runProccess() async {
    // esta es la función que se ejecuta al presionar el botón
    try {
      // Se obtienen los valores de los campos de texto
      final usuario = _usuarioController.text;
      final codigoAcceso = _codigoAccesoController.text;

      // Indicar que se está cargando

      showLoadingDialog(context: context);

      // Se realiza la petición al API por medio del repositorio del usuario
      await loginUser(usuario, codigoAcceso);
      // ignore: use_build_context_synchronously
      Get.offAll(() => NavBar(
            key: navBarController.navBarKey,
          ));
    } catch (e) {
      // Si ocurre un error se muestra una notificación
      Get.back();
      Get.snackbar("Error", e.toString(),
          icon: const Icon(
            Icons.error_outline,
            color: Color.fromRGBO(173, 0, 0, 1),
          ),
          backgroundColor: Colors.white.withOpacity(0.5),
          duration: const Duration(seconds: 5));
    }
  }
}

Future<void> showLoadingDialog({
  required BuildContext context,
}) async {
  await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: loadingWidget()));
}

Widget loadingWidget() {
  return const AlertDialog(
    backgroundColor: Colors.transparent,
    elevation: 0,
    content: Center(
      child: SpinKitThreeBounce(
        color: Colors.white,
        size: 30.0,
      ),
    ),
  );
}
