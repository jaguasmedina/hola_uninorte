// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously, deprecated_member_use

import 'dart:convert';
import 'dart:io';

import 'package:bulleted_list/bulleted_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hola_uninorte/controllers/navbar_controller.dart';
import 'package:hola_uninorte/controllers/photo_controller.dart';
import 'package:hola_uninorte/controllers/user_data_controller.dart';
import 'package:hola_uninorte/models/photo_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:mime/mime.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// instancia de los controladores
final userDataController = Get.find<UserDataController>();
final photoController = Get.find<PhotoController>();
final navBarController = Get.find<NavBarController>();

// instancia del logger para imprimir logs en consola
Logger logger = Logger();

const apiURL = 'https://hala.uninorte.edu.co/cargar_foto';

// ignore: must_be_immutable
class SubirFoto extends StatefulWidget {
  const SubirFoto({super.key});

  @override
  State<SubirFoto> createState() => _SubirFotoState();
}

class _SubirFotoState extends State<SubirFoto> {
  var pendiente;
  var fecha;
  bool isLoading = true;

  // se inicializa el estado y se llama a
  // la función getPhoto() para obtener la
  // foto actual del usuario.

  @override
  void initState() {
    super.initState();
    pendiente = "No registra";
    getPhoto();
    // consultPermission();
  }

