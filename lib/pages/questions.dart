// Importaciones necesarias
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Importación de la librería 'get' para la gestión de estados
import 'package:hola_uninorte/controllers/faq_controller.dart'; // Importación del controlador 'FaqController'
import 'package:hola_uninorte/controllers/navbar_controller.dart';
import 'package:logger/logger.dart';

import 'faq/respuesta.dart'; // Importación de la librería 'logger' para el registro de logs

// ############################################
// View para la pantalla de preguntas frecuentes
// ############################################

class Questions extends StatefulWidget {
  const Questions({Key? key}) : super(key: key);

  @override
  QuestionsState createState() => QuestionsState();
}

class QuestionsState extends State<Questions> {
  final TextEditingController searchController = TextEditingController();
  // Controlador para el campo de búsqueda

  List<dynamic> filteredPreguntas = [];
  // Lista para almacenar las preguntas filtradas

  final Logger logger = Logger();
  // Instancia del logger para registrar logs

  final faqController = Get.find<FaqController>();
  // Instancia del controlador 'FaqController' mediante 'get'

  final navBarController = NavBarController();
  // Instancia del controlador 'NavBarController' mediante 'get'

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      filterPreguntas(searchController.text);
      // Agregar un listener al campo de búsqueda para filtrar las preguntas
    });
  }

  @override
  void dispose() {
    searchController.removeListener(() {
      filterPreguntas(searchController.text);
      // Remover el listener del campo de búsqueda al finalizar la pantalla
    });
    searchController.dispose();
    super.dispose();
  }

  // ############################################
  // Función para crear la barra de búsqueda
  // ############################################

  void filterPreguntas(String query) {
    final preguntas = faqController.faq.preguntas;

    setState(() {
      filteredPreguntas = preguntas!
          .where((pregunta) => pregunta["pre_pregunta"]
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
      // Filtrar las preguntas según el texto ingresado en el campo de búsqueda
    });
  }

  @override
  Widget build(BuildContext context) {
    final preguntas = faqController.faq.preguntas;

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(
            vertical: 20, horizontal: 5), // Margen del contenedor
        child: ListView(
          padding: const EdgeInsets.all(8),
          // ListView para mostrar la lista de preguntas
          children: <Widget>[
            const Text(
              "Preguntas frecuentes",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 30,
                  fontStyle: FontStyle.italic,
                  color: Color.fromRGBO(0, 172, 227, 1),
                  fontWeight: FontWeight.bold),
            ),
            searchBar(),
            // Barra de búsqueda de preguntas

            ...filteredPreguntas.isNotEmpty
                ? filteredPreguntas.map((e) => questionsList(e)).toList()
                : preguntas!.map((e) => questionsList(e)).toList(),
            // Lista de preguntas
          ],
        ),
      ),
    );
  }

  // ############################################
  // Widget que contiene la lista de preguntas
  // ############################################

  InkWell questionsList(e) {
    return InkWell(
      onTap: () {
        Get.to(() => Respuesta(
              id: e["id_pregunta"],
              pregunta: e["pre_pregunta"],
              componentes: e["componentes"],
            ));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color.fromRGBO(0, 118, 155, 1),
              width: 0.7,
            ),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.play_arrow,
              color: Colors.grey,
              size: 40,
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                e["pre_pregunta"],
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ############################################
  // Widget que contiene la barra de búsqueda
  // ############################################

  Center searchBar() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: SizedBox(
          height: 48.0,
          child: TextField(
            controller: searchController,
            onChanged: (value) {
              filterPreguntas(value);
              // Filtrar las preguntas según el texto ingresado
            },
            decoration: const InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 235, 235, 235), // Color de fondo
                hintText: 'Buscar', // Texto de ayuda o placeholder
                hintStyle: TextStyle(
                    height: BorderSide.strokeAlignCenter,
                    color: Colors.grey,
                    fontWeight: FontWeight.normal),
                prefixIcon: Icon(Icons.search), // Icono de búsqueda
                prefixIconColor: Colors.grey,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15.0),
                  ),
                  borderSide: BorderSide.none,
                )),
          ),
        ),
      ),
    );
  }
}
