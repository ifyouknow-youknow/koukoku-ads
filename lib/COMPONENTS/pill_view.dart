import 'package:flutter/material.dart';
import 'package:koukoku_ads/COMPONENTS/padding_view.dart';
import 'package:koukoku_ads/COMPONENTS/roundedcorners_view.dart';

class PillView extends StatefulWidget {
  final Widget child;
  final Color backgroundColor;
  final double paddingV;
  final double paddingH;
  const PillView(
      {super.key,
      required this.child,
      this.backgroundColor = Colors.black12,
      this.paddingV = 8,
      this.paddingH = 18});

  @override
  State<PillView> createState() => _PillViewState();
}

class _PillViewState extends State<PillView> {
  @override
  Widget build(BuildContext context) {
    return RoundedCornersView(
        backgroundColor: widget.backgroundColor,
        topLeft: 100,
        topRight: 100,
        bottomLeft: 100,
        bottomRight: 100,
        child: PaddingView(
            paddingTop: widget.paddingV,
            paddingBottom: widget.paddingV,
            paddingLeft: widget.paddingH,
            paddingRight: widget.paddingH,
            child: widget.child));
  }
}
