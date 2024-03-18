import 'package:get/get.dart';
import 'package:hola_uninorte/models/volante_model.dart';

class VolantesDataController extends GetxController {
  RxInt status = 0.obs;
  RxInt total = 0.obs;
  RxInt pendientes = 0.obs;
  RxList volantes = [].obs;
  RxString periodo = ''.obs;
  RxString codigo = ''.obs;

  final Volante volante = Volante(
    status: 0,
    total: 0,
    pendientes: 0,
    volantes: [],
    periodo: '',
    codigo: '',
  );

  void saveVolante(Volante volante) {
    this.volante.status = volante.status;
    this.volante.total = volante.total;
    this.volante.pendientes = volante.pendientes;
    this.volante.volantes = volante.volantes;
    this.volante.periodo = volante.periodo;
    this.volante.codigo = volante.codigo;
  }

  clearVolante() {
    status = 0.obs;
    total = 0.obs;
    pendientes = 0.obs;
    volantes = [].obs;
    periodo = ''.obs;
    codigo = ''.obs;
  }
}
