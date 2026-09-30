import 'package:asset_button/image_loader.dart';
import 'package:asset_button/widget_asset_image.dart';
import 'package:asset_button/widget_image_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const pngAsset = 'test/assets/tiny.png'; // 4x4
  const cropAsset = 'test/assets/tiny_crop.png'; // 8x8

  group('ImageLoader', () {
    test('load returns an Image widget with the asset size', () async {
      final image = await ImageLoader.load(assetPath: pngAsset);
      expect(image, isNotNull);
      final widget = image!;
      expect(widget.width, 4.0);
      expect(widget.height, 4.0);
      expect(widget.image, isNotNull);
    });

    test('load with cropRect returns cropped size', () async {
      final image = await ImageLoader.load(
        assetPath: cropAsset,
        cropRect: const Rect.fromLTWH(0, 0, 4, 4),
      );
      expect(image, isNotNull);
      expect(image!.width, 4.0);
      expect(image.height, 4.0);
    });
  });

  group('WidgetAssetImage', () {
    testWidgets('displays loaded image and reports size', (WidgetTester tester) async {
      Size? reportedSize;
      await tester.pumpWidget(
        MaterialApp(
          home: WidgetAssetImage(
            assetPath: pngAsset,
            scaleDeviceRatio: false,
            onSizeChanged: (size) => reportedSize = size,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Image), findsOneWidget);
      final image = tester.widget<Image>(find.byType(Image));
      expect(image.width, 4.0);
      expect(image.height, 4.0);
      expect(reportedSize, const Size(4, 4));
    });
  });

  group('WidgetImageButton', () {
    testWidgets('tap invokes onTap', (WidgetTester tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: WidgetImageButton(
                key: const ValueKey('button'),
                onTap: () => tapped = true,
                imageNormal: WidgetAssetImage(
                  assetPath: pngAsset,
                  scaleDeviceRatio: false,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('button')));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('shows normal image and switches to hover image on hover',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: WidgetImageButton(
                key: const ValueKey('button'),
                imageNormal: WidgetAssetImage(
                  assetPath: pngAsset,
                  scaleDeviceRatio: false,
                ),
                imageHover: WidgetAssetImage(
                  key: const ValueKey('hover-image'),
                  assetPath: cropAsset,
                  scaleDeviceRatio: false,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Initially only the normal image is shown.
      expect(find.byKey(const ValueKey('hover-image')), findsNothing);

      // Move a mouse pointer onto the button.
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: const Offset(10, 10));
      await tester.pump(const Duration(milliseconds: 50));
      await gesture.moveTo(tester.getCenter(find.byKey(const ValueKey('button'))));
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.byKey(const ValueKey('hover-image')), findsOneWidget);

      // Move out again: hover image disappears.
      await gesture.moveTo(const Offset(10, 10));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 600));
      expect(find.byKey(const ValueKey('hover-image')), findsNothing);
    });
  });
}
