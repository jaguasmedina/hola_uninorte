import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hola_uninorte/controllers/matriculas_controller.dart';
import 'package:hola_uninorte/controllers/user_data_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api_repository/matricula_repository.dart';
import '../controllers/navbar_controller.dart';

// ############################################
// View para la pantalla de matrícula académica
// ############################################

final matriculaController = Get.find<MatriculaDataController>();
final userDataController = Get.find<UserDataController>();
final navBarController = NavBarController();

// url de la api
const apiURL = 'https://guayacan02.uninorte.edu.co/1nducc10n_v1rtu4l/api';

class MatriculaAcademica extends StatelessWidget {
  const MatriculaAcademica({super.key});

  @override
  Widget build(BuildContext context) {
    bool aceptado = matriculaController.matricula.aceptado;

    return Container(
      color: const Color.fromRGBO(1, 172, 226, 1),
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
            )),
        // Si el usuario ya está matriculado, se muestra el calendario y si no, se muestra el panel de espera
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  child: aceptado ? renderMatricula() : renderEspera(context)),
            ],
          ),
        ),
      ),
    );
  }

  // ############################################
  // Renderiza el panel de información del
  // estudiante
  // ############################################

  Container renderMatricula() {
    final programa = userDataController.person.programa;
    final nombre = userDataController.person.nombre;
    final codigo = userDataController.person.codigo;

    return Container(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            programPanel(programa, nombre, codigo),
          ],
        ),
      ),
    );
  }

  // ############################################
  // Renderiza el panel con la información de la
  // matrícula del estudiante
  // ############################################

  Container programPanel(programa, nombre, codigo) {
    var materias = matriculaController.matricula.horario;
    return Container(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              programa,
              style: const TextStyle(
                fontSize: 30,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              nombre,
              style: const TextStyle(fontSize: 22, color: Colors.blue),
            ),
            Text(
              "Código: $codigo",
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 40),
              child: Text(
                "Asignaturas",
                style: TextStyle(
                    fontSize: 32,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Column(
              children: [
                for (int index = 0; index < materias!.length; index++)
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 10.0),
                    child: Row(
                      children: [
                        Text(
                          '${index + 1}.',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                materias[index]["MATERIA"],
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "NRC: ${materias[index]["NRC"]}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // ############################################
  // Renderiza el panel de espera en caso de que
  // el estudiante no esté matriculado
  // ############################################

  Container renderEspera(context) {
    final programa = userDataController.person.programa;
    return Container(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            pendingPanel(programa),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.yellow),
                  foregroundColor:
                      MaterialStateColor.resolveWith((states) => Colors.black),
                ),
                onPressed: () {
                  handleCalendario();
                },
                child: const Text('Consultar el calendario')),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.yellow),
                  foregroundColor:
                      MaterialStateColor.resolveWith((states) => Colors.black),
                ),
                onPressed: () {
                  checkMatricula(context);
                },
                child: const Text('Consultar de nuevo')),
          ],
        ),
      ),
    );
  }

  // ############################################
  // Muestra información para el estudiante
  // en espera
  // ############################################

  Container pendingPanel(programa) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Estado: Pendiente',
              style: TextStyle(
                fontSize: 22,
                color: Colors.blue,
              ),
            ),
            Text(
              programa,
              style: const TextStyle(
                fontSize: 22,
                color: Colors.blue,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                "Su matrícula académica se realiza conforme a las fechas establecidas en el calendario académico.\n\nPara más información:",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      );
}

// ############################################
// Funcion que consulta la matricula del
// estudiante
// ############################################

void checkMatricula(context) async {
  try {
    await matriculaRepository(apiURL, userDataController.person.codigo);
  } catch (e) {
    Get.snackbar(
        "Error", "Error al realizar la consulta, por favor intente más tarde.",
        icon: const Icon(
          Icons.error_outline,
          color: Color.fromRGBO(173, 0, 0, 1),
        ),
        backgroundColor: Colors.white.withOpacity(0.5),
        duration: const Duration(seconds: 5));
  }
}

// ############################################
// Funcion que abre el calendario academico
// en la web de la universidad
// ############################################

void handleCalendario() async {
  const urlCalendario =
      'https://www.uninorte.edu.co/web/eventos/calendario-academico';
  if (!await launch(Uri.parse(urlCalendario).toString())) {
    throw Exception('Could not launch $urlCalendario');
  }
}
