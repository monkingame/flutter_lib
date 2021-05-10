import 'package:flutter/cupertino.dart';

import 'image_loader.dart';

typedef void OnSizeChanged(Size size);

class WidgetAssetImage extends StatefulWidget {
  final String assetPath;
  final Rect? cropRect;
  final OnSizeChanged? onSizeChanged;
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
        if (snap.data == null) return Container();

        var ratio = MediaQuery.of(context).devicePixelRatio;
        if (ratio == 0) ratio = 1;
        if (!widget.scaleDeviceRatio) ratio = 1;

        final width = snap.data.width! / ratio;
        final height = snap.data.height! / ratio;

        if (widget.onSizeChanged != null) {
          widget.onSizeChanged(Size(width, height));
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
