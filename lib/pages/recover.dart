// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hola_uninorte/pages/login.dart';
import 'package:hola_uninorte/controllers/navbar_controller.dart';
import 'package:http/http.dart' as http;

// ##########################################################
//  Este archivo contiene el código de la página de
//  recuperación de contraseña.
// ##########################################################

// URL del servidor
const apiURL = 'https://guayacan02.uninorte.edu.co/1nducc10n_v1rtu4l/api';

class Recover extends StatefulWidget {
  const Recover({super.key});

  @override
  State<Recover> createState() => _RecoverState();
}

class _RecoverState extends State<Recover> {
  final TextEditingController _usuarioController =
      TextEditingController(text: '');
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
                        'Se le enviará un nuevo código de acceso a la cuenta de correo registrada.',
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
                                        color: Colors.yellow,
                                        fontSize:
                                            16), // Cambiar el color del texto

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
                                SizedBox(
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 22.0),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        // esta es la función que se ejecuta al presionar el botón
                                        try {
                                          // Se obtienen los valores de los campos de texto
                                          final usuario =
                                              _usuarioController.text;
                                          if (usuario != '') {
                                            await recoverCode(usuario);
                                          } else {
                                            Get.snackbar("Acceso invalido",
                                                "El usuario ingresado no es válido, por favor verifique e intente de nuevo.",
                                                icon: const Icon(
                                                  Icons.error_outline,
                                                  color: Color.fromRGBO(
                                                      173, 0, 0, 1),
                                                ),
                                                backgroundColor: Colors.white
                                                    .withOpacity(0.5),
                                                duration:
                                                    const Duration(seconds: 5));
                                          }
                                        } catch (e) {
                                          // Si ocurre un error se muestra una notificación
                                          Get.snackbar("Error", e.toString(),
                                              icon: const Icon(
                                                Icons.error_outline,
                                                color: Color.fromRGBO(
                                                    173, 0, 0, 1),
                                              ),
                                              backgroundColor:
                                                  Colors.white.withOpacity(0.5),
                                              duration:
                                                  const Duration(seconds: 5));
                                        }
                                      },
                                      style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.black),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.yellow),
                                      ),
                                      child: const Text('RECUPERAR'),
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
                        // Navegar a la siguiente pantalla
                        Get.offAll(() => const Login());
                      },
                      child: const Text('Iniciar sesión',
                          style: TextStyle(
                            fontSize: 16,
                          )),
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
}

//######################################################
//  Recuperación de pin
//  Se envia un correo al email registrado del usuario
//  con un nuevo PIN de 5 numeros
//######################################################

recoverCode(String usuario) async {
  try {
    var params = jsonEncode({
      'usuario': usuario,
    });
    http.Response response = await http.post(
      Uri.parse('$apiURL/usuarios/recover'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: params,
    );
    if (response.statusCode == 200) {
      String responseText = response.body;
      var responseJson = jsonDecode(responseText);
      if (responseJson["status"] == 200) {
        Get.snackbar("Solicitud enviada",
            "Hemos enviado un nuevo código de acceso a tu correo registrado.",
            icon: const Icon(
              Icons.check_circle_outline,
              color: Color.fromRGBO(0, 173, 0, 1),
            ),
            backgroundColor: Colors.white.withOpacity(0.5),
            duration: const Duration(seconds: 5));
      } else {
        Get.snackbar("Acceso invalido",
            "El usuario ingresado no es válido, por favor verifique e intente de nuevo.",
            icon: const Icon(
              Icons.error_outline,
              color: Color.fromRGBO(173, 0, 0, 1),
            ),
            backgroundColor: Colors.white.withOpacity(0.5),
            duration: const Duration(seconds: 5));
      }
    } else {
      Get.snackbar("Error",
          "Error al realizar la solicitud, por favor intente más tarde.",
          icon: const Icon(
            Icons.error_outline,
            color: Color.fromRGBO(173, 0, 0, 1),
          ),
          backgroundColor: Colors.white.withOpacity(0.5),
          duration: const Duration(seconds: 5));
    }
  } catch (e) {
    Get.snackbar(
        "Error", "Error al realizar la solicitud, por favor intente más tarde.",
        icon: const Icon(
          Icons.error_outline,
          color: Color.fromRGBO(173, 0, 0, 1),
        ),
        backgroundColor: Colors.white.withOpacity(0.5),
        duration: const Duration(seconds: 5));
  }
}
