import 'package:controleestoque/model/language_manager.dart';
import 'package:controleestoque/model/login_manager.dart';
import 'package:controleestoque/padrao/theme.dart';
import 'package:controleestoque/telas/home/home_screen.dart';
import 'package:controleestoque/telas/login/login_screen.i18n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:country_icons/country_icons.dart';
import '../../padrao/cores.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _selectedLanguage = 'pt';
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Consumer3<ThemeManager, LoginManager, LanguageManager>(
      builder: (__, themeManager, loginManager, languageManager, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Login'),
            actions: [
              IconButton(
                icon: Icon(
                  themeManager.currentTheme == ThemeMode.dark
                      ? Icons.light_mode
                      : Icons.dark_mode,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Cores.appBarFont
                      : Cores.textColor(context),
                ),
                onPressed: () {
                  themeManager.toggleTheme();
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _usernameController,
                  style: TextStyle(color: Cores.textColor(context)),
                  decoration: InputDecoration(
                    labelText: 'Usuário'.i18n,
                    labelStyle: TextStyle(color: Cores.textSubtitleColor(context)),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Cores.loginFieldBorder),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF424242)
                        : Cores.loginFieldBackground,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  style: TextStyle(color: Cores.textColor(context)),
                  decoration: InputDecoration(
                    labelText: 'Senha'.i18n,
                    labelStyle: TextStyle(color: Cores.textSubtitleColor(context)),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Cores.loginFieldBorder),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF424242)
                        : Cores.loginFieldBackground,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Cores.textSubtitleColor(context),
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: 180,
                  child: DropdownButton<String>(
                    value: _selectedLanguage,
                    items: [
                      DropdownMenuItem(
                        value: 'pt',
                        child: Row(
                          children: [
                            Image.asset(
                              'icons/flags/png100px/br.png',
                              package: 'country_icons',
                              width: 24,
                            ),
                            const SizedBox(width: 8),
                            const Text('Português'),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'en',
                        child: Row(
                          children: [
                            Image.asset(
                              'icons/flags/png100px/us.png',
                              package: 'country_icons',
                              width: 24,
                            ),
                            const SizedBox(width: 8),
                            const Text('English'),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedLanguage = value!;
                        languageManager.changeLanguage(value);
                      });
                    },
                    isExpanded: true,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    final username = _usernameController.text.trim();
                    final password = _passwordController.text.trim();

                    if (loginManager.login(username, password)) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(
                          content: Text('Usuário ou senha inválidos'.i18n, style: TextStyle(color: Colors.white)),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child:  Text('Entrar'.i18n),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
