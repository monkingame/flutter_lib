import 'package:flutter/cupertino.dart';

import 'image_loader.dart';

typedef void OnSizeChanged(Size size);

/// widget asset image
class WidgetAssetImage extends StatefulWidget {
  /// asset path
  final String assetPath;

  /// crop image from asset image
  final Rect? cropRect;

  /// image size changed event
  final OnSizeChanged? onSizeChanged;

  /// scale to device ratio
  final bool scaleDeviceRatio;

  const WidgetAssetImage({
    Key? key,
    required this.assetPath,
    this.cropRect,
    this.scaleDeviceRatio = true,
    this.onSizeChanged,
  }) : super(key: key);

  @override
  _WidgetAssetImageState createState() => _WidgetAssetImageState();
}

class _WidgetAssetImageState extends State<WidgetAssetImage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Image?>(
      builder: (context, snap) {
        if (!snap.hasData) return Container();
        // if (snap.data == null) return Container();
        final image = snap.data;
        if (image == null) return Container();

        var ratio = MediaQuery.of(context).devicePixelRatio;
        if (ratio == 0) ratio = 1;
        if (!widget.scaleDeviceRatio) ratio = 1;

        // final width = image.width / ratio;
        // final height = image.height / ratio;

        final imageWidth = image.width;
        final imageHeight = image.height;
        final width = imageWidth == null ? null : imageWidth / ratio;
        final height = imageHeight == null ? null : imageHeight / ratio;

        // if (widget.onSizeChanged != null) {
        //   widget.onSizeChanged(Size(width, height));
        // }
        final onChanged = widget.onSizeChanged;
        if (onChanged != null && width != null && height != null) {
          onChanged(Size(width, height));
        }

        return Container(
          child: snap.data,
          width: width,
          height: height,
        );
      },
      future: ImageLoader.load(
        assetPath: widget.assetPath,
        cropRect: widget.cropRect,
      ),
    );
  }
}
