import 'package:controleestoque/padrao/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cores.dart';

class TelaPadrao extends StatelessWidget {
  final String titulo;
  final Widget body;
  final bool floatingButton;
  final VoidCallback? onFloatingButtonPressed;
  final bool hasLeadingButton;
  final IconData? floatingButtonIcon;

  const TelaPadrao({
    super.key,
    required this.titulo,
    required this.body,
    this.floatingButton = false,
    this.onFloatingButtonPressed,
    this.hasLeadingButton = true,
    this.floatingButtonIcon,
  });

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

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
        actions: [
          IconButton(
            icon: Icon(
              themeManager.currentTheme == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
              color: Cores.appBarFont,
            ),
            onPressed: () {
              themeManager.toggleTheme();
            },
          ),
        ],
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