  // se obtiene la foto actual del usuario haciendo
  // una petición a la API de Hala.
  void getPhoto() async {
    await consultarPendiente(
        userDataController.person.documento, userDataController.person.email);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      final carnet = {
        "nombres":
            "${userDataController.person.nombreCompleto?[0]} ${userDataController.person.nombreCompleto?[1]}",
        "apellidos": userDataController.person.nombreCompleto?[2],
        "codigo": userDataController.person.codigo,
        "photo": photoController.picture.url?.replaceAll("http:/", "https:/"),
      };
      return Container(
          color: const Color.fromRGBO(1, 172, 226, 1),
          child: Center(
            child: ListView(
              children: [
                const Text(
                  'Tu carné Uninorte ahora digital',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  'Esta será la foto que te identificará en Uninorte',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 10),
                  child: Text(
                    "Para seleccionar la foto presiona aquí 👇",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.yellow,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                carnet["photo"] != null
                    ? cardFrame(carnet)
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const Text("Loading...",
                                textAlign: TextAlign.center),
                            Text(carnet["photo"]),
                          ],
                        ),
                      ),
                renderPanelCarnet(),
              ],
            ),
          ));
    }
  }

  // ######################################
  // Widget que muestra la foto del
  // usuario, su nombre, apellidos y código.
  // ######################################

  Widget cardFrame(Map carnet) => Center(
        child: Column(children: [
          InkWell(
            onTap: () {
              selectFromGallery();
            },
            child: carnet["photo"] != ""
                ? Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Image.network(
                      carnet["photo"],
                      width: 250,
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 150,
                    )),
          ),
          Text(carnet["nombres"],
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(carnet["apellidos"],
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text("CIU# ${carnet["codigo"]}",
              style: const TextStyle(fontSize: 20)),
        ]),
      );

  // #############################################
  // Función que realiza una consulta a una API
  // para obtener información sobre el estado de
  // la foto del usuario.
  // #############################################

  Future<void> consultarPendiente(String? documento, String? correo) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final photoController = Get.put(PhotoController());

    if (documento != "" && correo != "") {
      try {
        // const url = '$apiURL/modulo_induccion/ind_consulta.php';
        // final headers = {'Content-Type': 'application/json'};
        // final body = jsonEncode({'documento': documento, 'correo': correo});

        // final response =
        //     await http.post(Uri.parse(url), headers: headers, body: body);

        var request = http.MultipartRequest(
            'POST', Uri.parse('$apiURL/modulo_induccion/ind_consulta.php'));

        request.fields.addAll({
          'correo': correo!,
          'documento': documento!,
        });

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          var responseJson = jsonDecode(await response.stream.bytesToString());
          var estado = responseJson['estado'];
          var asignado = responseJson['asignado'];

          var foto = responseJson['result'] != null
              ? responseJson['result']['foto']
              : null;
          var fechaEnvio = responseJson['result'] != null
              ? responseJson['result']['fecha_envio']
              : null;

          if (estado == "Pendiente" || estado == "Aceptada") {
            setState(() {
              pendiente = estado ?? "No registra";

              fecha = fechaEnvio;
            });
            photoController.savePhoto(
              Photo(url: foto, type: null, name: ""),
            );
            if (responseJson['asignado'] > 0 &&
                responseJson['estado'] == "Aceptada") {
              prefs.setString(
                  '@aceptedPhoto${userDataController.person.codigo}', foto);
            }
            var urlPhoto = Uri.parse(
                'https://guayacan02.uninorte.edu.co/1nducc10n_v1rtu4l/api/usuarios/photo/${userDataController.person.codigo}');
            var responsePhoto = await http.post(urlPhoto);
            prefs.setString(
                '@photoSent${userDataController.person.codigo}', "true");
          } else {
            prefs.setString(
                '@aceptedPhoto${userDataController.person.codigo}', "");
            prefs.setString(
                '@photoSent${userDataController.person.codigo}', "");
            setState(() {
              pendiente = "No registra";
              fecha = null;
            });
          }
        } else {
          Get.snackbar("Error",
              "Error al realizar la consulta, por favor intente más tarde. 1",
              icon: const Icon(
                Icons.error_outline,
                color: Color.fromRGBO(173, 0, 0, 1),
              ),
              backgroundColor: Colors.white.withOpacity(0.5),
              duration: const Duration(seconds: 5));
        }
      } catch (e) {
        Get.snackbar(
          "Error",
          "Error al realizar la consulta, por favor intente más tarde. 2",
          icon: const Icon(
            Icons.error_outline,
            color: Color.fromRGBO(173, 0, 0, 1),
          ),
          duration: const Duration(seconds: 5),
          backgroundColor: Colors.white.withOpacity(0.5),
        );
      }
    } else {
      Get.snackbar("Error",
          "Error al realizar la consulta, por favor intente más tarde. 3",
          icon: const Icon(
            Icons.error_outline,
            color: Color.fromRGBO(173, 0, 0, 1),
          ),
          backgroundColor: Colors.white.withOpacity(0.5),
          duration: const Duration(seconds: 5));
    }
  }

  // #############################################
  // Función que muestra un panel con información
  // sobre el estado de la foto del usuario.
  // #############################################

  Widget renderPanelCarnet() {
    var pendingMessage =
        "Tu foto se encuentra en proceso de revisión desde el día $fecha";
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: pendiente == "Pendiente"
            ? Column(
                children: [
                  Text("Estado: $pendiente",
                      style:
                          const TextStyle(fontSize: 18, color: Colors.white)),
                  Text(
                    pendingMessage,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const Text(
                      "Cuando sea procesada, le será notificado por correo y podrá subir otra foto.",
                      style: TextStyle(fontSize: 18)),
                  ElevatedButton(
                      onPressed: () {
                        navBarController
                            .openViewFromDrawer("Nuestros servicios para ti");
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromRGBO(255, 233, 59, 1)),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.black)),
                      child: const Text("Siguiente")),
                ],
              )
            : Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        Text("Estado: $pendiente",
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white)),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(
                              "Si deseas subir o cambiar la foto, recuerda tener en cuenta que:",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.yellow,
                                  fontWeight: FontWeight.bold)),
                        ),
                        const BulletedList(
                          bullet: Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                          listItems: [
                            'Debe ser a color, tipo documento, fondo blanco y formato JPG o PNG.',
                            'El día de tu inducción recibirás las credenciales Uninorte para acceder a tu carné digital.',
                          ],
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        const Text(
                          "Descarga la app ID UNINORTE en:",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Platform.isAndroid
                            ? ElevatedButton(
                                onPressed: () {
                                  androidStore();
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.transparent),
                                  shadowColor: MaterialStateProperty.all<Color>(
                                      const Color.fromRGBO(1, 172, 226, 1)),
                                  elevation:
                                      MaterialStateProperty.all<double>(0),
                                ),
                                child: Image.asset(
                                    'assets/images/google_badge.png',
                                    width: 230),
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  iosStore();
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.transparent),
                                  shadowColor: MaterialStateProperty.all<Color>(
                                      const Color.fromRGBO(1, 172, 226, 1)),
                                  elevation:
                                      MaterialStateProperty.all<double>(0),
                                ),
                                child: Image.asset(
                                    'assets/images/apple_badge.png',
                                    width: 230),
                              ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: ElevatedButton(
                        onPressed: () {
                          uploadPhoto();
                        },
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromRGBO(255, 233, 59, 1)),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.upgrade_rounded),
                            Text('Subir'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ));
  }

  // #######################################
  // Función que redirecciona a la tienda
  // de aplicaciones de Android
  // #######################################

  void androidStore() async {
    const url =
        'https://play.google.com/store/apps/details?id=com.identidaddigital&hl=es_CO&gl=US';
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      await launch(url.toString());
    } else {
      Get.snackbar(
          "Error", "No se pudo abrir la tienda de aplicaciones de Android",
          duration: const Duration(seconds: 5));
    }
  }

  // #######################################
  // Función que redirecciona a la tienda
  // de aplicaciones de iOS
  // #######################################

  void iosStore() async {
    const url = 'https://apps.apple.com/co/app/id-uninorte/id1523928095';
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Get.snackbar("Error", "No se pudo abrir la tienda de aplicaciones de iOS",
          duration: const Duration(seconds: 5));
    }
  }

  //##############################################################
  //  Cargue de foto
  //  consultPermission: verifica permisos de camara
  //  askGalleryPermission: solicita permisos de camara al usuario
  //  selectFromGallery
  //##############################################################

  void consultPermission() async {
    final status = Platform.isAndroid
        ? await Permission.camera.request()
        : await Permission.photos.request();
    if (!status.isGranted) {
      askGalleryPermission();
    }
  }

  Future<void> askGalleryPermission() async {
    final status = Platform.isAndroid
        ? await Permission.camera.request()
        : await Permission.photos.request();
    if (!status.isGranted) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Permisos'),
          content: const Text('Se requiere permiso para acceder a la galería.'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () => Get.back(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> selectFromGallery() async {
    final galleryPermissionStatus = Platform.isAndroid
        ? await Permission.camera.request()
        : await Permission.photos.request();
    if (!galleryPermissionStatus.isGranted) {
      await askGalleryPermission();
    } else {
      try {
        final pickedImage =
            await ImagePicker().pickImage(source: ImageSource.gallery);

        if (pickedImage != null) {
          final filename = pickedImage.path.split('/').last;
          final uri = Platform.isAndroid ? pickedImage.path : pickedImage.path;
          final mimeType = lookupMimeType(pickedImage.path);
          photoController
              .savePhoto(Photo(url: uri, name: filename, type: mimeType));
          Get.snackbar("Foto cargada", "La foto se cargó correctamente.",
              icon: const Icon(
                Icons.check,
                color: Color.fromRGBO(0, 85, 0, 1),
              ),
              backgroundColor: Colors.white.withOpacity(0.5),
              duration: const Duration(seconds: 5));
        }
      } catch (err) {
        Get.snackbar("Error", err.toString(),
            icon: const Icon(
              Icons.error,
              color: Color.fromRGBO(85, 0, 0, 1),
            ),
            backgroundColor: Colors.white.withOpacity(0.5),
            duration: const Duration(seconds: 5));
      }
    }
  }

  //#########################
  //  Subida de foto
  //#########################
  Future<void> uploadPhoto() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (photoController.picture.url != "" &&
        photoController.picture.type != null) {
      var fotoUrl = photoController.picture.url!.substring(1);

      try {
        const url = '$apiURL/modulo_induccion/ind_register.php';

        var request = http.MultipartRequest(
          'POST',
          Uri.parse(url),
        );
        // Agregar los datos del formulario
        request.fields['codigo'] = userDataController.person.codigo!;
        request.fields['primer_nombre'] =
            userDataController.person.nombreCompleto?[0]!;
        request.fields['segundo_nombre'] =
            userDataController.person.nombreCompleto?[1]!;
        request.fields['apellidos'] =
            userDataController.person.nombreCompleto?[2]!;
        request.fields['tipo_documento'] = 'CC';
        request.fields['documento'] = userDataController.person.documento!;
        request.fields['correo'] = userDataController.person.email!;
        request.fields['programa'] = userDataController.person.programa!;

        // Agregar la foto al formulario
        request.files.add(await http.MultipartFile.fromPath(
          'file-input',
          (Platform.isAndroid ? fotoUrl : fotoUrl.replaceFirst('file://', '')),
          contentType: MediaType('image', 'jpeg'),
        ));

        var response = await request.send();

        if (response.statusCode == 200) {
          var responseText = await response.stream.bytesToString();
          var responseJson = jsonDecode(responseText);
          if (responseJson['status'] == 200) {
            Get.snackbar("Subida exitosa", responseJson["message"],
                icon: const Icon(
                  Icons.check,
                  color: Color.fromRGBO(0, 85, 0, 1),
                ),
                backgroundColor: Colors.white.withOpacity(0.5),
                duration: const Duration(seconds: 5));
            await consultarPendiente(userDataController.person.documento,
                userDataController.person.email);
            setState(() {
              pendiente = "Pendiente";
            });
          } else {
            Get.snackbar("Error", responseJson["message"],
                icon: const Icon(
                  Icons.error_outline,
                  color: Color.fromRGBO(85, 0, 0, 1),
                ),
                backgroundColor: Colors.white.withOpacity(0.5),
                duration: const Duration(seconds: 5));
          }
        } else {
          Get.snackbar("Error",
              "Error al realizar la solicitud, por favor intente más tarde.",
              icon: const Icon(
                Icons.error_outline,
                color: Color.fromRGBO(85, 0, 0, 1),
              ),
              backgroundColor: Colors.white.withOpacity(0.5),
              duration: const Duration(seconds: 5));
        }
        prefs.setString(
            '@photoSent${userDataController.person.codigo}', "true");
        DateTime now = DateTime.now();
        String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
        setState(() {
          fecha = formattedDate;
        });
      } catch (e) {
        Get.snackbar("Error",
            "Error al realizar la solicitud, por favor intente más tarde.",
            icon: const Icon(
              Icons.error_outline,
              color: Color.fromRGBO(85, 0, 0, 1),
            ),
            backgroundColor: Colors.white.withOpacity(0.5),
            duration: const Duration(seconds: 5));
      }
    } else {
      Get.snackbar("Error",
          "Debes cargar una foto para poder proceder con tu solicitud.",
          icon: const Icon(
            Icons.error_outline,
            color: Color.fromRGBO(85, 0, 0, 1),
          ),
          backgroundColor: Colors.white.withOpacity(0.5),
          duration: const Duration(seconds: 5));
    }
  }
}
