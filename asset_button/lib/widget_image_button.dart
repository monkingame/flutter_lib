library asset_button;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widget_asset_image.dart';

/// image button
/// need normal image(necessary) and hover image(not necessary)
class WidgetImageButton extends StatefulWidget {
  const WidgetImageButton({
    Key? key,
    this.onTap,
    required this.imageNormal,
    this.imageHover,
    this.animate = true,
    this.name,
  }) : super(key: key);

  /// image normal
  final WidgetAssetImage imageNormal;

  /// image when mouse hover on the button
  final WidgetAssetImage? imageHover;

  /// tapped event
  final GestureTapCallback? onTap;

  /// if animate when tapped
  final bool animate;

  final String? name;

  @override
  _WidgetImageButtonState createState() => _WidgetImageButtonState();
}

class _WidgetImageButtonState extends State<WidgetImageButton>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    _initAnimation();

    super.initState();
  }

  bool _hover = false;

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
                child: _hover ? widget.imageHover : widget.imageNormal),
          ),
          onHover: (hover) {
            if (widget.imageHover == null) return;

            setState(() {
              _hover = hover;
            });
          },
          onTap: () async {
            if (widget.animate) {
              _animationController.reverse().whenComplete(() {
                _animationController.forward();
              });
            }

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
