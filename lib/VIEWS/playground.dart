import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iic_app_template_flutter/COMPONENTS/accordion_view.dart';
import 'package:iic_app_template_flutter/COMPONENTS/blur_view.dart';
import 'package:iic_app_template_flutter/COMPONENTS/button_view.dart';
import 'package:iic_app_template_flutter/COMPONENTS/calendar_view.dart';
import 'package:iic_app_template_flutter/COMPONENTS/checkbox_view.dart';
import 'package:iic_app_template_flutter/COMPONENTS/dropdown_view.dart';
import 'package:iic_app_template_flutter/COMPONENTS/fade_view.dart';
import 'package:iic_app_template_flutter/COMPONENTS/loading_view.dart';
import 'package:iic_app_template_flutter/COMPONENTS/main_view.dart';
import 'package:iic_app_template_flutter/COMPONENTS/map_view.dart';
import 'package:iic_app_template_flutter/COMPONENTS/padding_view.dart';
import 'package:iic_app_template_flutter/COMPONENTS/pager_view.dart';
import 'package:iic_app_template_flutter/COMPONENTS/qrcode_view.dart';
import 'package:iic_app_template_flutter/COMPONENTS/roundedcorners_view.dart';
import 'package:iic_app_template_flutter/COMPONENTS/scrollable_view.dart';
import 'package:iic_app_template_flutter/COMPONENTS/segmented_view.dart';
import 'package:iic_app_template_flutter/COMPONENTS/separated_view.dart';
import 'package:iic_app_template_flutter/COMPONENTS/split_view.dart';
import 'package:iic_app_template_flutter/COMPONENTS/switch_view.dart';
import 'package:iic_app_template_flutter/COMPONENTS/text_view.dart';
import 'package:iic_app_template_flutter/FUNCTIONS/colors.dart';
import 'package:iic_app_template_flutter/FUNCTIONS/date.dart';
import 'package:iic_app_template_flutter/FUNCTIONS/media.dart';
import 'package:iic_app_template_flutter/FUNCTIONS/misc.dart';
import 'package:iic_app_template_flutter/FUNCTIONS/recorder.dart';
import 'package:iic_app_template_flutter/FUNCTIONS/server.dart';
import 'package:iic_app_template_flutter/MODELS/coco.dart';
import 'package:iic_app_template_flutter/MODELS/constants.dart';
import 'package:iic_app_template_flutter/MODELS/DATAMASTER/datamaster.dart';
import 'package:iic_app_template_flutter/MODELS/firebase.dart';
import 'package:iic_app_template_flutter/MODELS/screen.dart';
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
