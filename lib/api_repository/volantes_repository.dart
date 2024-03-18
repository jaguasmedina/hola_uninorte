import 'dart:convert';

import 'package:get/get.dart';
import 'package:hola_uninorte/controllers/volantes_controller.dart';
import 'package:hola_uninorte/models/volante_model.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

// Controlador para los datos de los volantes
final volantesController = Get.put(VolantesDataController());

// Instancia del logger
final Logger logger = Logger();

// ##############################################
// Función para obtener los volantes de pago
// del usuario

// apiUrl: URL del servidor
// codigo: código universitario del usuario
// ##############################################

Future<void> volantesRepository(String apiUrl, String codigo) async {
  // Obtener volantes del usuario
  try {
    // Llamar al servidor
    var url = Uri.parse('$apiUrl/volantes/user/$codigo');
    var response = await http.post(url);

    if (response.statusCode == 200) {
      // Decodificar la respuesta
      var responseData = response.body;
      var responseJson = await jsonDecode(responseData);

      if (responseJson["status"] == 200) {
        final status = responseJson['status'];
        final total = responseJson['total'];
        final pendientes = responseJson['pendientes'];
        final volantes = responseJson['volantes'];
        final periodo = responseJson['periodo'];
        final codigo = responseJson['codigo'];

        // guardar la información de los volantes del usuario en el controlador
        volantesController.saveVolante(Volante(
            status: status,
            total: total,
            pendientes: pendientes,
            volantes: volantes,
            periodo: periodo,
            codigo: codigo));
      } else {
        throw Exception(
            'Error al realizar la consulta, por favor intente más tarde.');
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
