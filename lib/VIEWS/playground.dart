import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:koukoku_ads/COMPONENTS/accordion_view.dart';
import 'package:koukoku_ads/COMPONENTS/blur_view.dart';
import 'package:koukoku_ads/COMPONENTS/button_view.dart';
import 'package:koukoku_ads/COMPONENTS/calendar_view.dart';
import 'package:koukoku_ads/COMPONENTS/checkbox_view.dart';
import 'package:koukoku_ads/COMPONENTS/dropdown_view.dart';
import 'package:koukoku_ads/COMPONENTS/fade_view.dart';
import 'package:koukoku_ads/COMPONENTS/loading_view.dart';
import 'package:koukoku_ads/COMPONENTS/main_view.dart';
import 'package:koukoku_ads/COMPONENTS/map_view.dart';
import 'package:koukoku_ads/COMPONENTS/padding_view.dart';
import 'package:koukoku_ads/COMPONENTS/pager_view.dart';
import 'package:koukoku_ads/COMPONENTS/qrcode_view.dart';
import 'package:koukoku_ads/COMPONENTS/roundedcorners_view.dart';
import 'package:koukoku_ads/COMPONENTS/scrollable_view.dart';
import 'package:koukoku_ads/COMPONENTS/segmented_view.dart';
import 'package:koukoku_ads/COMPONENTS/separated_view.dart';
import 'package:koukoku_ads/COMPONENTS/split_view.dart';
import 'package:koukoku_ads/COMPONENTS/switch_view.dart';
import 'package:koukoku_ads/COMPONENTS/text_view.dart';
import 'package:koukoku_ads/FUNCTIONS/colors.dart';
import 'package:koukoku_ads/FUNCTIONS/date.dart';
import 'package:koukoku_ads/FUNCTIONS/media.dart';
import 'package:koukoku_ads/FUNCTIONS/misc.dart';
import 'package:koukoku_ads/FUNCTIONS/recorder.dart';
import 'package:koukoku_ads/FUNCTIONS/server.dart';
import 'package:koukoku_ads/MODELS/coco.dart';
import 'package:koukoku_ads/MODELS/constants.dart';
import 'package:koukoku_ads/MODELS/DATAMASTER/datamaster.dart';
import 'package:koukoku_ads/MODELS/firebase.dart';
import 'package:koukoku_ads/MODELS/screen.dart';
import 'package:record/record.dart';

class PlaygroundView extends StatefulWidget {
  final DataMaster dm;
  const PlaygroundView({super.key, required this.dm});

  @override
  State<PlaygroundView> createState() => _PlaygroundViewState();
}

class _PlaygroundViewState extends State<PlaygroundView> {
  @override
  Widget build(BuildContext context) {
    return MainView(dm: widget.dm, children: [
      const PaddingView(
        child: Center(
          child: TextView(
            text: "Hello! This is the IIC Flutter App Template",
          ),
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      ButtonView(
          child: const TextView(
            text: 'Press Me',
          ),
          onPress: () {
            function_ScanQRCode(context);
          }),
      const SizedBox(
        height: 10,
      ),
    ]);
  }
}
