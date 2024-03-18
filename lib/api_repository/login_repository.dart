import 'dart:convert';

import 'package:get/get.dart';
import 'package:hola_uninorte/api_repository/matricula_repository.dart';
import 'package:hola_uninorte/api_repository/volantes_repository.dart';
import 'package:hola_uninorte/controllers/encuestas_controller.dart';
import 'package:hola_uninorte/controllers/faq_controller.dart';
import 'package:hola_uninorte/controllers/user_data_controller.dart';
import 'package:hola_uninorte/models/faq_model.dart';
import 'package:hola_uninorte/models/person_model.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

// URL del servidor
const apiURL = 'https://guayacan02.uninorte.edu.co/1nducc10n_v1rtu4l/api';

// Controlador para los datos del usuario
final userDataController = Get.put(UserDataController());

// Controlador para los datos de las preguntas
final faqController = Get.put(FaqController());

// Controlador para las encuestas
final encuestasController = Get.put(EncuestasController());

// Instancia del logger para imprimir mensajes en consola
final Logger logger = Logger();

// Mensajes de error
const String sigInputEmpty =
    'El usuario o código de acceso ingresado no es válido, por favor verifique e intente nuevamente.';
const String sigUsPwInvalid =
    'El usuario o código de acceso ingresado no es válido, por favor verifique e intente nuevamente.';
const String sigLogError =
    'Error al iniciar sesión, por favor intente más tarde.';

//#########################################
// Función para verificar si el usuario
// existe en la base de datos

// username: correo personal del usuario
// password: código de acceso del usuario
//#########################################

Future<void> loginUser(String username, String password) async {
  const url = '$apiURL/usuarios/login';
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode({'user': username, 'pass': password});
  if (username.isNotEmpty && password.isNotEmpty) {
    try {
      // Llamar al servidor
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      // función para guardar la información del usuario
      await saveInfoUSer(response);
    } catch (e) {
      // Lanzar la excepción original sin modificar
      throw Exception(sigLogError);
    }
  } else {
    throw Exception(sigInputEmpty);
  }
}

//#####################################################
// Función para verificar si el usuario ya está
// logueado

// token: token de acceso del usuario asignado por
// el servidor cuando se inicia sesión por primera vez
//#####################################################

Future<void> loginUserWithToken(String token) async {
  const url = '$apiURL/usuarios/login';
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode({'token': token});

  try {
    if (token.isNotEmpty) {
      // Llamar al servidor
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);

      // función para guardar la información del usuario
      await saveInfoUSer(response);
    } else {
      throw Exception(sigInputEmpty);
    }
  } catch (e) {
    // Lanzar la excepción original sin modificar
    throw Exception(sigLogError);
  }
}

//################################################
// Función para guardar la información del usuario
// dependiendo la respuesta del servidor

// response: respuesta del servidor
//################################################

saveInfoUSer(response) async {
  var responseJson = await jsonDecode(response.body);
  if (response.statusCode == 200) {
    final token = responseJson['USER']['token'];
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sessionToken', token);

    // Guardar datos del usuario en el controlador de usuario
    final user = responseJson['USER']['user'];
    final nombreCompleto = responseJson['USER']['nombre_completo'];
    final email = responseJson['USER']['correo'];
    final programa = responseJson['USER']['programa'];
    final documento = responseJson['USER']['documento'];
    final codigo = responseJson['USER']['codigo'];
    final pidm = responseJson['USER']['pidm'];

    // se elimina el resultado de las etapas 2 y 5 mientras se actualiza la respuesta del servidor
    final etapasResponse = responseJson['USER']['etapas'];
    int posicion1 = 2;
    int posicion2 = 5;

    etapasResponse.removeAt(posicion1);
    etapasResponse.removeAt(posicion2);

    final etapas = etapasResponse;
    final puntosMap = responseJson['MAP'];

    userDataController.savePerson(Person(
        token: token,
        nombre: nombreCompleto[0] + " " + nombreCompleto[2],
        nombreCompleto: nombreCompleto,
        user: user,
        email: email,
        documento: documento,
        codigo: codigo,
        pidm: pidm,
        iniciales: nombreCompleto[0][0] + nombreCompleto[2][0],
        programa: programa,
        etapas: etapas,
        puntosMapa: puntosMap));

    // Guardar datos de las preguntas en el controlador de preguntas
    final preguntas = responseJson['FAQ'];
    faqController.saveFAQ(FAQ(preguntas: preguntas));

    //Guardar datos de las encuestas en el controlador de encuestas
    final encuestas = responseJson['ENCUESTAS'];
    encuestasController.saveEncuestas(encuestas);

    // volantes del usuario
    try {
      await volantesRepository(apiURL, codigo);
    } catch (e) {
      throw Exception(sigLogError);
    }

    // Matricula del usuario
    try {
      await matriculaRepository(apiURL, codigo);
    } catch (e) {
      throw Exception(sigLogError);
    }

    if (responseJson["status"] == 200) {
      // Iniciar sesión exitosamente
    } else {
      throw Exception(sigUsPwInvalid);
    }
  } else {
    throw Exception(sigLogError);
  }
}
