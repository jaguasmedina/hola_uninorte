import 'package:get/instance_manager.dart';
import 'package:hola_uninorte/controllers/encuestas_controller.dart';
import 'package:hola_uninorte/controllers/faq_controller.dart';
import 'package:hola_uninorte/controllers/matriculas_controller.dart';
import 'package:hola_uninorte/controllers/photo_controller.dart';
import 'package:hola_uninorte/controllers/user_data_controller.dart';
import 'package:hola_uninorte/controllers/volantes_controller.dart';
import 'package:hola_uninorte/controllers/navbar_controller.dart';

// ############################################
// Bindings para los controladores

// Aquí se inyectan los controladores
// ############################################

class ControllerBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<UserDataController>(UserDataController());
    Get.put<FaqController>(FaqController());
    Get.put<PhotoController>(PhotoController());
    Get.put<VolantesDataController>(VolantesDataController());
    Get.put<MatriculaDataController>(MatriculaDataController());
    Get.put<EncuestasController>(EncuestasController());
    Get.put<NavBarController>(NavBarController());
  }
}
