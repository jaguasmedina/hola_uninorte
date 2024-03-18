import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:hola_uninorte/controllers/navbar_controller.dart';
import 'package:hola_uninorte/controllers/user_data_controller.dart';
import 'package:logger/logger.dart';

import '../widgets/icon_user.dart';

// ############################################
// View para la pantalla de usuario
// ############################################

class User extends StatelessWidget {
  User({super.key});

  final _userDataController = Get.find<UserDataController>();

  final _navBarController = NavBarController();

  // ############################################
  // Función que se encarga de abrir la primera
  // etapa pendiente del usuario
  // ############################################
  void onContinue() {
    var pending = "Evaluación inducción";
    var found = false;
    var count = 0;
    _userDataController.person.etapas?.forEach((step) {
      if (!found && step["navStatus"] == "pending" && count < 5) {
        found = true;
        pending = step["navName"];
      }
      count++;
    });
    if (found) {
      _navBarController.openViewFromDrawer(pending);
    } else {
      Get.snackbar(
        "¡Hola!",
        "No tienes ninguna etapa pendiente",
        icon: const Icon(
          Icons.info_outline,
          color: Colors.black,
        ),
        duration: const Duration(seconds: 5),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const IconUser(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                /// Add this
                crossAxisAlignment: CrossAxisAlignment.start,

                children: <Widget>[
                  const Text(
                    '¡Hola!',
                    style: TextStyle(
                        fontSize: 18,
                        color: Color(0xff666666),
                        ),
                  ),
                  Text(
                    '${_userDataController.person.nombre}',
                    style: const TextStyle(
                      fontSize: 22,
                      color: Color.fromARGB(255, 0, 0, 0),
                      
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${_userDataController.person.programa}',
                    style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xff666666),
                        ),
                  ),
                ],
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                      onPressed: () {
                        onContinue();
                        // _navBarController
                        //     .openViewFromDrawer("Tu matrícula financiera");
                      },
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 255, 255, 255)),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromRGBO(0, 172, 227, 1)),
                        maximumSize: MaterialStateProperty.all<Size>(
                            const Size(200, 50)),
                      ),
                      child: const Text(
                        "CONTINUAR",
                        style: TextStyle(fontSize: 16),
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
