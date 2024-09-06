import 'package:flutter/material.dart';
import 'package:koukoku_ads/COMPONENTS/asyncimage_view.dart';
import 'package:koukoku_ads/COMPONENTS/button_view.dart';
import 'package:koukoku_ads/COMPONENTS/future_view.dart';
import 'package:koukoku_ads/COMPONENTS/main_view.dart';
import 'package:koukoku_ads/COMPONENTS/padding_view.dart';
import 'package:koukoku_ads/COMPONENTS/text_view.dart';
import 'package:koukoku_ads/FUNCTIONS/nav.dart';
import 'package:koukoku_ads/MODELS/DATAMASTER/datamaster.dart';
import 'package:koukoku_ads/MODELS/constants.dart';
import 'package:koukoku_ads/MODELS/firebase.dart';
import 'package:koukoku_ads/MODELS/screen.dart';
import 'package:koukoku_ads/VIEWS/login.dart';

class Browse extends StatefulWidget {
  final DataMaster dm;
  const Browse({super.key, required this.dm});

  @override
  State<Browse> createState() => _BrowseState();
}

class _BrowseState extends State<Browse> {
  Future<List<dynamic>> _fetchLocalAds() async {
    var oneByOne = [];
    var oneByTwo = [];
    var twoByTwo = [];

    final docs = await firebase_GetAllDocumentsOrdered(
        '${appName}_Campaigns', 'date', 'desc');

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

    while (index1x1 < oneByOne.length) {
      allOfThem.add(oneByOne[index1x1++]);
    }

    return allOfThem;
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
            const TextView(
              text: 'Browse Ads',
              size: 18,
              weight: FontWeight.w400,
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
          child: FutureView(
            future: _fetchLocalAds(),
            childBuilder: (ads) {
              return Column(
                children: [
                  for (int i = 0; i < ads.length; i++)
                    if (ads[i]['chosenOption'] == '2 x 2')
                      PaddingView(
                        paddingTop: 5,
                        paddingBottom: 5,
                        paddingLeft: 10,
                        paddingRight: 10,
                        child: ButtonView(
                          radius: 10,
                          onPress: () {},
                          child: AsyncImageView(
                            radius: 10,
                            imagePath: ads[i]['imagePath'],
                            width: getWidth(context),
                            height: getWidth(context),
                            objectFit: BoxFit.fill,
                          ),
                        ),
                      )
                    else if (ads[i]['chosenOption'] == '2 x 1')
                      PaddingView(
                        paddingTop: 5,
                        paddingBottom: 5,
                        paddingLeft: 10,
                        paddingRight: 10,
                        child: ButtonView(
                          radius: 10,
                          onPress: () {},
                          child: AsyncImageView(
                            radius: 10,
                            imagePath: ads[i]['imagePath'],
                            width: getWidth(context),
                            height: getWidth(context) / 2,
                            objectFit: BoxFit.fill,
                          ),
                        ),
                      )
                    // Handle two consecutive 1 x 1 ads side by side
                    else if (ads[i]['chosenOption'] == '1 x 1' &&
                        i + 1 < ads.length &&
                        ads[i + 1]['chosenOption'] == '1 x 1')
                      PaddingView(
                        paddingTop: 5,
                        paddingBottom: 5,
                        paddingLeft: 10,
                        paddingRight: 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            AsyncImageView(
                              radius: 10,
                              imagePath: ads[i]['imagePath'],
                              width: getWidth(context) / 2,
                              height: getWidth(context) / 2,
                              objectFit: BoxFit.fill,
                            ),
                            AsyncImageView(
                              radius: 10,
                              imagePath: ads[i + 1]['imagePath'],
                              width: getWidth(context) / 2,
                              height: getWidth(context) / 2,
                              objectFit: BoxFit.fill,
                            ),
                          ],
                        ),
                      )
                    // Handle single 1 x 1 ad if no pair is available
                    else if (ads[i]['chosenOption'] == '1 x 1')
                      PaddingView(
                        paddingTop: 5,
                        paddingBottom: 5,
                        paddingLeft: 10,
                        paddingRight: 10,
                        child: Row(
                          children: [
                            AsyncImageView(
                              radius: 10,
                              imagePath: ads[i]['imagePath'],
                              width: getWidth(context) / 2,
                              height: getWidth(context) / 2,
                              objectFit: BoxFit.fill,
                            ),
                            Spacer(), // This pushes the 1 x 1 ad to the left
                          ],
                        ),
                      ), // Add some spacing between ads
                ],
              );
            },
            emptyWidget: const TextView(
              text: 'No ads available in your area.',
            ),
          ),
        ),
      ),
    ]);
  }
}
