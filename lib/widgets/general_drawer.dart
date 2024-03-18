// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hola_uninorte/controllers/encuestas_controller.dart';
import 'package:hola_uninorte/controllers/faq_controller.dart';
import 'package:hola_uninorte/controllers/matriculas_controller.dart';
import 'package:hola_uninorte/controllers/photo_controller.dart';
import 'package:hola_uninorte/controllers/user_data_controller.dart';
import 'package:hola_uninorte/controllers/volantes_controller.dart';
import 'package:hola_uninorte/pages/login.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// #######################
// Widget del drawer
// #######################

final Uri _url = Uri.parse(
    "https://www.uninorte.edu.co/web/bienestar-universitario-2/uninorte-te-espera");

class GeneralDrawer extends StatefulWidget {
  const GeneralDrawer({super.key, required this.onTapItemDrawer});

  final void Function(int index) onTapItemDrawer;

  @override
  State<GeneralDrawer> createState() => _GeneralDrawerState();
}

class _GeneralDrawerState extends State<GeneralDrawer> {
  final Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    etapas = _userDataController.person.etapas ?? [];
  }

  final _userDataController = Get.find<UserDataController>();
  final _encuestasController = Get.find<EncuestasController>();
  final _faqController = Get.find<FaqController>();
  final _matriculaDataController = Get.find<MatriculaDataController>();
  final _photoController = Get.find<PhotoController>();
  final _volantesDataController = Get.find<VolantesDataController>();

  List<dynamic> etapas = [];

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
          gradient: LinearGradient(colors: [
            Color.fromRGBO(255, 255, 255, 1),
            Color.fromRGBO(255, 255, 255, 1),
            Color.fromRGBO(0, 172, 228, 1),
            Color.fromRGBO(0, 172, 228, 1),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: ListView(
          children: [
            Image(
              image: const AssetImage('assets/images/logo.png'),
              height: size.height * 0.2,
              width: size.width * 0.2,
            ),
            myDrawerList(),
          ],
        ),
      ),
    );
  }

  // #############################
  // widget que muestra cada item
  // del drawer
  // #############################

  Widget myDrawerList() {
    return Container(
      color: const Color.fromRGBO(0, 172, 228, 1),
      margin: const EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          menuItem(
            0,
            "Inicio",
            Colors.black,
            Colors.white,
            Colors.white,
          ),
          menuItem(
            1,
            etapas[0]["navName"],
            etapas[0]["navStatus"] == "-"
                ? const Color.fromARGB(255, 210, 210, 210)
                : const Color.fromARGB(255, 255, 255, 255),
            const Color.fromRGBO(1, 172, 226, 1),
            Colors.white,
          ),
          menuItem(
            2,
            etapas[1]["navName"],
            etapas[1]["navStatus"] == "-"
                ? const Color.fromARGB(255, 210, 210, 210)
                : const Color.fromARGB(255, 255, 255, 255),
            const Color.fromRGBO(17, 179, 230, 1),
            const Color.fromRGBO(0, 172, 228, 1),
          ),
          menuItem(
            3,
            etapas[2]["navName"],
            etapas[2]["navStatus"] == "-"
                ? const Color.fromARGB(255, 210, 210, 210)
                : const Color.fromARGB(255, 255, 255, 255),
            const Color.fromRGBO(51, 193, 234, 1),
            const Color.fromRGBO(34, 186, 232, 1),
          ),
          menuItem(
            4,
            etapas[3]["navName"],
            etapas[3]["navStatus"] == "-"
                ? const Color.fromARGB(255, 210, 210, 210)
                : const Color.fromARGB(255, 255, 255, 255),
            const Color.fromRGBO(1, 172, 226, 1),
            const Color.fromRGBO(51, 193, 234, 1),
          ),
          menuItem(
            5,
            etapas[4]["navName"],
            etapas[4]["navStatus"] == "-"
                ? const Color.fromARGB(255, 210, 210, 210)
                : const Color.fromARGB(255, 255, 255, 255),
            const Color.fromRGBO(17, 179, 230, 1),
            const Color.fromRGBO(1, 172, 226, 1),
          ),
          Container(
            color: const Color.fromRGBO(0, 172, 228, 1),
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: ElevatedButton(
                      onPressed: _launchUrl,
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.black),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromRGBO(255, 233, 59, 1)),
                      ),
                      child: const Text('¡Más información para ti!'),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    logout(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                    child: const Text(
                      "CERRAR SESIÓN",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // #############################
  // widget que muestra cada item
  // del drawer
  // #############################

  Widget menuItem(
      int id, String title, Color titleColor, Color color, Color background) {
    return Material(
      child: InkWell(
        onTap: id != 0
            ? etapas[id - 1]["navStatus"] != "-"
                ? () {
                    Get.back();

                    widget.onTapItemDrawer(id);
                  }
                : null
            : () {
                Get.back();

                widget.onTapItemDrawer(id);
              },
        child: Container(
          decoration: BoxDecoration(
            color: background,
          ),
          child: Container(
            padding: title == "Inicio"
                ? const EdgeInsets.only(left: 30.0, top: 8.0, bottom: 8.0)
                : const EdgeInsets.only(top: 8.0, bottom: 8.0),
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  title != "Inicio"
                      ? etapas[id - 1]["navStatus"] != "pending"
                          ? Expanded(
                              flex: 1,
                              child: Icon(
                                Icons.check_circle_outline,
                                color: etapas[id - 1]["navStatus"] != "-"
                                    ? Colors.white
                                    : color,
                                size: 24,
                              ),
                            )
                          : Expanded(
                              flex: 1,
                              child: Icon(
                                Icons.pending_actions,
                                color: titleColor,
                                size: 24,
                              ),
                            )
                      : Container(),
                  Expanded(
                    flex: 3,
                    child: Text(
                      title,
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // #############################
  // Función que abre el navegador
  // #############################

  Future<void> _launchUrl() async {
    if (!await launch(_url.toString())) {
      Get.snackbar("Error", "No se pudo abrir el enlace en el navegador",
          duration: const Duration(seconds: 5));
    }
  }

  // #############################
  // Función que cierra la sesión
  // y se encarga de limpiar los
  // datos de la aplicación y
  // controladores
  // #############################

  void logout(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    await _userDataController.clearData();
    await _encuestasController.clearEncuestas();
    await _faqController.clearFAQ();
    await _matriculaDataController.clearMatricula();
    await _photoController.clearPhoto();
    await _volantesDataController.clearVolante();

    // Redirige a la pantalla de inicio de sesión
    Get.offAll(() => const Login());
  }
}
