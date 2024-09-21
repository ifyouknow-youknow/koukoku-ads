import 'package:flutter/material.dart';
import 'package:koukoku_ads/COMPONENTS/padding_view.dart';
import 'package:koukoku_ads/COMPONENTS/roundedcorners_view.dart';
import 'package:koukoku_ads/COMPONENTS/text_view.dart';
import 'package:koukoku_ads/MODELS/screen.dart';

class BubbleView extends StatefulWidget {
  final IconData icon;
  final String text;
  final Color backgroundColor;
  final double iconSize;
  final Color iconColor;
  final double textSize;
  final Color textColor;

  const BubbleView(
      {super.key,
      this.icon = Icons.verified_outlined,
      this.text = 'We live inside the bagel. The nothing bagel.',
      this.backgroundColor = Colors.black12,
      this.iconSize = 20,
      this.iconColor = Colors.blueGrey,
      this.textSize = 14,
      this.textColor = Colors.black});

  @override
  State<BubbleView> createState() => _BubbleViewState();
}

class _BubbleViewState extends State<BubbleView> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10,
      child: SizedBox(
        width: getWidth(context),
        child: PaddingView(
          paddingTop: 0,
          paddingBottom: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoundedCornersView(
                  topLeft: 100,
                  topRight: 100,
                  bottomLeft: 100,
                  bottomRight: 100,
                  backgroundColor: widget.backgroundColor,
                  child: PaddingView(
                    paddingTop: 8,
                    paddingBottom: 8,
                    paddingLeft: 12,
                    paddingRight: 12,
                    child: Row(
                      children: [
                        Icon(
                          widget.icon,
                          size: widget.iconSize,
                          color: widget.iconColor,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        TextView(
                          text: widget.text,
                          wrap: true,
                          size: widget.textSize,
                          color: widget.textColor,
                        )
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
