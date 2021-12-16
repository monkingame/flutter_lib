library username;

import 'dart:math';

import 'package:flutter/material.dart';

abstract class Username {
  final String? surName;
  final String? firstName;

  Username({this.surName, this.firstName});

  List<String> get topSurNames;

  List<String> get topFirstNames;

  String getSurName() {
    if (surName != null) return surName!;
    final rand = Random();
    final index = rand.nextInt(topSurNames.length);
    return topSurNames[index];
  }

  String getFirstName() {
    if (firstName != null) return firstName!;
    final rand = Random();
    final index = rand.nextInt(topFirstNames.length);
    return topFirstNames[index];
  }

  // String get fullname;
  // List<String> getFullnames(int count);

  String get fullname => getSurName() + getFirstName();

  List<String> getFullnames(int count) {
    if (count <= 0) return [fullname];
    final list = List.generate(count, (_) => fullname);
    return list;
  }

  // factory Username.localeUsername(Locale locale) {}
}
