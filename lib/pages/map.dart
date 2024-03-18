import 'package:flutter/material.dart';

import '../widgets/google_maps.dart';

// ############################################
// View para la pantalla de mapa
// ############################################

class Map extends StatelessWidget {
  const Map({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: GoogleMaps(),
    );
  }
}
