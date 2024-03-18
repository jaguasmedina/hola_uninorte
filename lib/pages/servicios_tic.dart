import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../controllers/matriculas_controller.dart';
import '../controllers/navbar_controller.dart';
import '../controllers/user_data_controller.dart';

// ############################################
// View para la pantalla de Servicios TIC
// ############################################

final matriculaController = Get.find<MatriculaDataController>();
final userDataController = Get.find<UserDataController>();
final navBarController = NavBarController();

// url de la api

class ServiciosTIC extends StatefulWidget {
  const ServiciosTIC({super.key});

  @override
  State<ServiciosTIC> createState() => _ServiciosTICState();
}

class _ServiciosTICState extends State<ServiciosTIC> {
  late VideoPlayerController videoPlayerController;
  bool videoFinished = false; //Estado que controla si el video terminó
  var apiURL = 'https://guayacan02.uninorte.edu.co/1nducc10n_v1rtu4l/api';

  get http => null;

  // ############################################
  // Función para reproducir el video
  // ############################################

  void playVideo() {
    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(
        'https://guayacan02.uninorte.edu.co/1nducc10n_v1rtu4l/include/video/servicios.mp4'))
      ..addListener(() => setState(() {}))
      ..initialize().then((_) => videoPlayerController.play());
  }

  // ############################################
  // Función para verificar si el video terminó
  // para actualizar el estado
  // ############################################

  void statusUpdate() {
    videoPlayerController.addListener(() {
      if (videoPlayerController.value.position >=
          videoPlayerController.value.duration) {
        //El video terminó
		
		 if (!videoFinished) {
          Get.snackbar(
              "Video finalizado", "Puedes continuar con la siguiente etapa.",
              icon: const Icon(
                Icons.check,
                color: Color.fromRGBO(19, 212, 2, 1),
              ),
              backgroundColor: Colors.white.withOpacity(0.5),
              duration: const Duration(seconds: 5));
        }
		
        setState(() {
          videoFinished = true;
        });
       

        // updateState();
      }
    });
  }

  // Future<void> updateState() async {
  //   final codigo = userDataController.person.codigo;
  //   const apiURL = 'https://guayacan02.uninorte.edu.co/1nducc10n_v1rtu4l/api';
  //   try {
  //     var url = Uri.parse('$apiURL/usuarios/video/${codigo!}');
  //     var response = await http.post(url);
  //     if (response.statusCode == 200) {
  //       var responseJson = await jsonDecode(response);
  //       if (responseJson.statusCode == 200) {}
  //     }
  //   } catch (e) {
  //     Get.snackbar("Error", e.toString(),
  //         icon: const Icon(
  //           Icons.error_outline,
  //           color: Color.fromRGBO(173, 0, 0, 1),
  //         ),
  //         backgroundColor: Colors.white.withOpacity(0.5),
  //         duration: const Duration(seconds: 5));
  //   }
  // }

  @override
  void initState() {
    super.initState();
    playVideo();
    videoFinished = false;
    statusUpdate();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(1, 172, 226, 1),
      child: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
              )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: Text(
                  "Nuestros servicios TIC para ti",
                  style: TextStyle(
                      fontSize: 30,
                      fontStyle: FontStyle.italic,
                      color: Color.fromRGBO(0, 172, 227, 1)),
                  textAlign: TextAlign.center,
                ),
              ),
              Center(
                child: videoPlayerController.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: videoPlayerController.value.aspectRatio,
                        child: VideoPlayer(videoPlayerController),
                      )
                    : const CircularProgressIndicator(
                        color: Color.fromRGBO(1, 172, 226, 1),
                      ),
              ),
              IconButton(
                // Si el video está reproduciendo, pausarlo. Si no, reproducirlo.
                onPressed: () => videoPlayerController.value.isPlaying
                    ? videoPlayerController.pause()
                    : videoPlayerController.play(),
                icon: Icon(
                  videoPlayerController.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                ),
              ),
            ],
          )),
    );
  }
}
