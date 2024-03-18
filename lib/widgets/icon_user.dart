import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hola_uninorte/controllers/user_data_controller.dart';

// ############################################
// Widget para el icono del usuario en
// el inicio
// ############################################

final _userDataController = Get.find<UserDataController>();

class IconUser extends StatelessWidget {
  const IconUser({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 70,
      width: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: const Color.fromARGB(255, 10, 236, 221),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Text(
        '${_userDataController.person.iniciales}',
        style: const TextStyle(
            fontSize: 34, color: Color.fromARGB(255, 255, 255, 255)),
      ),
    );
  }
}
