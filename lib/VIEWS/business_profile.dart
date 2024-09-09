import 'package:flutter/material.dart';
import 'package:koukoku_ads/COMPONENTS/asyncimage_view.dart';
import 'package:koukoku_ads/COMPONENTS/button_view.dart';
import 'package:koukoku_ads/COMPONENTS/main_view.dart';
import 'package:koukoku_ads/COMPONENTS/padding_view.dart';
import 'package:koukoku_ads/COMPONENTS/text_view.dart';
import 'package:koukoku_ads/FUNCTIONS/nav.dart';
import 'package:koukoku_ads/MODELS/DATAMASTER/datamaster.dart';
import 'package:koukoku_ads/MODELS/constants.dart';
import 'package:koukoku_ads/MODELS/firebase.dart';
import 'package:koukoku_ads/MODELS/screen.dart';

class BusinessProfile extends StatefulWidget {
  final DataMaster dm;
  final Map<String, dynamic> ad;
  const BusinessProfile({super.key, required this.dm, required this.ad});

  @override
  State<BusinessProfile> createState() => _BusinessProfileState();
}

class _BusinessProfileState extends State<BusinessProfile> {
  Map<String, dynamic> businessInfo = {};

  void _fetchBusinessInfo() async {
    final doc = await firebase_GetDocument(
        '${appName}_Businesses', widget.ad['userId']);
    setState(() {
      businessInfo = doc;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchBusinessInfo();
  }

  @override
  Widget build(BuildContext context) {
    return MainView(dm: widget.dm, children: [
      // TOP
      PaddingView(
        child: Row(
          children: [
            ButtonView(
                child: const Row(
                  children: [
                    Icon(
                      Icons.arrow_back,
                      size: 20,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    TextView(
                      text: 'back',
                      size: 18,
                      weight: FontWeight.w500,
                    ),
                  ],
                ),
                onPress: () {
                  nav_Pop(context);
                })
          ],
        ),
      ),
      //  MAIN
      Center(
        child: AsyncImageView(
          imagePath: widget.ad['imagePath'],
          height: getHeight(context) * 0.4,
          objectFit: BoxFit.fill,
          width: getHeight(context) * 0.4,
          radius: 10,
        ),
      )
    ]);
  }
}
