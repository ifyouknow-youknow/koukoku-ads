import 'package:flutter/material.dart';
import 'package:koukoku_ads/COMPONENTS/asyncimage_view.dart';
import 'package:koukoku_ads/COMPONENTS/border_view.dart';
import 'package:koukoku_ads/COMPONENTS/button_view.dart';
import 'package:koukoku_ads/COMPONENTS/future_view.dart';
import 'package:koukoku_ads/COMPONENTS/image_view.dart';
import 'package:koukoku_ads/COMPONENTS/main_view.dart';
import 'package:koukoku_ads/COMPONENTS/padding_view.dart';
import 'package:koukoku_ads/COMPONENTS/roundedcorners_view.dart';
import 'package:koukoku_ads/COMPONENTS/text_view.dart';
import 'package:koukoku_ads/FUNCTIONS/colors.dart';
import 'package:koukoku_ads/FUNCTIONS/date.dart';
import 'package:koukoku_ads/FUNCTIONS/nav.dart';
import 'package:koukoku_ads/MODELS/DATAMASTER/datamaster.dart';
import 'package:koukoku_ads/MODELS/constants.dart';
import 'package:koukoku_ads/MODELS/firebase.dart';
import 'package:koukoku_ads/MODELS/screen.dart';
import 'package:koukoku_ads/VIEWS/login.dart';
import 'package:koukoku_ads/VIEWS/user_business_profile.dart';

class Profile extends StatefulWidget {
  final DataMaster dm;
  const Profile({super.key, required this.dm});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String chosenOption = "favorites";
//
  void onSignOut() async {
    setState(() {
      widget.dm.setToggleAlert(true);
      widget.dm.setAlertTitle('Sign Out');
      widget.dm.setAlertText('Are you sure you want to sign out?');
      widget.dm.setAlertButtons([
        PaddingView(
          paddingTop: 0,
          paddingBottom: 0,
          child: ButtonView(
              child: TextView(
                text: 'sign out',
                size: 18,
                color: Colors.red,
              ),
              onPress: () async {
                final success = await auth_SignOut();
                if (success) {
                  setState(() {
                    widget.dm.setToggleAlert(false);
                  });
                  nav_PushAndRemove(context, Login(dm: widget.dm));
                }
              }),
        )
      ]);
    });
  }

  void onDeleteAccount() async {}

  Future<List<dynamic>> _fetchFavorites() async {
    final docs = await firebase_GetAllDocumentsQueried('${appName}_Favorites', [
      {'field': 'userId', 'operator': '==', 'value': widget.dm.user['id']},
    ]);
    final ads = [];
    for (var ad in docs) {
      final doc =
          await firebase_GetDocument('${appName}_Campaigns', ad['adId']);
      ads.add(doc);
    }
    return ads;
  }

  Future<List<dynamic>> _fetchScans() async {
    final docs = await firebase_GetAllDocumentsOrderedQueriedLimited(
        '${appName}_Scans',
        [
          {'field': 'userId', 'operator': '==', 'value': widget.dm.user['id']}
        ],
        'date',
        'desc',
        200);
    final all = [];
    for (var scan in docs) {
      final adId = scan['adId'];
      final ad = await firebase_GetDocument('${appName}_Campaigns', adId);
      all.add({...scan, 'ad': ad});
    }
    return all;
  }

  Future<List<dynamic>> _fetchFollowing() async {
    final docs = await firebase_GetAllDocumentsQueried('${appName}_Following', [
      {'field': 'userId', 'operator': '==', 'value': widget.dm.user['id']}
    ]);
    final allDocs = [];
    for (var bus in docs) {
      final busId = bus['businessId'];
      final ads = await firebase_GetAllDocumentsQueriedLimited(
          '${appName}_Campaigns',
          [
            {'field': 'userId', 'operator': '==', 'value': busId}
          ],
          4);
      final obj = {'id': busId, 'name': bus['businessName'], 'ads': ads};
      print(obj);
      allDocs.add(obj);
    }

    return allDocs;
  }

