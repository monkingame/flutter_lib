import 'username.dart';

class CNUsername extends Username {
  // final String? surName;
  // final String? firstName;
  CNUsername({String? surName, String? givenName})
      : super(surName: surName, givenName: givenName);

  // String getSurName() {
  //   if (surName != null) return surName!;
  //   final rand = Random();
  //   final index = rand.nextInt(topSurNames.length);
  //   return topSurNames[index];
  // }

  // String getFirstName() {
  //   if (firstName != null) return firstName!;
  //   final rand = Random();
  //   final index = rand.nextInt(topFirstNames.length);
  //   return topFirstNames[index];
  // }

  // String get fullname => getSurName() + getFirstName();

  // List<String> getFullnames(int count) {
  //   if (count <= 0) return [fullname];
  //   final list = List.generate(count, (_) => fullname);
  //   return list;
  // }

  // 姓氏
  List<String> get topSurNames {
    final names =
        '王,李,张,刘,陈,杨,黄,赵,吴,周,徐,孙,马,朱,胡,郭,何,高,林,郑,谢,罗,梁,宋,唐,许,韩,冯,邓,曹,彭,曾,蕭,田,董,袁,潘,于,蒋,蔡,余,杜,叶,程,苏,魏,吕,丁,任,沈,姚,卢,姜,崔,钟,谭,陆,汪,范,金,石,廖,贾,夏,韦,付,方,白,邹,孟,熊,秦,邱,江,尹,薛,闫,段,雷,侯,龙,史,陶,黎,贺,顾,毛,郝,龚,邵,万,钱,严,覃,武,戴,莫,孔,向,汤';

    return names.split(',');
  }

  // 名称
  List<String> get topFirstNames {
    final names =
        '建国,建华,国华,和平,明,建平,军,平,志明,徳明,勇,伟,建军,强,斌,刚,涛,波,辉,磊,超,鹏,杰,浩,鑫,帅,俊杰,宇,浩然,浩宇,宇轩,子轩,宇航,皓轩,子豪,浩轩,子涵,秀英,桂英,秀兰,玉兰,桂兰,秀珍,凤英,玉珍,玉英,兰英,英,萍,玉梅,红,丽,敏,艳,芳,静,霞,红梅,燕,娟,娜,丹,玲,婷,婷婷,雪,倩,欣怡,悦,佳怡,颖,雨欣,梓涵,诗涵,梓宣,紫涵,雨涵,一诺';
    return names.split(',');
  }
}
