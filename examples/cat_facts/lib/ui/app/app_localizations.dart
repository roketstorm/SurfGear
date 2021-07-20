import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class AppLocalizations {
  static const Iterable<Locale> supportedLocales = [
    Locale('en'),
    Locale('ru'),
    Locale('ja'),
  ];

  static Future<AppLocalizations> load(Locale locale) async {
    final localeName = locale.countryCode == null || locale.countryCode!.isEmpty
        ? locale.languageCode
        : locale.toString();

    final canonicalLocaleName = Intl.canonicalizedLocale(localeName);

    Intl.defaultLocale = canonicalLocaleName;

    return AppLocalizations();
  }
}
