import 'package:get/get.dart';
import 'package:hola_uninorte/models/person_model.dart';

class UserDataController extends GetxController {
  RxString programa = ''.obs;
  RxList nombreCompleto = [].obs;
  RxString email = ''.obs;
  RxString documento = ''.obs;
  RxString codigo = ''.obs;
  RxString pidm = ''.obs;
  RxString iniciales = ''.obs;
  RxList etapas = [].obs;
  RxList puntosMapa = [].obs;

  final Person person = Person(
    token: '',
    user: '',
    nombre: '',
    nombreCompleto: [],
    email: '',
    programa: '',
    documento: '',
    codigo: '',
    pidm: '',
    etapas: [],
    puntosMapa: [],
    iniciales: '',
    timeout: '',
    isLogin: '',
    oficinas: '',
    preguntas: '',
    encuestas: '',
  );

  void savePerson(Person person) {
    this.person.token = person.token;
    this.person.user = person.user;
    this.person.nombre = person.nombre;
    this.person.nombreCompleto = person.nombreCompleto;
    this.person.email = person.email;
    this.person.programa = person.programa;
    this.person.documento = person.documento;
    this.person.codigo = person.codigo;
    this.person.pidm = person.pidm;
    this.person.etapas = person.etapas;
    this.person.puntosMapa = person.puntosMapa;
    this.person.iniciales = person.iniciales;

    this.person.timeout = person.timeout;
    this.person.isLogin = person.isLogin;
    this.person.oficinas = person.oficinas;
    this.person.preguntas = person.preguntas;
    this.person.encuestas = person.encuestas;
  }

  clearData() {
    person.token = '';
    person.user = '';
    person.nombre = '';
    person.nombreCompleto = [];
    person.email = '';
    person.programa = '';
    person.documento = '';
    person.codigo = '';
    person.pidm = '';
    person.etapas = [];
    person.iniciales = '';

    person.timeout = '';
    person.isLogin = '';
    person.oficinas = '';
    person.preguntas = '';
    person.encuestas = '';
  }
}
