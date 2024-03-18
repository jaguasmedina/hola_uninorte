import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/navbar_controller.dart';

// ############################################
// View para las respuestas de las preguntas
// de la sección de FAQ
// ############################################

class Respuesta extends StatelessWidget {
  Respuesta(
      {super.key,
      required this.id,
      required this.pregunta,
      required this.componentes});
  final String id;
  final String pregunta;
  final List<dynamic> componentes;

  final navBarController = NavBarController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(
                top: 50,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(50)),
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey, width: 0.0),
                    top: BorderSide(color: Colors.grey, width: 1.5),
                    left: BorderSide(color: Colors.grey, width: 0.0),
                    right: BorderSide(color: Colors.grey, width: 0.0
                        // color: Colors.black,
                        ),
                  )),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    backButton(context),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        pregunta,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Text(
                      componentes[0]["comp_content"],
                      style: const TextStyle(
                        fontSize: 16,
                      ),
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

  // ############################################
  // Widget para el botón de regresar
  // ############################################

  Row backButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 20, top: 10),
          child: InkWell(
              onTap: () => {
                    navBarController.openViewFromNavbar("Preguntas"),
                    Get.back()
                  },
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 20,
              )),
        ),
      ],
    );
  }
}
