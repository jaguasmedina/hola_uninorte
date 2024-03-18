// ignore_for_file: must_be_immutable, deprecated_member_use, prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hola_uninorte/controllers/user_data_controller.dart';
import 'package:hola_uninorte/controllers/volantes_controller.dart';
import 'package:intl/intl.dart';
import 'package:intl/number_symbols.dart';
import 'package:intl/number_symbols_data.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

// ############################################
// View de matrícula financiera
// ############################################

UserDataController userDataController = Get.find<UserDataController>();
Logger logger = Logger();

// Formatear un valor numérico como pesos colombianos
String formatCurrency(int value) {
  // Cargar símbolos de pesos colombianos
  numberFormatSymbols['es_CO'] = const NumberSymbols(
    NAME: "co",
    DECIMAL_SEP: ',',
    GROUP_SEP: '.',
    PERCENT: '%',
    ZERO_DIGIT: '0',
    PLUS_SIGN: '+',
    MINUS_SIGN: '-',
    EXP_SYMBOL: 'E',
    PERMILL: '‰',
    INFINITY: '∞',
    NAN: 'NaN',
    DECIMAL_PATTERN: '#,##0.###',
    SCIENTIFIC_PATTERN: '#E0',
    PERCENT_PATTERN: '#,##0%',
    CURRENCY_PATTERN: '¤#,##0.00',
    DEF_CURRENCY_CODE: '',
  );

  // Establecer el localizador para pesos colombianos
  NumberFormat.currency(locale: 'es_CO');

  // Crear una instancia de NumberFormat para pesos colombianos
  final currencyFormat = NumberFormat.currency(symbol: 'COP \$');

  // Formatear el valor como pesos colombianos
  String formattedValue = currencyFormat.format(value);

  // Quitar los dos últimos ceros
  formattedValue = formattedValue.replaceAll('.00', '');

  return formattedValue;
}

class MatriculaFinanciera extends StatelessWidget {
  MatriculaFinanciera({super.key});

  final volantesDataController = Get.find<VolantesDataController>();

  Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    List? volantes = volantesDataController.volante.volantes;
    String? periodo = volantesDataController.volante.periodo;
    return Scaffold(
      body: volantesDataController.volante.total! > 0
          ? Container(
              color: const Color.fromRGBO(1, 172, 226, 1),
              height: double.infinity,
              width: double.infinity,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const YellowButton(),
                      ...volantes!.map((volante) {
                        return Volante(
                          volante: volante,
                          periodo: periodo,
                          codigo: volante["codigo"],
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            )
          : const Center(
              child: Text(
              "Espera en tu correo electrónico la notificación de disponibilidad de tus volantes de pago.",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            )),
    );
  }
}

// ############################################
// Widget que muestra el volante de pago
// ############################################

class Volante extends StatelessWidget {
  const Volante({
    super.key,
    required this.volante,
    required this.periodo,
    required this.codigo,
  });

  final volante;
  final periodo;
  final codigo;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              volante["concepto"] == 54
                  ? const Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        "*Solo disponible para descargar el recibo. Para verificar el estado de tu pago, comunícate al área de Contabilidad.",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: Colors.redAccent,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : const Text(""),
              Text(
                volante["title"],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              volante["pagable"]
                  ? Text(
                      "Nro. de referencia: ${volante['refer']} ",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Container(),
              const Divider(
                color: Colors.green,
                thickness: 1,
              ),
              volante["pagable"] ? Tabla(volante: volante) : const Text(""),
              volante["pagado"] == "S"
                  ? const Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Text(
                        "Pagado",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    )
                  : renderPayment(volante, periodo, codigo, context),
            ],
          ),
        ),
      ),
    );
  }

  // ############################################
  // Widget que muestra los botones de descarga
  // y pago del volante de pago
  // ############################################

  Padding renderPayment(volante, periodo, codigo, context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                Platform.isIOS
                    ? handleDownloadIos(context)
                    : handleDownload(volante, periodo, codigo, context);
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.download),
                  SizedBox(width: 5),
                  Text("Descargar"),
                ],
              )),
          volante["pagable"]
              ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {
                    handlePayment(volante, periodo, codigo, context);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.payment),
                      SizedBox(width: 5),
                      Text("Pagar"),
                    ],
                  ))
              : Container()
        ],
      ),
    );
  }
}

