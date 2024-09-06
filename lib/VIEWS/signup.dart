import 'package:flutter/material.dart';
import 'package:koukoku_ads/COMPONENTS/button_view.dart';
import 'package:koukoku_ads/COMPONENTS/main_view.dart';
import 'package:koukoku_ads/COMPONENTS/padding_view.dart';
import 'package:koukoku_ads/COMPONENTS/text_view.dart';
import 'package:koukoku_ads/FUNCTIONS/colors.dart';
import 'package:koukoku_ads/FUNCTIONS/nav.dart';
import 'package:koukoku_ads/MODELS/DATAMASTER/datamaster.dart';

class SignUp extends StatefulWidget {
  final DataMaster dm;
  const SignUp({super.key, required this.dm});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return MainView(
        backgroundColor: hexToColor("#FF1F54"),
        dm: widget.dm,
        children: [
          PaddingView(
            child: Row(
              children: [
                ButtonView(
                  onPress: () {
                    nav_Pop(context);
                  },
                  child: TextView(
                    text: 'back',
                    size: 16,
                    color: Colors.white,
                    weight: FontWeight.w500,
                  ),
                )
              ],
            ),
          )
        ]);
  }
}
