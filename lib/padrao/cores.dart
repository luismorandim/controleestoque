import 'package:flutter/material.dart';

class Cores {
  static Color primaryColor = const Color.fromARGB(255, 89, 89, 171);
  static Color accentColor = const Color.fromARGB(255, 255, 153, 51);
  static Color backgroundColor = const Color.fromARGB(255, 245, 245, 245);
  static Color appBarFont = const Color.fromARGB(255, 255, 255, 255);
  static Color warningCard = const Color.fromARGB(255, 255, 204, 204);
  static Color cardFontPadrao = const Color.fromARGB(255, 0, 0, 0);
  static Color normalStatus = const Color.fromARGB(255, 76, 175, 80);
  static Color alertStatus = const Color.fromARGB(255, 244, 67, 54);
  static Color borderPadrao = const Color.fromARGB(255, 0, 0, 0);


  static const Color buttonActive = Color(0xFF6200EE);
  static const Color buttonInactive = Color(0xFFBDBDBD);
  static const Color textButtonActive = Colors.white;
  static const Color textButtonInactive = Colors.black54;

  // Cor padrão para cards (preto acinzentado)
  static Color cardBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
    ? const Color.fromARGB(255, 40, 40, 40)
    : const Color.fromARGB(255, 245, 245, 245);
  }


  // Cores específicas dos gráficos
  static Color chartLineColor = const Color.fromARGB(255, 89, 89, 171);
  static Color chartBarGreen = const Color.fromARGB(255, 76, 175, 80);
  static Color chartBarRed = const Color.fromARGB(255, 244, 67, 54);
  static Color chartPieGreen = const Color.fromARGB(255, 76, 175, 80);
  static Color chartPieRed = const Color.fromARGB(255, 244, 67, 54);
  static Color tooltipBackground = const Color.fromARGB(255, 50, 50, 50);



  static Color textColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color.fromARGB(255, 245, 245, 245) // Texto claro
        : const Color.fromARGB(255, 40, 40, 40); // Texto escuro
  }

  static Color textSubtitleColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color.fromARGB(255, 200, 200, 200) // Subtítulo claro
        : const Color.fromARGB(255, 80, 80, 80); // Subtítulo escuro
  }


}
