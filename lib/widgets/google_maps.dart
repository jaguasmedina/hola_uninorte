import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';

import '../controllers/user_data_controller.dart';

// ############################################
// Widget para el mapa
// ############################################

// instancia de los controladores
final userDataController = Get.find<UserDataController>();

Logger logger = Logger();

class GoogleMaps extends StatefulWidget {
  const GoogleMaps({Key? key}) : super(key: key);

  @override
  State<GoogleMaps> createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  // obtener los puntos del mapa
  final puntos = userDataController.person.puntosMapa;

  // instanciar el controlador del mapa
  late GoogleMapController mapController;

  // definir el centro del mapa
  final LatLng _center = const LatLng(11.019216389923553, -74.84913080112524);

  // definir el mapa
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    final puntos = userDataController.person.puntosMapa!;
    // createdPoints();
    return GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 16.6,
        ),
        markers: {
          //definir los marcadores
          for (var punto in puntos)
            Marker(
              markerId: MarkerId(punto["id"]),
              position: LatLng(double.parse("${punto["latlng"]["latitude"]}"),
                  double.parse("${punto["latlng"]["longitude"]}")),
              infoWindow:
                  InfoWindow(title: punto["title"], snippet: punto["desc"]),
            ),
        });
  }
}
