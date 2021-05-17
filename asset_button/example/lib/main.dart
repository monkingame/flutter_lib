import 'package:asset_button/widget_asset_image.dart';
import 'package:asset_button/widget_image_button.dart';
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
      appBar: AppBar(title: Text('image button example')),
      body: Container(
        color: Colors.blue[900],
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // background image
            WidgetAssetImage(assetPath: 'assets/images/bkg_code.png'),
            // independent icon image
            WidgetImageButton(
              imageNormal:
                  WidgetAssetImage(assetPath: 'assets/images/icon_normal.png'),
              imageHover:
                  WidgetAssetImage(assetPath: 'assets/images/icon_hover.png'),
              onTap: () {
                print('independent icon image button');
              },
            ),
            // icon image crop from one whole image
            WidgetImageButton(
              imageNormal: WidgetAssetImage(
                  assetPath: 'assets/images/icons.png',
                  cropRect: Rect.fromLTWH(58, 165, 95, 95)),
              imageHover: WidgetAssetImage(
                  assetPath: 'assets/images/icons.png',
                  cropRect: Rect.fromLTWH(170, 164, 95, 95)),
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
