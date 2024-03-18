import 'package:get/get.dart';
import 'package:hola_uninorte/models/faq_model.dart';

class FaqController extends GetxController {
  RxList preguntas = [].obs;

  final FAQ faq = FAQ(
    preguntas: [],
  );

  void saveFAQ(FAQ faq) {
    this.faq.preguntas = faq.preguntas;
  }

  clearFAQ() {
    preguntas = [].obs;
  }
}
