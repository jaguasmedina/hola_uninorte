import 'dart:convert';

import 'package:get/get.dart';
import 'package:hola_uninorte/controllers/matriculas_controller.dart';
import 'package:hola_uninorte/models/matricula_model.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

// Controlador para los datos de las matriculas
final matriculaController = Get.put(MatriculaDataController());

// Instancia del logger para imprimir mensajes en consola
final Logger logger = Logger();

// #########################################
// Función para verificar si el usuario
// está matriculado

// apiUrl: URL del servidor
// codigo: código universitario del usuario
// #########################################

Future<void> matriculaRepository(String apiUrl, String? codigo) async {
  try {
    // Llamar al servidor
    var url = Uri.parse('$apiUrl/usuarios/matricula/$codigo');
    var response = await http.post(url);
    if (response.statusCode == 200) {
      var responseData = response.body;

      var responseJson = await jsonDecode(responseData);

      // guardar la información de la matricula del usuario
      if (responseJson["status"] == 200 && responseJson["matriculado"] == "S") {
        final status = responseJson['status'];
        final matriculado = responseJson['matriculado'];
        final horario = responseJson['horario'];

        // guardar la información de la matricula del usuario en el controlador
        matriculaController.saveMatricula(Matricula(
          status: status,
          matriculado: matriculado,
          aceptado: true,
          horario: horario,
        ));
      }
    } else {
      throw Exception(
          'Error al realizar la consulta, por favor intente más tarde.');
    }
  } catch (e) {
    throw Exception(
        'Error al realizar la consulta, por favor intente más tarde.');
  }
}
