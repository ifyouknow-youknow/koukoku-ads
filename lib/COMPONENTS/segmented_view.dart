import 'package:flutter/material.dart';
import 'package:koukoku_ads/COMPONENTS/text_view.dart';
import 'package:koukoku_ads/FUNCTIONS/colors.dart';

class SegmentedView extends StatefulWidget {
  final List<String> options;
  final String value;
  final Function(String) setter;
  final Color borderColor;
  final double borderWidth;
  final Color selectedColor;
  final double textSize;
  final double paddingV;
  final double paddingH;

  const SegmentedView({
    super.key,
    required this.options,
    required this.value,
    required this.setter,
    this.borderColor = Colors.black,
    this.borderWidth = 2.0,
    this.selectedColor = Colors.black,
    this.textSize = 16.0,
    this.paddingV = 6.0,
    this.paddingH = 14.0,
  });

  @override
  _SegmentedViewState createState() => _SegmentedViewState();
}

class _SegmentedViewState extends State<SegmentedView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: widget.options.map((option) {
          return GestureDetector(
            onTap: () {
              widget.setter(option);
            },
            child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: widget.paddingV,
                  horizontal: widget.paddingH,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: widget.value == option
                          ? widget.borderColor
                          : Colors.transparent,
                      width: widget.borderWidth,
                    ),
                  ),
                ),
                child: TextView(
                  text: option,
                  color: widget.value == option
                      ? widget.selectedColor
                      : Colors.black,
                )),
          );
        }).toList(),
      ),
    );
  }
}
