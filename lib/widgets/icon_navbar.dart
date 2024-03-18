import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hola_uninorte/controllers/user_data_controller.dart';

// ############################################
// Widget para el icono del usuario en la
// barra de navegación
// ############################################

final _userDataController = Get.find<UserDataController>();

class IconUserNavBar extends StatelessWidget {
  const IconUserNavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 50,
      width: 50,
      margin: const EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: const Color.fromARGB(255, 10, 236, 221),
      ),
      child: Text(
        '${_userDataController.person.iniciales}',
        style: const TextStyle(
            fontSize: 20, color: Color.fromARGB(255, 255, 255, 255)),
      ),
    );
  }
}
