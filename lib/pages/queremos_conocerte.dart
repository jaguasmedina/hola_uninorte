import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hola_uninorte/controllers/encuestas_controller.dart';
import 'package:hola_uninorte/controllers/navbar_controller.dart';
import 'package:hola_uninorte/pages/matricula_academica.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

// ############################################
// View para la encuesta de caracterización de
// primer ingreso
// ############################################

class QueremosConocerte extends StatelessWidget {
  QueremosConocerte({super.key});

  final encuestasController = Get.find<EncuestasController>();
  final navbarController = Get.find<NavBarController>();

  Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    final encuesta = encuestasController.encuestas["PINGRESO"];

    Widget toRender = Container();
    if (!encuesta["disponible"]) {
      toRender = noDisponible();
    } else {
      toRender = encuesta["realizado"]
          ? encuestaRealizada()
          : encuestaDisponible(encuesta["link"]);
    }

    return Container(
      color: const Color.fromRGBO(1, 172, 226, 1),
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
            )),
        child: Center(child: toRender),
      ),
    );
  }
}

// ############################################
// widget que se muestra cuando la encuesta
// está disponible
// ############################################

Widget encuestaDisponible(String url) {
  return Container(
    padding: const EdgeInsets.all(8.0),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Tu encuesta está disponible.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.yellow),
                  foregroundColor:
                      MaterialStateColor.resolveWith((states) => Colors.black),
                ),
                onPressed: () {
                  abrirEncuesta(url);
                },
                child: const Text('Iniciar encuesta',
                    style: TextStyle(fontSize: 18))),
          ),
        ],
      ),
    ),
  );
}

// ############################################
// función que abre la encuesta en el navegador
// ############################################

void abrirEncuesta(String url) async {
  if (!await launch(url)) {
    Get.snackbar("Error", 'No se pudo abrir la encuesta',
        duration: const Duration(seconds: 5));
  }
}

// ############################################
// widget que se muestra cuando la encuesta
// ya fue realizada
// ############################################

Widget encuestaRealizada() {
  return Container(
    padding: const EdgeInsets.all(8.0),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Ya realizaste esta encuesta puedes continuar al siguiente paso.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.yellow),
                  foregroundColor:
                      MaterialStateColor.resolveWith((states) => Colors.black),
                ),
                onPressed: () {
                  navBarController.openViewFromDrawer('Sube tu foto');
                },
                child: const Text('Siguiente', style: TextStyle(fontSize: 18))),
          ),
        ],
      ),
    ),
  );
}

// ############################################
// widget que se muestra cuando la encuesta
// no está disponible
// ############################################

Widget noDisponible() {
  return Container(
    padding: const EdgeInsets.all(8.0),
    child: const Center(
      child: Text(
        "Si tu encuesta no aparece disponible, escribe al correo cae@uninorte.edu.co para más información.",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
