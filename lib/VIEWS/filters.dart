import 'package:flutter/material.dart';
import 'package:koukoku_ads/COMPONENTS/button_view.dart';
import 'package:koukoku_ads/COMPONENTS/main_view.dart';
import 'package:koukoku_ads/COMPONENTS/padding_view.dart';
import 'package:koukoku_ads/COMPONENTS/slider_view.dart';
import 'package:koukoku_ads/COMPONENTS/text_view.dart';
import 'package:koukoku_ads/FUNCTIONS/nav.dart';
import 'package:koukoku_ads/MODELS/DATAMASTER/datamaster.dart';

class Filters extends StatefulWidget {
  final DataMaster dm;
  const Filters({super.key, required this.dm});

  @override
  State<Filters> createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  @override
  Widget build(BuildContext context) {
    return MainView(dm: widget.dm, children: [
      PaddingView(
        child: Row(
          children: [
            ButtonView(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chevron_left,
                      size: 26,
                    ),
                    TextView(
                      text: 'back',
                      size: 18,
                    )
                  ],
                ),
                onPress: () {
                  nav_Pop(context);
                })
          ],
        ),
      ),
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // DISTANCE
              PaddingView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextView(
                      text: 'Distance',
                      size: 22,
                      weight: FontWeight.w400,
                      spacing: -1,
                    ),
                  ],
                ),
              ),
              SliderView(min: 1, max: 30, increment: 1),
              // LOCATION
              PaddingView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextView(
                      text: 'Location',
                      size: 22,
                      weight: FontWeight.w400,
                      spacing: -1,
                    ),
                  ],
                ),
              ),
              // CATEGORIES
              PaddingView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextView(
                      text: 'Categories',
                      size: 22,
                      weight: FontWeight.w400,
                      spacing: -1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
