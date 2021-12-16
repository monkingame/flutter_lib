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
            final user1 = Username.locale();
            print(user1.fullname);

            final user2 = Username.locale(surName: '王');
            // print(user2.fullname);
          },
        ),
      ),
    );
  }
}
