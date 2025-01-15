import 'package:flutter/material.dart';

class L10n {
  static final List<Locale> all = [
    const Locale('en'),
    // const Locale('ru'),
    // const Locale('es'),
    // const Locale('de'),
    // const Locale('zh'),
    // const Locale('fr'),
  ];

  static String getLang(String code) {
    switch (code) {
      case 'en':
        return 'English';
      // case 'ru':
      //   return 'Русский';
      default:
        return 'English';
    }
  }
}
