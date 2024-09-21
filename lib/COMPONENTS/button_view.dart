import 'package:flutter/material.dart';

class ButtonView extends StatefulWidget {
  final Widget child;
  final Color backgroundColor;
  final double radius;
  final double paddingTop;
  final double paddingLeft;
  final double paddingRight;
  final double paddingBottom;
  final VoidCallback onPress;
  final bool isDisabled;

  const ButtonView({
    super.key,
    required this.child,
    this.backgroundColor = Colors.transparent,
    this.radius = 0.0,
    this.paddingTop = 0.0,
    this.paddingLeft = 0.0,
    this.paddingRight = 0.0,
    this.paddingBottom = 0.0,
    required this.onPress,
    this.isDisabled = false,
  });

  @override
  _ButtonViewState createState() => _ButtonViewState();
}

class _ButtonViewState extends State<ButtonView> {
  double _opacity = 1.0;

  void _onTapDown(TapDownDetails details) {
    if (!widget.isDisabled) {
      setState(() {
        _opacity = 0.6; // Reduce opacity on tap down
      });
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (!widget.isDisabled) {
      setState(() {
        _opacity = 1.0; // Restore opacity on tap up
      });
    }
  }

  void _onTapCancel() {
    if (!widget.isDisabled) {
      setState(() {
        _opacity = 1.0; // Restore opacity if tap is cancelled
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.isDisabled ? null : widget.onPress,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 100),
        opacity: widget.isDisabled ? 0.5 : _opacity,
        child: Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(widget.radius),
          ),
          padding: EdgeInsets.only(
            top: widget.paddingTop,
            left: widget.paddingLeft,
            right: widget.paddingRight,
            bottom: widget.paddingBottom,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