  @override
  Widget build(BuildContext context) {
    return MainView(dm: widget.dm, children: [
      PaddingView(
          child: Row(
        children: [
          ButtonView(
            child: const Row(
              children: [
                Icon(
                  Icons.arrow_back,
                  // color: Colors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                TextView(
                  text: 'browse',
                  // color: Colors.white,
                  size: 20,
                  weight: FontWeight.w600,
                  wrap: false,
                ),
              ],
            ),
            onPress: () {
              nav_Pop(context);
            },
          ),
        ],
      )),
      PaddingView(
        paddingTop: 0,
        child: Row(
          children: [
            // FAVORITES
            BorderView(
              bottom: chosenOption == 'favorites' ? true : false,
              bottomColor: hexToColor("#3490F3"),
              bottomWidth: 3,
              child: ButtonView(
                onPress: () {
                  setState(() {
                    chosenOption = 'favorites';
                  });
                },
                child: TextView(
                  text: 'Favorites',
                  size: chosenOption == 'favorites' ? 26 : 20,
                  color: chosenOption == 'favorites'
                      ? Colors.black
                      : Colors.black45,
                  weight: FontWeight.w700,
                  spacing: -1,
                ),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            // SCANS
            BorderView(
              bottom: chosenOption == 'scans' ? true : false,
              bottomColor: hexToColor("#3490F3"),
              bottomWidth: 3,
              child: ButtonView(
                onPress: () {
                  setState(() {
                    chosenOption = 'scans';
                  });
                },
                child: TextView(
                  text: 'Scans',
                  size: chosenOption == 'scans' ? 26 : 20,
                  color:
                      chosenOption == 'scans' ? Colors.black : Colors.black45,
                  weight: FontWeight.w700,
                  spacing: -1,
                ),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            // FOLLOWING
            BorderView(
              bottom: chosenOption == 'following' ? true : false,
              bottomColor: hexToColor("#3490F3"),
              bottomWidth: 3,
              child: ButtonView(
                onPress: () {
                  setState(() {
                    chosenOption = 'following';
                  });
                },
                child: TextView(
                  text: 'Following',
                  size: chosenOption == 'following' ? 26 : 20,
                  color: chosenOption == 'following'
                      ? Colors.black
                      : Colors.black45,
                  weight: FontWeight.w700,
                  spacing: -1,
                ),
              ),
            ),
          ],
        ),
      ),
      if (chosenOption == 'favorites')
        Expanded(
            child: SingleChildScrollView(
          child: FutureView(
              future: _fetchFavorites(),
              childBuilder: (ads) {
                return PaddingView(
                  paddingTop: 0,
                  paddingBottom: 10,
                  child: GridView.count(
                    padding: EdgeInsets.all(0),
                    crossAxisCount: 2, // Number of items in a row
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: [
                      for (var ad in ads)
                        ButtonView(
                          onPress: () {
                            nav_Push(context,
                                UserBusinessProfile(dm: widget.dm, ad: ad), () {
                              setState(() {});
                            });
                          },
                          child: AsyncImageView(
                            imagePath: ad['imagePath'],
                            objectFit: BoxFit.cover,
                            radius: 15,
                          ),
                        )
                    ],
                    shrinkWrap:
                        true, // Ensure GridView doesn't take up infinite height
                    physics:
                        NeverScrollableScrollPhysics(), // Disable scrolling in the grid
                  ),
                );
              },
              emptyWidget: Center(
                child: PaddingView(
                  child: TextView(
                    text: 'No favorite ads.',
                  ),
                ),
              )),
        )),
      if (chosenOption == 'scans')
        Expanded(
            child: SingleChildScrollView(
          child: FutureView(
              future: _fetchScans(),
              childBuilder: (scans) {
                return PaddingView(
                    paddingTop: 0,
                    paddingBottom: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var scan in scans)
                          SizedBox(
                            width: double.infinity,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    AsyncImageView(
                                      imagePath: scan['ad']['imagePath'],
                                      radius: 6,
                                      width: 60,
                                      height: 60,
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          TextView(
                                            text: 'Scanned on ${formatDate(
                                              DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                scan['date'],
                                              ),
                                            )}',
                                            size: 16,
                                            weight: FontWeight.w500,
                                          ),
                                          if (scan['ad']['isCoupon'])
                                            TextView(
                                              text:
                                                  'expires on ${formatShortDate(DateTime.fromMillisecondsSinceEpoch(scan['ad']['expDate']))}',
                                              wrap: true,
                                              color: hexToColor("#3490F3"),
                                            )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                          ),
                      ],
                    ));
              },
              emptyWidget: Center(
                child: PaddingView(
                  child: TextView(
                    text: 'No scanned coupons yet.',
                  ),
                ),
              )),
        )),
      if (chosenOption == 'following')
        Expanded(
            child: SingleChildScrollView(
          child: FutureView(
              future: _fetchFollowing(),
              childBuilder: (buses) {
                return Column(
                  children: [
                    for (var bus in buses)
                      BorderView(
                        bottom: true,
                        bottomColor: Colors.black38,
                        child: Column(
                          children: [
                            PaddingView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextView(
                                    text: bus['name'],
                                    size: 24,
                                    weight: FontWeight.w700,
                                    spacing: -1,
                                    wrap: true,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  RoundedCornersView(
                                    child: GridView.count(
                                      crossAxisCount: 4,
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      crossAxisSpacing: 0,
                                      padding: EdgeInsets.all(0),
                                      children: [
                                        ...bus['ads'].map((ad) {
                                          return ButtonView(
                                            onPress: () {
                                              nav_Push(
                                                  context,
                                                  UserBusinessProfile(
                                                      dm: widget.dm, ad: ad));
                                            },
                                            child: AsyncImageView(
                                              imagePath: ad['imagePath'],
                                              width: getWidth(context) * 0.15,
                                              height: getWidth(context) * 0.15,
                                              objectFit: BoxFit.cover,
                                              radius: 0,
                                            ),
                                          );
                                        })
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      )
                  ],
                );
              },
              emptyWidget: Center(
                child: PaddingView(
                  child: TextView(
                    text: 'No followed businesses yet.',
                  ),
                ),
              )),
        )),

      //
      PaddingView(
        paddingLeft: 20,
        paddingRight: 20,
        paddingBottom: 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                ButtonView(
                    child: Row(
                      children: [
                        TextView(
                          text: 'sign out',
                          color: Colors.red,
                          size: 18,
                          weight: FontWeight.w500,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.logout_outlined,
                          color: Colors.red,
                          size: 22,
                        )
                      ],
                    ),
                    onPress: () {
                      onSignOut();
                    }),
                SizedBox(
                  height: 8,
                ),
                ButtonView(
                    child: TextView(
                      text: 'delete account',
                      color: Colors.black45,
                    ),
                    onPress: () {
                      onDeleteAccount();
                    })
              ],
            ),
            ImageView(
              imagePath: 'assets/ilove.png',
              width: getWidth(context) * 0.4,
              height: getWidth(context) * 0.3,
              objectFit: BoxFit.contain,
            ),
          ],
        ),
      )
    ]);
  }
}
