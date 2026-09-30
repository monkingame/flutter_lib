import 'package:flutter_test/flutter_test.dart';
import 'package:username/username.dart';

void main() {
  group('Username.cn', () {
    test('random fullname consists of surname and given name', () {
      final u = Username.cn();
      final fullName = u.fullname;
      expect(fullName.length, greaterThan(1));
      expect(u.topSurNames, isNotEmpty);
      expect(u.topGivenNames, isNotEmpty);
    });

    test('fixed surname and given name are kept', () {
      final u = Username.cn(surName: '王', givenName: '小明');
      expect(u.getSurName(), '王');
      expect(u.getGivenName(), '小明');
      expect(u.fullname, '王小明');
    });

    test('surname list contains top Chinese surnames', () {
      final names = Username.cn().topSurNames;
      expect(names, contains('王'));
      expect(names, contains('李'));
      expect(names, contains('张'));
    });

    test('getFullnames repeats fullname', () {
      final u = Username.cn(surName: '刘', givenName: '强');
      expect(u.getFullnames(), ['刘强']);
      expect(u.getFullnames(count: 3),
          ['刘强', '刘强', '刘强']);
    });
  });

  group('Username.en', () {
    test('random fullname is given name then surname', () {
      final u = Username.en();
      final fullName = u.fullname;
      expect(fullName.split(' ').length, 2);
      expect(u.topSurNames, isNotEmpty);
      expect(u.topGivenNames, isNotEmpty);
    });

    test('fixed values are kept', () {
      final u = Username.en(surName: 'Smith', givenName: 'John');
      expect(u.fullname, 'John Smith');
      expect(u.toString(), 'John Smith');
    });

    test('surname list contains top English surnames', () {
      final names = Username.en().topSurNames;
      expect(names, contains('Smith'));
      expect(names, contains('Johnson'));
    });
  });

  group('Username helpers', () {
    test('splitCommaString trims spaces', () {
      final u = Username.en();
      expect(u.splitCommaString(' a , b ,c'), ['a', 'b', 'c']);
    });
  });
}
