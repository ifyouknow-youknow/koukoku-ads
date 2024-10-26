import 'package:ads_mahem/FUNCTIONS/array.dart';
import 'package:flutter/material.dart';
import 'package:ads_mahem/COMPONENTS/asyncimage_view.dart';
import 'package:ads_mahem/COMPONENTS/button_view.dart';
import 'package:ads_mahem/COMPONENTS/image_view.dart';
import 'package:ads_mahem/COMPONENTS/main_view.dart';
import 'package:ads_mahem/COMPONENTS/padding_view.dart';
import 'package:ads_mahem/COMPONENTS/pill_view.dart';
import 'package:ads_mahem/COMPONENTS/text_view.dart';
import 'package:ads_mahem/FUNCTIONS/colors.dart';
import 'package:ads_mahem/FUNCTIONS/misc.dart';
import 'package:ads_mahem/FUNCTIONS/nav.dart';
import 'package:ads_mahem/MODELS/DATAMASTER/datamaster.dart';
import 'package:ads_mahem/MODELS/constants.dart';
import 'package:ads_mahem/MODELS/firebase.dart';
import 'package:ads_mahem/MODELS/screen.dart';
import 'package:ads_mahem/VIEWS/business_profile.dart';
import 'package:ads_mahem/VIEWS/login.dart';
import 'package:visibility_detector/visibility_detector.dart';

class Browse extends StatefulWidget {
  final DataMaster dm;
  const Browse({super.key, required this.dm});

  @override
  State<Browse> createState() => _BrowseState();
}

class _BrowseState extends State<Browse> {
  dynamic lastDoc;
  List<dynamic> ads = [];
  bool isLoading = false;
  int limit = 60;
  bool _noMore = false;
  List<dynamic> _seenAdIds = [];
  String _geohash = "";
  //
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
        geohash: '9mudwsg28x',
        distance: 60,
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

  List<Widget> buildAdWidgets(BuildContext context, List<dynamic> theseAds) {
    List<Widget> widgets = [];
    List<dynamic> ads =
        removeDupesByProperty(theseAds.cast<Map<String, dynamic>>(), 'id');

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
                    '${appName}_Clicks', randomString(25), {
                  'userId': widget.dm.user['id'],
                  'adId': ads[i]['id'],
                  'geohash': _geohash
                });
                if (success) {
                  nav_Push(
                    context,
                    BusinessProfile(dm: widget.dm, ad: ads[i]),
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
    _fetchLocalAds();
  }

  @override
  Widget build(BuildContext context) {
    return MainView(dm: widget.dm, children: [
      PaddingView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextView(
              text: 'Explore',
              size: 18,
              weight: FontWeight.w600,
              wrap: false,
            ),
            ButtonView(
                child: PillView(
                  backgroundColor: hexToColor("#F5F5FC"),
                  child: Row(
                    children: [
                      TextView(
                        text: 'log in',
                        size: 16,
                        weight: FontWeight.w500,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Icon(
                        Icons.arrow_forward,
                        size: 18,
                      )
                    ],
                  ),
                ),
                onPress: () {
                  setState(() {
                    widget.dm.setToggleSplash(true);
                    widget.dm.setToggleSplash2(false);
                  });
                  nav_PushAndRemove(context, Login(dm: widget.dm));
                })
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
                  radius: 20,
                ),
              if (!_noMore)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PaddingView(
                      child: ButtonView(
                          child: PillView(
                            backgroundColor: hexToColor("#F5F5FC"),
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
    ]);
  }
}
