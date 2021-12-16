library username;

import 'dart:math';
import 'package:username/cn_username.dart';

abstract class Username {
  final String? surName;
  final String? givenName;

  Username({this.surName, this.givenName});

  List<String> get topSurNames;
  List<String> get topFirstNames;

  String _getSurName() {
    if (surName != null) return surName!;
    final rand = Random();
    final index = rand.nextInt(topSurNames.length);
    return topSurNames[index];
  }

  String _getFirstName() {
    if (givenName != null) return givenName!;
    final rand = Random();
    final index = rand.nextInt(topFirstNames.length);
    return topFirstNames[index];
  }

  // String get fullname;
  // List<String> getFullnames(int count);

  String get fullname => _getSurName() + _getFirstName();

  List<String> getFullnames({int count = 0}) {
    if (count <= 0) return [fullname];
    final list = List.generate(count, (_) => fullname);
    return list;
  }

  factory Username.locale(
      {String langCode = 'CN', String? surName, String? givenName}) {
    if (langCode.toUpperCase() == 'CN') {
      return CNUsername(surName: surName, givenName: givenName);
    }

    throw UnimplementedError();
  }
}
