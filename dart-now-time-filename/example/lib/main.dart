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
            // 20210510-181946-116-061
            print(NowFilename.gen());
            // genNowFilename() is deprecated. use gen() instead.
            print(NowFilename.genNowFilename());

            // header-20210510-181946-118-059
            print(NowFilename.gen(prefix: 'header-'));

            // 20210510-181946-118-059.mp3
            print(NowFilename.gen(ext: '.mp3'));

            // header-20210510-181946-118-059.mp3
            print(NowFilename.gen(prefix: 'header-', ext: '.mp3'));

            // header-20210510@181946@119@058.mp3
            print(NowFilename.gen(
                prefix: 'header-', ext: '.mp3', seperator: '@'));

            // 20210510181946119058.mp3
            print(NowFilename.gen(ext: '.mp3', seperator: null));
          },
        ),
      ),
    );
  }
}
