import 'username.dart';

class ENUsername extends Username {
  ENUsername({String? surName, String? givenName})
      : super(surName: surName, givenName: givenName);

  String get fullname => getSurName() + getGivenName();

  // 姓氏
  List<String> get topSurNames {
    final names =
        'Smith, Jones, Taylor, Brown, Williams, Wilson, Johnson, Davies, Robinson, Wright, Thompson, Evans, Walker, White, Roberts, Green, Hall, Wood, Jackson, Clark, Patel, Thomas, Khan, Lewis, Clarke, James, Phillips, Ali, Mason, Mitchell, Rose, Davis, Rodríguez, Cox, Alexander, Campbell, Kelly, Johnston, Moore, Smyth, ONeill, Doherty, Stewart, Quinn, Murphy, Graham, Martin, McLaughlin, Hamilton, Murray, Hughes, Robertson, Thomson, Anderson, Scott, MacDonald, Reid, Ross, Young, Watson, Paterson, Morrison, Morgan, Griffiths, Edwards, Rees, Jenkins, Owen, Price, Moss, Driscoll, Miller, Garcia, Rodriguez, Martinez, Hernandez, Lopez, Lee, Gonzalez, Harris, Perez, Allen, Sanchez, King, Baker, Adams, Nelson, Hill, Ramirez, Carter, Turner, Torres, Parker, Collins, Flores, Morris, Nguyen, Rivera, Cook, Rogers, Peterson, Cooper, Reed, Bailey, Bell, Gomez, Howard, Ward, Diaz, Richardson, Brooks, Bennett, Gray, Reyes, Cruz, Myers, Long, Foster, Sanders, Morales, Powell, Sullivan, Russell, Ortiz, Gutierrez, Perry, Butler, Barnes, Fisher';

    // return names.split(',');
    return splitCommaString(names);
  }

  // 名称
  List<String> get topGivenNames {
    final names = '';

    return names.split(',');
  }
}
