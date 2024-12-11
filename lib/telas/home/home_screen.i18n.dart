import 'package:i18n_extension/i18n_extension.dart';

// Developed by Marcelo Glasberg (Aug 2019).
// For more info, see: https://pub.dartlang.org/packages/i18n_extension

extension Localization on String {
  //
  static final _t = Translations.byText("pt_br") +
      {
        "pt_br": "Dashboard",
        "en_us": "Dashboard",
      } +
      {
        "pt_br": "Olá,",
        "en_us": "Hello,",
      } +
      {
        "pt_br": "Produtos",
        "en_us": "Products",
      } +
      {
        "pt_br": "Gráficos",
        "en_us": "Charts",
      };


  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);

  String plural(value) => localizePlural(value, this, _t);

  String version(Object modifier) => localizeVersion(modifier, this, _t);

}