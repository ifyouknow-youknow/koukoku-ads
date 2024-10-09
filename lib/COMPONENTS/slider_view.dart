import 'package:flutter/material.dart';

class SliderView extends StatefulWidget {
  final double min;
  final double max;
  final double increment;
  final void Function(double)? onChange;
  final Color color;

  const SliderView(
      {super.key,
      required this.min,
      required this.max,
      required this.increment,
      this.onChange,
      this.color = Colors.black});

  @override
  State<SliderView> createState() => _SliderViewState();
}

class _SliderViewState extends State<SliderView> {
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    // Initialize the current value to the minimum value
    _currentValue = widget.min;
  }

  @override
  Widget build(BuildContext context) {
    return Slider(
      activeColor: widget.color,
      value: _currentValue,
      min: widget.min,
      max: widget.max,
      divisions: ((widget.max - widget.min) / widget.increment).round(),
      onChanged: (value) {
        setState(() {
          _currentValue = value;
        });
        if (widget.onChange != null) {
          widget.onChange!(value);
        }
      },
    );
  }
}
