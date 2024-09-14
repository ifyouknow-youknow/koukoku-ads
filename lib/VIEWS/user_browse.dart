import 'package:flutter/material.dart';
import 'package:koukoku_ads/COMPONENTS/asyncimage_view.dart';
import 'package:koukoku_ads/COMPONENTS/button_view.dart';
import 'package:koukoku_ads/COMPONENTS/future_view.dart';
import 'package:koukoku_ads/COMPONENTS/image_view.dart';
import 'package:koukoku_ads/COMPONENTS/main_view.dart';
import 'package:koukoku_ads/COMPONENTS/padding_view.dart';
import 'package:koukoku_ads/COMPONENTS/text_view.dart';
import 'package:koukoku_ads/FUNCTIONS/nav.dart';
import 'package:koukoku_ads/MODELS/DATAMASTER/datamaster.dart';
import 'package:koukoku_ads/MODELS/constants.dart';
import 'package:koukoku_ads/MODELS/firebase.dart';
import 'package:koukoku_ads/VIEWS/login.dart';
import 'package:koukoku_ads/MODELS/screen.dart';

class UserBrowse extends StatefulWidget {
  final DataMaster dm;
  const UserBrowse({super.key, required this.dm});

  @override
  State<UserBrowse> createState() => _UserBrowseState();
}

class _UserBrowseState extends State<UserBrowse> {
  //
  Future<List<dynamic>> _fetchLocalAds() async {
    var oneByOne = [];
    var oneByTwo = [];
    var twoByTwo = [];

    // Fetch documents from Firebase, ordered by 'date'
    final docs = await firebase_GetAllDocumentsOrdered(
        '${appName}_Campaigns', 'date', 'desc');

    // Categorize ads by 'chosenOption'
    for (var doc in docs) {
      if (doc['chosenOption'] == '1 x 1') {
        oneByOne.add(doc);
      } else if (doc['chosenOption'] == '2 x 1') {
        oneByTwo.add(doc);
      } else if (doc['chosenOption'] == '2 x 2') {
        twoByTwo.add(doc);
      }
    }

    var allOfThem = [];
    int index1x1 = 0, index2x1 = 0, index2x2 = 0;

    // Loop through the lists and add items to allOfThem
    while ((index1x1 + 1 < oneByOne.length) ||
        index2x1 < oneByTwo.length ||
        index2x2 < twoByTwo.length) {
      if (index1x1 + 1 < oneByOne.length) {
        allOfThem.add(oneByOne[index1x1++]);
        allOfThem.add(oneByOne[index1x1++]);
      }

      if (index2x1 < oneByTwo.length) {
        allOfThem.add(oneByTwo[index2x1++]);
      }

      if (index2x2 < twoByTwo.length) {
        allOfThem.add(twoByTwo[index2x2++]);
      }
    }

    // Add any remaining 1x1 ads (pair-wise)
    while (index1x1 + 1 < oneByOne.length) {
      allOfThem.add(oneByOne[index1x1++]);
      allOfThem.add(oneByOne[index1x1++]);
    }

    // If there's exactly one 1x1 ad left, add it at the end
    if (index1x1 < oneByOne.length) {
      allOfThem.add(oneByOne[index1x1]);
    }

    return allOfThem;
  }

