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
      body: Center(
        child: ElevatedButton(
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
      ),
    );
  }
}
