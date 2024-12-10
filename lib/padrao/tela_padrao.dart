import 'package:flutter/material.dart';
import 'cores.dart';

class TelaPadrao extends StatelessWidget {
  final String titulo;
  final Widget body;
  final bool floatingButton;
  final VoidCallback? onFloatingButtonPressed;
  final bool hasLeadingButton;
  final IconData? floatingButtonIcon;

  const TelaPadrao({
    Key? key,
    required this.titulo,
    required this.body,
    this.floatingButton = false,
    this.onFloatingButtonPressed,
    this.hasLeadingButton = true,
    this.floatingButtonIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: hasLeadingButton
            ? IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Cores.appBarFont,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
            : null,
        backgroundColor: Cores.primaryColor,
        title: Text(
          titulo,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Cores.appBarFont,
          ),
        ),
      ),
      body: body,
      floatingActionButton: floatingButton
          ? FloatingActionButton(
        backgroundColor: Cores.accentColor,
        onPressed: onFloatingButtonPressed,
        child: Icon(
          floatingButtonIcon ?? Icons.add,
          color: Cores.appBarFont,
        ),
      )
          : null,
    );
  }
}
