import 'package:flutter/material.dart';
import 'package:ads_mahem/FUNCTIONS/colors.dart';

class SwitchView extends StatefulWidget {
  final ValueChanged<bool> onChange;
  final String backgroundColor;
  const SwitchView(
      {super.key, required this.onChange, this.backgroundColor = "#117DFA"});

  @override
  State<SwitchView> createState() => _SwitchViewState();
}

class _SwitchViewState extends State<SwitchView> {
  bool _isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Switch(
        activeColor: hexToColor(widget.backgroundColor),
        value: _isSelected,
        onChanged: (value) {
          setState(() {
            _isSelected = !_isSelected;
          });
          widget.onChange;
        });
  }
}