// ############################################
// Función que construye la url para descargar
// el volante de pago en Android
// ############################################

handleDownload(volante, periodo, codigo, context) async {
  final params = volante["pagable"]
      ? {
          "tipo": 1,
          "reference": volante["refer"],
          "periodo": periodo,
        }
      : {
          "tipo": 2,
          "periodo": periodo,
          "codigo": codigo,
          "concepto": volante["concepto"],
        };
  final String urlVolante =
      params["tipo"] == 1 ? buildUrlTipo1(params) : buildUrlTipo2(params);

  if (!await launch(urlVolante)) {
    throw Exception('Could not launch $urlVolante');
  }
}

// ############################################
// Función que construye la url para descargar
// el volante de pago en iOS
// ############################################

handleDownloadIos(context) {
  Get.snackbar("Descargar",
      "Puedes imprimir tu volante, ingresando a  https://bit.ly/2z0EkiN desde un equipo con impresora configurada",
      icon: const Icon(
        Icons.info_outline,
        color: Color.fromRGBO(238, 255, 50, 1),
      ),
      backgroundColor: Colors.white.withOpacity(0.5),
      duration: const Duration(seconds: 5));
}

// ############################################
// Función que construye la url para pagar
// el volante de pago
// ############################################

void handlePayment(volante, periodo, codigo, context) async {
  List valores = volante["valores"];
  final params = {
    "periodo": periodo,
    "identifier": codigo,
    "volante": volante["refer"],
    "valor": valores[0][1],
    "Reference": volante["refer"],
    "TotalAmount": valores[0][1],
    "TaxAmount": "0",
    "ShopperName": "",
    "ShopperEmail": "",
  };

  String url = 'https://guayacan02.uninorte.edu.co/T3RR4/form.php';

  String encodedData = encodeDataToURL(params);

  String urlPay = '$url?$encodedData';

  if (!await launch(urlPay)) {
    throw Exception('Could not launch $urlPay');
  }
}

// ############################################
// Función que construye la url para pagar
// el volante de pago
// ############################################

String encodeDataToURL(Map<String, dynamic> data) {
  return Uri(queryParameters: data).query;
}

// ############################################
// Widget de la tabla de valores del volante
// ############################################

class Tabla extends StatelessWidget {
  const Tabla({
    super.key,
    required this.volante,
  });

  final volante;

  @override
  Widget build(BuildContext context) {
    int value = int.parse(volante["valores"][0][1]);
    String formattedValue = formatCurrency(value);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 5,
          ),
          margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Row(
            children: [
              Expanded(
                child: Text(
                  "Descripción",
                  style: TextStyle(fontSize: 14, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: Text(
                  "Valor a pagar",
                  style: TextStyle(fontSize: 14, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: Text(
                  "Fecha límite de pago",
                  style: TextStyle(fontSize: 14, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 5),
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.green,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "${volante["valores"][0][0]}",
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  formattedValue.replaceAll(",", "."),
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  "${volante["valores"][0][2]}",
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ############################################
// Widget del botón de financiamiento estudiantil
// ############################################

class YellowButton extends StatelessWidget {
  const YellowButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: ElevatedButton(
          onPressed: _launchUrl,
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
            backgroundColor: MaterialStateProperty.all<Color>(
                const Color.fromRGBO(255, 233, 59, 1)),
          ),
          child: const Text('Financiamiento estudiantil'),
        ),
      ),
    );
  }
}

// ############################################
// Función que lanza la url de financiamiento
// ############################################

Future<void> _launchUrl() async {
  Uri urlFinanciamiento =
      Uri.parse("https://www.uninorte.edu.co/web/apoyo-financiero");
  if (!await launch(urlFinanciamiento.toString())) {
    Get.snackbar("Error", 'Could not launch $urlFinanciamiento',
        duration: const Duration(seconds: 5));
  }
}

// ############################################
// Widget del botón de pago dependiendo del tipo
// ############################################

buildUrlTipo1(Map<String, dynamic> params) {
  return 'https://pomelo.uninorte.edu.co/pls/prod/tzkvvola.P_FormatoVolante1?term=${params["periodo"]}&numvol=${params["reference"]}';
}

buildUrlTipo2(Map<String, dynamic> params) {
  return 'https://guayacan02.uninorte.edu.co/4PL1CACI0N35/financiacion/becas.php';
}