  List<Widget> buildAdWidgets(BuildContext context, ads) {
    List<Widget> widgets = [];
    for (int i = 0; i < ads.length; i++) {
      if (ads[i]['chosenOption'] == '2 x 2') {
        widgets.add(
          PaddingView(
            paddingTop: 5,
            paddingBottom: 5,
            paddingLeft: 10,
            paddingRight: 10,
            child: ButtonView(
              radius: 10,
              onPress: () {
                // nav_Push(context, BusinessProfile(dm: widget.dm, ad: ads[i]),
                //     () {
                //   setState(() {});
                // });
              },
              child: AsyncImageView(
                radius: 10,
                imagePath: ads[i]['imagePath'],
                width: getWidth(context),
                height: getWidth(context),
                objectFit: BoxFit.fill,
              ),
            ),
          ),
        );
      } else if (ads[i]['chosenOption'] == '2 x 1') {
        widgets.add(
          PaddingView(
            paddingTop: 5,
            paddingBottom: 5,
            paddingLeft: 10,
            paddingRight: 10,
            child: ButtonView(
              radius: 10,
              onPress: () {
                // nav_Push(context, BusinessProfile(dm: widget.dm, ad: ads[i]),
                //     () {
                //   setState(() {});
                // });
              },
              child: AsyncImageView(
                radius: 10,
                imagePath: ads[i]['imagePath'],
                width: getWidth(context),
                height: getWidth(context) / 2,
                objectFit: BoxFit.fill,
              ),
            ),
          ),
        );
      } else if (ads[i]['chosenOption'] == '1 x 1' &&
          i + 1 < ads.length &&
          ads[i + 1]['chosenOption'] == '1 x 1') {
        // Add two consecutive '1 x 1' ads side by side
        widgets.add(
          PaddingView(
            paddingTop: 5,
            paddingBottom: 5,
            paddingLeft: 10,
            paddingRight: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ButtonView(
                    onPress: () {
                      // nav_Push(context,
                      //     BusinessProfile(dm: widget.dm, ad: ads[i - 1]), () {
                      //   setState(() {});
                      // });
                    },
                    child: AsyncImageView(
                      radius: 10,
                      imagePath: ads[i]['imagePath'],
                      width: getWidth(context) / 2,
                      height: getWidth(context) / 2,
                      objectFit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ButtonView(
                    onPress: () {
                      // nav_Push(
                      //     context, BusinessProfile(dm: widget.dm, ad: ads[i]),
                      //     () {
                      //   setState(() {});
                      // });
                    },
                    child: AsyncImageView(
                      radius: 10,
                      imagePath: ads[i + 1]['imagePath'],
                      width: getWidth(context) / 2,
                      height: getWidth(context) / 2,
                      objectFit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
        i++; // Skip the next ad as it has been processed
      } else if (ads[i]['chosenOption'] == '1 x 1') {
        // Handle a single '1 x 1' ad when no pair is available
        widgets.add(
          PaddingView(
            paddingTop: 5,
            paddingBottom: 5,
            paddingLeft: 10,
            paddingRight: 10,
            child: Row(
              children: [
                Expanded(
                  child: ButtonView(
                    onPress: () {
                      // nav_Push(
                      //     context, BusinessProfile(dm: widget.dm, ad: ads[i]),
                      //     () {
                      //   setState(() {});
                      // });
                    },
                    child: AsyncImageView(
                      radius: 10,
                      imagePath: ads[i]['imagePath'],
                      width: getWidth(context) / 2,
                      height: getWidth(context) / 2,
                      objectFit: BoxFit.fill,
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        );
      }
    }
    return widgets;
  }

  @override
  void initState() {
    super.initState();
    _fetchLocalAds();
  }

  @override
  Widget build(BuildContext context) {
    return MainView(dm: widget.dm, children: [
      PaddingView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                ImageView(
                  imagePath: 'assets/logo.png',
                  width: 30,
                  height: 30,
                  radius: 6,
                ),
                SizedBox(
                  width: 6,
                ),
                TextView(
                  text: 'Explore',
                  size: 18,
                  weight: FontWeight.w500,
                  wrap: false,
                ),
              ],
            ),
            ButtonView(
                child: const Row(
                  children: [
                    TextView(
                      text: 'log in',
                      size: 18,
                      weight: FontWeight.w500,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.arrow_forward,
                      size: 20,
                    )
                  ],
                ),
                onPress: () {
                  nav_PushAndRemove(context, Login(dm: widget.dm));
                })
          ],
        ),
      ),
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureView(
                future: _fetchLocalAds(),
                childBuilder: (ads) {
                  return Column(
                    children: [...buildAdWidgets(context, ads)],
                  );
                },
                emptyWidget: const TextView(
                  text: 'No ads available in your area.',
                ),
              ),
              const SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
    ]);
  }
}
