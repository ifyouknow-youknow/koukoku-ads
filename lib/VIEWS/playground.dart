import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ads_mahem/COMPONENTS/accordion_view.dart';
import 'package:ads_mahem/COMPONENTS/blur_view.dart';
import 'package:ads_mahem/COMPONENTS/button_view.dart';
import 'package:ads_mahem/COMPONENTS/calendar_view.dart';
import 'package:ads_mahem/COMPONENTS/checkbox_view.dart';
import 'package:ads_mahem/COMPONENTS/dropdown_view.dart';
import 'package:ads_mahem/COMPONENTS/fade_view.dart';
import 'package:ads_mahem/COMPONENTS/loading_view.dart';
import 'package:ads_mahem/COMPONENTS/main_view.dart';
import 'package:ads_mahem/COMPONENTS/map_view.dart';
import 'package:ads_mahem/COMPONENTS/padding_view.dart';
import 'package:ads_mahem/COMPONENTS/pager_view.dart';
import 'package:ads_mahem/COMPONENTS/qrcode_view.dart';
import 'package:ads_mahem/COMPONENTS/roundedcorners_view.dart';
import 'package:ads_mahem/COMPONENTS/scrollable_view.dart';
import 'package:ads_mahem/COMPONENTS/segmented_view.dart';
import 'package:ads_mahem/COMPONENTS/separated_view.dart';
import 'package:ads_mahem/COMPONENTS/split_view.dart';
import 'package:ads_mahem/COMPONENTS/switch_view.dart';
import 'package:ads_mahem/COMPONENTS/text_view.dart';
import 'package:ads_mahem/FUNCTIONS/colors.dart';
import 'package:ads_mahem/FUNCTIONS/date.dart';
import 'package:ads_mahem/FUNCTIONS/media.dart';
import 'package:ads_mahem/FUNCTIONS/misc.dart';
import 'package:ads_mahem/FUNCTIONS/recorder.dart';
import 'package:ads_mahem/FUNCTIONS/server.dart';
import 'package:ads_mahem/MODELS/coco.dart';
import 'package:ads_mahem/MODELS/constants.dart';
import 'package:ads_mahem/MODELS/DATAMASTER/datamaster.dart';
import 'package:ads_mahem/MODELS/firebase.dart';
import 'package:ads_mahem/MODELS/screen.dart';
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
