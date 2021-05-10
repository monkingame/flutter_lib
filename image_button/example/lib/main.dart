import 'package:flutter/material.dart';
import 'package:image_button/asset_image.dart';
import 'package:image_button/image_button.dart';

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
      appBar: AppBar(title: Text('image button example')),
      body: Center(
        child: Column(
          children: [
            WidgetAssetImage(assetPath: 'assets/images/bkg_code.png'),
            WidgetImageButton(
              imageNormal:
                  WidgetAssetImage(assetPath: 'assets/images/icon_normal.png'),
              imageHover:
                  WidgetAssetImage(assetPath: 'assets/images/icon_hover.png'),
              onTap: () {
                print('independent icon image button');
              },
            ),
            WidgetImageButton(
              imageNormal: WidgetAssetImage(
                  assetPath: 'assets/images/icons.png',
                  cropRect: Rect.fromLTWH(61, 168, 92, 92)),
              imageHover: WidgetAssetImage(
                  assetPath: 'assets/images/icons.png',
                  cropRect: Rect.fromLTWH(173, 167, 92, 92)),
              onTap: () {
                print('image button icon crop from one image');
              },
            )
          ],
        ),
      ),
    );
  }
}
