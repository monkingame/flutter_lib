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
    final VoidCallback onTap = () {
      // Eli Murphy (actual usernames generated random)
      print(Username.en().fullname);

      // Alexander Robertson, Lincoln Sullivan, Ezekiel Jenkins
      // (actual usernames generated random)
      print(Username.en().getFullnames(count: 3));

      // 姚宇 (实际名称随机产生)
      print(Username.cn().fullname);

      // 李红梅, 李波, 邵玉兰, 史芳, 陶梓涵, 汪超
      // (实际名称随机产生)
      print(Username.cn().getFullnames(count: 6));
    };

    return Scaffold(
      appBar: AppBar(title: Text('username')),
      body: Center(
        child: ElevatedButton(child: Text('usernames'), onPressed: onTap),
      ),
    );
  }
}
