library username;

import 'dart:math';
import 'language_code.dart';
import 'username_cn.dart';
import 'username_en.dart';

abstract class Username {
  final String? surName;
  final String? givenName;

  Username({this.surName, this.givenName});

  List<String> get topSurNames;
  List<String> get topGivenNames;

  String getSurName() {
    if (surName != null) return surName!;
    final rand = Random();
    final index = rand.nextInt(topSurNames.length);
    return topSurNames[index];
  }

  String getGivenName() {
    if (givenName != null) return givenName!;
    final rand = Random();
    final index = rand.nextInt(topGivenNames.length);
    return topGivenNames[index];
  }

  List<String> splitCommaString(String input) {
    final list = input.split(',');
    final pure = list.map((name) => name.trim()).toList();
    return pure;
  }

  String get fullname;

  List<String> getFullnames({int count = 0}) {
    if (count <= 0) return [fullname];
    final list = List.generate(count, (_) => fullname);
    return list;
  }

  factory Username._locale(
      {LanguageCode lang = LanguageCode.CN,
      String? surName,
      String? givenName}) {
    if (lang == LanguageCode.CN) {
      return CNUsername(surName: surName, givenName: givenName);
    }

    if (lang == LanguageCode.EN) {
      return ENUsername(surName: surName, givenName: givenName);
    }

    throw UnimplementedError();
  }

  factory Username.cn({String? surName, String? givenName}) => Username._locale(
      lang: LanguageCode.CN, surName: surName, givenName: givenName);

  factory Username.en({String? surName, String? givenName}) => Username._locale(
      lang: LanguageCode.EN, surName: surName, givenName: givenName);
}
