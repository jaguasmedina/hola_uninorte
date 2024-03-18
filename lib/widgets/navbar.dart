import 'package:flutter/material.dart';
import 'package:hola_uninorte/pages/map.dart';
import 'package:hola_uninorte/pages/matricula_academica.dart';
import 'package:hola_uninorte/pages/matricula_financiera.dart';
import 'package:hola_uninorte/pages/queremos_conocerte.dart';
import 'package:hola_uninorte/pages/questions.dart';
import 'package:hola_uninorte/pages/servicios_tic.dart';
import 'package:hola_uninorte/pages/subir_foto.dart';
import 'package:hola_uninorte/pages/user.dart';
import 'package:hola_uninorte/widgets/general_drawer.dart';
import 'package:hola_uninorte/widgets/icon_navbar.dart';

// ############################################
// Widget que contiene el navbar y el drawer

// Aquí es donde se define que páginas se
// van a mostrar
// ############################################

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => NavBarState();
}

class NavBarState extends State<NavBar> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Lista de páginas que se van a mostrar en el navbar
  final List<Widget> _pagesNavbar = [
    const Map(),
    const Questions(),
    User(),
  ];

  // Lista de páginas que se van a mostrar en el drawer
  final List<Widget> _pagesDrawer = [
    User(),
    MatriculaFinanciera(),
    QueremosConocerte(),
    const SubirFoto(),
    const ServiciosTIC(),
    const MatriculaAcademica(),
  ];

  // Página actual que se está mostrando
  late Widget _pagActual = _pagesDrawer[0];

  // Lista de títulos de las páginas que se van a mostrar en el navbar
  final List<String> _titlePagesNavbar = [
    "Mapa",
    "Preguntas",
    "Usuario",
  ];

  // Lista de títulos de las páginas que se van a mostrar en el drawer
  final List<String> _titlePages = [
    "Inicio",
    "Tu matrícula financiera",
    "Queremos conocerte",
    // "Tu bienestar emocional",
    "Sube tu foto",
    "Nuestros servicios TIC",
    "Tu matrícula académica",
    // "Jornada de inducción",
  ];

  // color principal de la app
  final Color _color = const Color.fromRGBO(1, 172, 226, 1);

  // tamaño de los botones amarillos del drawer
  final double sizeBtn = 30.0;

  // ############################################
  // función que se ejecuta cuando se presiona
  // el botón del navbar

  // Aquí se abre el drawer
  // ############################################
  void _openDrawer() {
    // se obtiene el estado del scaffold
    final scaffoldState = _scaffoldKey.currentState;

    // si el scaffold tiene un drawer
    if (scaffoldState != null) {
      // si el drawer está abierto, se cierra
      if (scaffoldState.hasDrawer) {
        // si el drawer está abierto, se cierra
        if (scaffoldState.isDrawerOpen) {
          scaffoldState.closeDrawer();
        } else {
          scaffoldState.openDrawer();
        }
      }
    }
  }

  // ############################################
  // función que se ejecuta cuando se presiona
  // un botón del drawer

  // Aquí se cambia la página actual
  // ############################################

  void openViewFromDrawer({required String namePage}) {
    setState(() {
      _pagActual = _pagesDrawer[_titlePages.indexOf(namePage)];
    });
  }

  // ############################################
  // función que se ejecuta cuando se presiona
  // un botón del navbar

  // Aquí se cambia la página actual
  // ############################################

  void openViewFromNavbar({required String nameNavbarPage}) {
    setState(() {
      _pagActual = _pagesNavbar[_titlePagesNavbar.indexOf(nameNavbarPage)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: _pagActual == _pagesNavbar[0] || _pagActual == _pagesNavbar[1]
            ? null
            : appBar(context),
        body: _pagActual,
        drawer: GeneralDrawer(
          onTapItemDrawer: (index) {
            setState(() {
              _pagActual = _pagesDrawer[index];
            });
          },
        ),
        bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25), topLeft: Radius.circular(25)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black38, spreadRadius: 0, blurRadius: 10),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: _color,
                unselectedIconTheme: const IconThemeData(color: Colors.white),
                selectedIconTheme: const IconThemeData(color: Colors.white),
                unselectedItemColor: Colors.white,
                selectedItemColor: Colors.white,
                onTap: (index) {
                  if (index == 0) {
                    _openDrawer();
                  } else {
                    setState(() {
                      _pagActual = _pagesNavbar[index - 1];
                    });
                  }
                },
                currentIndex: !_pagesNavbar.contains(_pagActual)
                    ? 3
                    : _pagesNavbar.indexOf(_pagActual) + 1,
                items: [
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.list),
                    label: "Etapas",
                    backgroundColor: _color,
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.map),
                    label: "Campus",
                    backgroundColor: _color,
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.question_mark),
                    label: "Preguntas",
                    backgroundColor: _color,
                  ),
                  BottomNavigationBarItem(
                    icon: const IconUserNavBar(),
                    label: "",
                    backgroundColor: _color,
                  ),
                ],
              ),
            )));
  }

  // ############################################
  // Widget que se muestra en el appBar
  // ############################################

  PreferredSize appBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: _pagActual == _pagesNavbar[2] ||
              _pagActual == _pagesDrawer[0] ||
              _pagActual == User()
          ? userAppBar(context)
          : generalAppBar(),
    );
  }

  // ############################################
  // Widgets que se muestran un appBar generico
  // ############################################

  Container generalAppBar() {
    return Container(
      padding: const EdgeInsets.only(
        left: 20,
      ),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(1, 172, 226, 1),
        // borderRadius: BorderRadius.only(topLeft: Radius.circular(50)),
      ),
      child: AppBar(
        actionsIconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: _openDrawer,
        ),
        title: Text(
          _titlePages[_pagesDrawer.indexOf(_pagActual)],
          style: const TextStyle(color: Colors.white, fontSize: 13),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  // ############################################
  // Widgets que se muestra un appBar para el usuario
  // ############################################

  Container userAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        bottom: 20,
        left: 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(50)),
      ),
      child: AppBar(
        actionsIconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black, size: 20),
          onPressed: _openDrawer,
        ),
        title: Text(
          _titlePages[0],
          style: const TextStyle(color: Colors.black, fontSize: 13),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}
