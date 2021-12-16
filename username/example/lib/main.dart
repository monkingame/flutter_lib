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
              // 姚燕(实际名称随机产生)
              print(user2.fullname);

              final user3 = Username.cn();
              // 严梓宣, 秦浩轩, 苏玉英, 曹徳明, 苏鹏, 邵浩轩, 陈子轩, 顾建国, 严玉兰, 高倩
              // (实际名称随机产生)
              print(user3.getFullnames(count: 10));

              final user4 = Username.cn(surName: '王');
              // 王波, 王国华, 王敏, 王俊杰, 王娟, 王宇, 王宇航, 王英, 王婷婷, 王和平
              // (实际名称随机产生)
              print(user4.getFullnames(count: 10));

              final user5 = Username.en();
              // Scarlett Morris, Micah Doherty, Samuel Sullivan, Makayla Turner, Ethan Miller, Braxton Perez, Nevaeh MacDonald, Natalie Bennett, Kayla Carter, Oakley Reyes
              // (actual usernames generated random)
              print(user5.getFullnames(count: 10));
            },
          ),
          ElevatedButton(
            child: Text('测试'),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
