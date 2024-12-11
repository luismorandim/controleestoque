import 'package:i18n_extension/i18n_extension.dart';

// Developed by Marcelo Glasberg (Aug 2019).
// For more info, see: https://pub.dartlang.org/packages/i18n_extension

extension Localization on String {
  //
  static final _t = Translations.byText("pt_br") +
      {
        "pt_br": "Usuário",
        "en_us": "User",
      } +
      {
        "pt_br": "Senha",
        "en_us": "Password",
      } +
      {
        "pt_br": "Entrar",
        "en_us": "Login",
      } +
      {
        "pt_br": "Usuário ou senha inválidos",
        "en_us": "Invalid user or password",
      };


  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);

  String plural(value) => localizePlural(value, this, _t);

  String version(Object modifier) => localizeVersion(modifier, this, _t);

}