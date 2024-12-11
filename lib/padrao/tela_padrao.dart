import 'package:controleestoque/model/login_manager.dart';
import 'package:controleestoque/padrao/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../telas/login/login_screen.dart';
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
    return Consumer2<ThemeManager, LoginManager>(
      builder: (__, themeManager, loginManager, _) {
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
              IconButton(
                icon: Icon(Icons.logout, color: Cores.appBarFont),
                onPressed: () {
                  loginManager.logout();

                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (Route<dynamic> route) => false,
                  );
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
      },
    );
  }
}
