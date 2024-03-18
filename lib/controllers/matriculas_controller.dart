import 'package:get/get.dart';
import 'package:hola_uninorte/models/matricula_model.dart';

class MatriculaDataController extends GetxController {
  RxInt status = 0.obs;
  RxString matriculado = ''.obs;
  RxBool aceptado = false.obs;
  RxList horario = [].obs;

  final Matricula matricula = Matricula(
    status: 0,
    matriculado: '',
    aceptado: false,
    horario: [],
  );

  void saveMatricula(Matricula matricula) {
    this.matricula.status = matricula.status;
    this.matricula.matriculado = matricula.matriculado;
    this.matricula.aceptado = matricula.aceptado;
    this.matricula.horario = matricula.horario;
  }

  clearMatricula() {
    status = 0.obs;
    matriculado = ''.obs;
    aceptado = false.obs;
    horario = [].obs;
  }
}
