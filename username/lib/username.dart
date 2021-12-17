library username;

import 'dart:math';
import 'language_code.dart';
import 'username_cn.dart';
import 'username_en.dart';

/// username class
abstract class Username {
  /// surname
  final String? surName;

  /// given name
  final String? givenName;

  /// constructor
  Username({this.surName, this.givenName});

  /// top sur names
  List<String> get topSurNames;

  /// top given names
  List<String> get topGivenNames;

  /// get random surname.
  /// if specified surname,then surname fixed.
  /// or else use top random surname
  String getSurName() {
    if (surName != null) return surName!;
    final rand = Random();
    final index = rand.nextInt(topSurNames.length);
    return topSurNames[index];
  }

  /// get random given name.
  /// if specified given name,then given name fixed.
  /// or else use top random given name
  String getGivenName() {
    if (givenName != null) return givenName!;
    final rand = Random();
    final index = rand.nextInt(topGivenNames.length);
    return topGivenNames[index];
  }

  /// tool: split string with comma
  List<String> splitCommaString(String input) {
    final list = input.split(',');
    final pure = list.map((name) => name.trim()).toList();
    return pure;
  }

  @override
  String toString() => fullname;

  /// get fullname
  /// (e.g. Chinese fullname is : surname+given name)
  String get fullname;

  List<String> getFullnames({int count = 0}) {
    if (count <= 0) return [fullname];
    final list = List.generate(count, (_) => fullname);
    return list;
  }

  /// factory locale
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

  /// factory cn: get Chinese usernames
  factory Username.cn({String? surName, String? givenName}) => Username._locale(
      lang: LanguageCode.CN, surName: surName, givenName: givenName);

  /// factory en: get English usernames
  factory Username.en({String? surName, String? givenName}) => Username._locale(
      lang: LanguageCode.EN, surName: surName, givenName: givenName);
}
