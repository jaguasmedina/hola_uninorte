import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hola_uninorte/controller_bindings.dart';
import 'package:hola_uninorte/pages/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? sessionToken = prefs.getString('token');

  runApp(MyApp(sessionToken: sessionToken));
}

class MyApp extends StatelessWidget {
  final String? sessionToken;

  const MyApp({Key? key, this.sessionToken}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: ControllerBindings(),
      title: 'Hola Uninorte',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(1, 172, 226, 1)),
        useMaterial3: true,
      ),
      // home: sessionToken != null ? const NavBar() : const Login(),
      home: const LoadingScreen(),
    );
  }
}
