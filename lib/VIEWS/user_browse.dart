import 'package:flutter/material.dart';
import 'package:koukoku_ads/COMPONENTS/asyncimage_view.dart';
import 'package:koukoku_ads/COMPONENTS/button_view.dart';
import 'package:koukoku_ads/COMPONENTS/future_view.dart';
import 'package:koukoku_ads/COMPONENTS/image_view.dart';
import 'package:koukoku_ads/COMPONENTS/main_view.dart';
import 'package:koukoku_ads/COMPONENTS/padding_view.dart';
import 'package:koukoku_ads/COMPONENTS/roundedcorners_view.dart';
import 'package:koukoku_ads/COMPONENTS/text_view.dart';
import 'package:koukoku_ads/FUNCTIONS/colors.dart';
import 'package:koukoku_ads/FUNCTIONS/misc.dart';
import 'package:koukoku_ads/FUNCTIONS/nav.dart';
import 'package:koukoku_ads/MODELS/DATAMASTER/datamaster.dart';
import 'package:koukoku_ads/MODELS/constants.dart';
import 'package:koukoku_ads/MODELS/firebase.dart';
import 'package:koukoku_ads/VIEWS/login.dart';
import 'package:koukoku_ads/MODELS/screen.dart';
import 'package:koukoku_ads/VIEWS/profile.dart';
import 'package:koukoku_ads/VIEWS/user_business_profile.dart';
import 'package:visibility_detector/visibility_detector.dart';

class UserBrowse extends StatefulWidget {
  final DataMaster dm;
  const UserBrowse({super.key, required this.dm});

  @override
  State<UserBrowse> createState() => _UserBrowseState();
}

class _UserBrowseState extends State<UserBrowse> {
  // Pagination handling
  dynamic lastDoc;
  List<dynamic> ads = [];
  bool isLoading = false;
  int limit = 4;
  bool _noMore = false;
  List<dynamic> _seenAdIds = [];

  Future<void> _fetchLocalAds() async {
    if (isLoading) return; // Prevent multiple calls
    setState(() {
      isLoading = true;
    });

    try {
      // UPDATE THINGS
      final needsUpdated = await firebase_GetAllDocumentsQueriedLimited(
          '${appName}_Campaigns',
          [
            {'field': 'active', 'operator': '==', 'value': true},
            {
              'field': 'expDate',
              'operator': '<',
              'value': DateTime(DateTime.now().year, DateTime.now().month,
                      DateTime.now().day, 11, 59, 59)
                  .millisecondsSinceEpoch
            },
            {'field': 'expDate', 'operator': '!=', 'value': 0},
            {'field': 'isCoupon', 'operator': '==', 'value': true}
          ],
          50);
      for (var doc in needsUpdated) {
        await firebase_UpdateDocument(
            '${appName}_Campaigns', doc['id'], {'active': false});
        print('Ad ${doc['id']} has just been updated.');
      }

      // Fetch documents from Firebase with pagination
      final docs = await firebase_GetAllDocumentsQueriedLimitedDistanced(
        '${appName}_Campaigns',
        [
          {'field': 'active', 'operator': '==', 'value': true},
        ],
        limit,
        geohash: '9mu9zms751',
        distance: 10,
        lastDoc: lastDoc,
      );

      if (docs.isNotEmpty) {
        setState(() {
          lastDoc = docs.last?['doc']; // Update lastDoc for pagination
          ads.addAll(docs); // Append new ads to the existing list
        });
      } else if (docs.isEmpty || docs.length < limit) {
        setState(() {
          _noMore = true;
        });
      }
    } catch (error) {
      print('Error fetching ads: $error');
    } finally {
      setState(() {
        isLoading = false; // Always reset loading state
      });
    }
  }

