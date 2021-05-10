import 'package:dart_now_time_filename/dart_now_time_filename.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyHomePage());
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
      appBar: AppBar(title: Text('now file name')),
      body: Center(
        child: ElevatedButton(
          child: Text('now time filename'),
          onPressed: () {
            // 20210508-084919-305-149
            print(NowFilename.gen());

            // header-20210508-084919-314-149
            print(NowFilename.gen(prefix: 'header-'));

            // 20210508-084919-314-149.mp3
            print(NowFilename.gen(ext: '.mp3'));

            // header-20210508-084919-314-149.mp3
            print(NowFilename.gen(prefix: 'header-', ext: '.mp3'));

            // header-20210508@084919@314@149.mp3
            print(NowFilename.genNowFilename(
                prefix: 'header-', ext: '.mp3', seperator: '@'));

            // 20210508084919314149.mp3
            print(NowFilename.gen(ext: '.mp3', seperator: null));
          },
        ),
      ),
    );
  }
}
