library image_button;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'asset_image.dart';

class WidgetImageButton extends StatefulWidget {
  const WidgetImageButton({
    Key? key,
    this.onTap,
    required this.imageNormal,
    this.imageHover,
    this.animate = true,
  }) : super(key: key);

  final WidgetAssetImage imageNormal;
  final WidgetAssetImage? imageHover;
  final GestureTapCallback? onTap;
  final bool animate;

  @override
  _WidgetImageButtonState createState() => _WidgetImageButtonState();
}

class _WidgetImageButtonState extends State<WidgetImageButton>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;

  WidgetAssetImage? _image;

  @override
  void initState() {
    _initAnimation();

    _image = widget.imageNormal;

    super.initState();
  }

  void _initAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 120),
      lowerBound: 0.9,
      upperBound: 1,
    )..forward();
    // ..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final scale = _animationController.value;

        return InkWell(
          child: Transform(
            alignment: FractionalOffset.center,
            transform: Matrix4.identity()..scale(scale, scale),
            child: Container(
              child: _image,
            ),
          ),
          onHover: (hover) {
            if (widget.imageHover == null) return;

            setState(() {
              _image = hover ? widget.imageHover : widget.imageNormal;
            });
          },
          onTap: () async {
            if (widget.animate) {
              _animationController.reverse().whenComplete(() {
                _animationController.forward();
              });
            }

            // if (widget.onTap != null) widget.onTap();
            final tap = widget.onTap;
            if (tap != null) tap();
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
