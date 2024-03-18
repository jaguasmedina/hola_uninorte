import 'package:flutter/material.dart';

import '../widgets/navbar.dart';

class NavBarController {
  // Hacer un singleton (una única instancia global)
  static final NavBarController _instance = NavBarController._internal();
  factory NavBarController() => _instance;
  NavBarController._internal();

  final GlobalKey<NavBarState> _navBarKey = GlobalKey<NavBarState>();

  GlobalKey<NavBarState> get navBarKey => _navBarKey;

  // Abre una vista desde el drawer (menú lateral)
  void openViewFromDrawer(String namePage) {
    // Accede al estado actual del NavBar y llama al método "openViewFromDrawer"
    _navBarKey.currentState!.openViewFromDrawer(namePage: namePage);
  }

  void openViewFromNavbar(String nameNavbarPage) {
    // Accede al estado actual del NavBar y llama al método "openViewFromNavbar"
    _navBarKey.currentState!.openViewFromNavbar(nameNavbarPage: nameNavbarPage);
  }
}
