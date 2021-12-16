import 'username.dart';

class ENUsername extends Username {
  ENUsername({String? surName, String? givenName})
      : super(surName: surName, givenName: givenName);

  String get fullname => getSurName() + getGivenName();

  // 姓氏
  List<String> get topSurNames {
    final names = '';

    return names.split(',');
  }

  // 名称
  List<String> get topGivenNames {
    final names = '';

    return names.split(',');
  }
}
