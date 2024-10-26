import 'package:flutter/material.dart';

class IconButtonView extends StatefulWidget {
  final IconData icon;
  final double iconSize;
  final Color iconColor;
  final Color backgroundColor;
  final double width;
  final VoidCallback onPress;
  final bool isDisabled;

  const IconButtonView({
    super.key,
    required this.icon,
    this.iconSize = 32,
    this.iconColor = Colors.black,
    this.backgroundColor = Colors.black12,
    this.width = 24.0, // Circular shape
    required this.onPress,
    this.isDisabled = false,
  });

  @override
  State<IconButtonView> createState() => _IconButtonViewState();
}

class _IconButtonViewState extends State<IconButtonView> {
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
        duration: const Duration(milliseconds: 100),
        opacity: widget.isDisabled ? 0.5 : _opacity,
        child: Container(
          width: widget.width * 2, // Ensures circular shape
          height: widget.width * 2, // Ensures circular shape
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(widget.width),
          ),
          child: Center(
            child: Icon(
              widget.icon,
              size: widget.iconSize,
              color: widget.iconColor,
            ),
          ),
        ),
      ),
    );
  }
}
