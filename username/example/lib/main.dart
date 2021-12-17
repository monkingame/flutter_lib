import 'package:flutter/material.dart';
import 'package:username/username.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      MaterialApp(home: MyHomePage(), debugShowCheckedModeBanner: false);
}

class MyHomePage extends StatelessWidget {
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
      body: Center(
          child: ElevatedButton(child: Text('username'), onPressed: onTap)),
    );
  }
}
