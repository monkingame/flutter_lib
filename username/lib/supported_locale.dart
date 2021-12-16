import 'package:flutter/material.dart';

abstract class SupportedLocale {
  SupportedLocale._();

  static const enLocale = Locale('en', '');

  static const cnLocale =
      Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans');

  static get defaultLocale => cnLocale;
}
