import 'package:get/get.dart';

import '../models/encuesta_model.dart';

class EncuestasController extends GetxController {
  RxMap encuestas = {}.obs;

  final Encuesta encuesta = Encuesta(
    encuesta: {},
  );

  void saveEncuestas(Map encuestas) {
    this.encuestas = encuestas.obs;
  }

  clearEncuestas() {
    encuestas = {}.obs;
  }
}
