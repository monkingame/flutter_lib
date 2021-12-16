import 'package:flutter/material.dart';
import 'package:username/username.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('username')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            child: Text('用户名'),
            onPressed: () {
              final user2 = Username.cn();
              // print(user2.fullname);

              final user3 = Username.cn();
              // print(user3.getFullnames(count: 10));

              final user4 = Username.cn(surName: '王');
              // print(user4.getFullnames(count: 10));

              final user5 = Username.en();
              print(user5.getFullnames(count: 10));
            },
          ),
          ElevatedButton(
            child: Text('测试'),
            onPressed: () {
              final names =
                  'Smith,Jones,Taylor,Brown,Williams,Wilson,Johnson,Davies,Robinson,Wright,Thompson,Evans,Walker,White,Roberts,Green,Hall,Wood,Jackson,Clark,Brown,Smith,Patel,Jones,Williams,Johnson,Taylor,Thomas,Roberts,Khan,Lewis,Jackson,Clarke,James,Phillips,Wilson,Ali,Mason,Mitchell,Rose,Davis,Davies,Rodríguez,Cox,Alexander,Wilson,Campbell,Kelly,Johnston,Moore,Thompson,Smyth,Brown,ONeill,Doherty,Stewart,Quinn,Robinson,Murphy,Graham,Martin,McLaughlin,Hamilton,Murray,Hughes,Smith,Brown,Wilson,Robertson,Thomson,Campbell,Stewart,Anderson,Scott,Murray,MacDonald,Reid,Taylor,Clark,Ross,Young,Mitchell,Watson,Paterson,Morrison,Jones,Williams,Davies,Evans,Thomas,Roberts,Lewis,Hughes,Morgan,Griffiths,Edwards,Smith,James,Rees,Jenkins,Owen,Price,Phillips,Moss,Driscoll,Smith,Johnson,Williams,Brown,Jones,Miller,Davis,Garcia,Rodriguez,Wilson,Martinez,Anderson,Taylor,Thomas,Hernandez,Moore,Martin,Jackson,Thompson,White,Lopez,Lee,Gonzalez,Harris,Clark,Lewis,Robinson,Walker,Perez,Hall,Young,Allen,Sanchez,Wright,King,Scott,Green,Baker,Adams,Nelson,Hill,Ramirez,Campbell,Mitchell,Roberts,Carter,Phillips,Evans,Turner,Torres,Parker,Collins,Edwards,Stewart,Flores,Morris,Nguyen,Murphy,Rivera,Cook,Rogers,Morgan,Peterson,Cooper,Reed,Bailey,Bell,Gomez,Kelly,Howard,Ward,Cox,Diaz,Richardson,Wood,Watson,Brooks,Bennett,Gray,James,Reyes,Cruz,Hughes,Price,Myers,Long,Foster,Sanders,Ross,Morales,Powell,Sullivan,Russell,Ortiz,Jenkins,Gutierrez,Perry,Butler,Barnes,Fisher,';
              print(names.split(',').toSet().toList());
            },
          ),
        ],
      ),
    );
  }
}