  List<Widget> buildAdWidgets(BuildContext context, List<dynamic> ads) {
    List<Widget> widgets = [];

    for (int i = 0; i < ads.length; i++) {
      Widget adWidget; // Declare adWidget here

      // Build the ad widget based on its chosen option
      if (ads[i]['chosenOption'] == '2 x 2') {
        adWidget = AsyncImageView(
          radius: 10,
          imagePath: ads[i]['imagePath'],
          width: getWidth(context),
          height: getWidth(context),
          objectFit: BoxFit.fill,
        );
      } else if (ads[i]['chosenOption'] == '2 x 1') {
        adWidget = AsyncImageView(
          radius: 10,
          imagePath: ads[i]['imagePath'],
          width: getWidth(context),
          height: getWidth(context) / 2,
          objectFit: BoxFit.fill,
        );
      } else if (ads[i]['chosenOption'] == '1 x 1' &&
          i + 1 < ads.length &&
          ads[i + 1]['chosenOption'] == '1 x 1') {
        // Add two consecutive '1 x 1' ads side by side
        adWidget = Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: AsyncImageView(
                radius: 10,
                imagePath: ads[i]['imagePath'],
                width: getWidth(context) / 2,
                height: getWidth(context) / 2,
                objectFit: BoxFit.fill,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: AsyncImageView(
                radius: 10,
                imagePath: ads[i + 1]['imagePath'],
                width: getWidth(context) / 2,
                height: getWidth(context) / 2,
                objectFit: BoxFit.fill,
              ),
            ),
          ],
        );
        i++; // Skip the next ad as it has been processed
      } else if (ads[i]['chosenOption'] == '1 x 1') {
        // Handle a single '1 x 1' ad when no pair is available
        adWidget = Row(
          children: [
            Expanded(
              child: AsyncImageView(
                radius: 10,
                imagePath: ads[i]['imagePath'],
                width: getWidth(context) / 2,
                height: getWidth(context) / 2,
                objectFit: BoxFit.fill,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ImageView(
                radius: 10,
                imagePath: 'assets/ad1.png',
                width: getWidth(context) / 2,
                height: getWidth(context) / 2,
                objectFit: BoxFit.fill,
              ),
            ),
          ],
        );
      } else {
        // Fallback to an empty Container if no condition matches
        adWidget = Container(); // Ensure adWidget is initialized
      }

      // Wrap the ad widget with VisibilityDetector
      widgets.add(
        VisibilityDetector(
          key: Key('ad_${ads[i]['id']}'), // Use a unique key for each ad
          onVisibilityChanged: (info) {
            if (info.visibleFraction == 1) {
              // Check if fully visible
              if (!_seenAdIds.contains(ads[i]['id'])) {
                onAdView(ads[i]['id']);
              }
            }
          },
          child: PaddingView(
            paddingTop: 5,
            paddingBottom: 5,
            paddingLeft: 10,
            paddingRight: 10,
            child: ButtonView(
              radius: 10,
              onPress: () async {
                final success = await firebase_CreateDocument(
                    '${appName}_Clicks',
                    randomString(25),
                    {'userId': widget.dm.user['id'], 'adId': ads[i]['id']});
                if (success) {
                  nav_Push(
                    context,
                    UserBusinessProfile(dm: widget.dm, ad: ads[i]),
                    () => setState(() {}),
                  );
                }
              },
              child: adWidget,
            ),
          ),
        ),
      );
    }
    return widgets;
  }

  void onAdView(String adId) async {
    setState(() {
      _seenAdIds.add(adId);
    });
    await firebase_CreateDocument('${appName}_Views', randomString(25),
        {'userId': widget.dm.user['id'], 'adId': adId});
    print('the ad ${adId} was seen');
  }

  @override
  void initState() {
    super.initState();
    _fetchLocalAds(); // Fetch ads on initialization
  }

  @override
  Widget build(BuildContext context) {
    return MainView(
      dm: widget.dm,
      children: [
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
                  SizedBox(width: 6),
                  TextView(
                    text: 'Explore',
                    size: 18,
                    weight: FontWeight.w500,
                    wrap: false,
                  ),
                ],
              ),
              ButtonView(
                child: Icon(
                  Icons.face,
                  color: hexToColor("#3490F3"),
                  size: 34,
                ),
                onPress: () {
                  nav_Push(context, Profile(dm: widget.dm));
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: buildAdWidgets(context, ads),
                ),
                if (_noMore)
                  ImageView(
                    imagePath: 'assets/nomore.png',
                    width: getWidth(context) * 0.8,
                    height: getWidth(context) * 0.6,
                    objectFit: BoxFit.contain,
                  ),
                if (!_noMore)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PaddingView(
                        child: ButtonView(
                            child: Row(
                              children: [
                                TextView(
                                  text: 'see more',
                                  size: 20,
                                  weight: FontWeight.w500,
                                  spacing: -1,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.waving_hand_outlined,
                                  size: 24,
                                  color: hexToColor("#3490F3"),
                                )
                              ],
                            ),
                            onPress: () {
                              _fetchLocalAds();
                            }),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
