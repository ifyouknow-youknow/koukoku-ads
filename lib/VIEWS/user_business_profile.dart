import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ads_mahem/COMPONENTS/asyncimage_view.dart';
import 'package:ads_mahem/COMPONENTS/button_view.dart';
import 'package:ads_mahem/COMPONENTS/iconbutton_view.dart';
import 'package:ads_mahem/COMPONENTS/image_view.dart';
import 'package:ads_mahem/COMPONENTS/main_view.dart';
import 'package:ads_mahem/COMPONENTS/map_view.dart';
import 'package:ads_mahem/COMPONENTS/padding_view.dart';
import 'package:ads_mahem/COMPONENTS/pill_view.dart';
import 'package:ads_mahem/COMPONENTS/qrcode_view.dart';
import 'package:ads_mahem/COMPONENTS/roundedcorners_view.dart';
import 'package:ads_mahem/COMPONENTS/text_view.dart';
import 'package:ads_mahem/FUNCTIONS/colors.dart';
import 'package:ads_mahem/FUNCTIONS/date.dart';
import 'package:ads_mahem/FUNCTIONS/location.dart';
import 'package:ads_mahem/FUNCTIONS/misc.dart';
import 'package:ads_mahem/FUNCTIONS/nav.dart';
import 'package:ads_mahem/MODELS/DATAMASTER/datamaster.dart';
import 'package:ads_mahem/MODELS/constants.dart';
import 'package:ads_mahem/MODELS/firebase.dart';
import 'package:ads_mahem/MODELS/geohash.dart';
import 'package:ads_mahem/MODELS/screen.dart';
import 'package:ads_mahem/VIEWS/login.dart';
import 'package:ads_mahem/VIEWS/user_browse.dart';

class UserBusinessProfile extends StatefulWidget {
  final DataMaster dm;
  final Map<String, dynamic> ad;
  const UserBusinessProfile({super.key, required this.dm, required this.ad});

  @override
  State<UserBusinessProfile> createState() => _UserBusinessProfileState();
}

class _UserBusinessProfileState extends State<UserBusinessProfile> {
  Map<String, dynamic>? businessInfo;
  List<dynamic> ads = [];
  bool _toggleQR = false;
  bool _isSaved = false;
  String _savedId = "";
  bool _isFollowing = false;
  String _followId = "";
  LatLng _location = LatLng(0, 0);

  void _fetchBusinessInfo() async {
    final doc = await firebase_GetDocument(
        '${appName}_Businesses', widget.ad['userId']);
    setState(() {
      businessInfo = doc;
    });
  }

  void _fetchAds() async {
    var oneByOne = [];
    var oneByTwo = [];
    var twoByTwo = [];

    // Fetch documents from Firebase
    final docs = await firebase_GetAllDocumentsQueried('${appName}_Campaigns', [
      {'field': 'userId', 'operator': '==', 'value': widget.ad['userId']},
      {'field': 'active', 'operator': '==', 'value': true}
    ]);

    // Categorize ads by 'chosenOption'
    for (var doc in docs.where((ting) => ting['id'] != widget.ad['id'])) {
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

    // Update the state excluding the current ad
    setState(() {
      ads = allOfThem.where((ting) => ting['id'] != widget.ad['id']).toList();
    });
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
                nav_Push(
                    context, UserBusinessProfile(dm: widget.dm, ad: ads[i]),
                    () {
                  setState(() {});
                });
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
                nav_Push(
                    context, UserBusinessProfile(dm: widget.dm, ad: ads[i]),
                    () {
                  setState(() {});
                });
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
                      nav_Push(context,
                          UserBusinessProfile(dm: widget.dm, ad: ads[i - 1]),
                          () {
                        setState(() {});
                      });
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
                      nav_Push(context,
                          UserBusinessProfile(dm: widget.dm, ad: ads[i]), () {
                        setState(() {});
                      });
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
                      nav_Push(context,
                          UserBusinessProfile(dm: widget.dm, ad: ads[i]), () {
                        setState(() {});
                      });
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
                  child: ImageView(
                    radius: 10,
                    imagePath: 'assets/ad1.png',
                    width: getWidth(context) / 2,
                    height: getWidth(context) / 2,
                    objectFit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }
    if (ads.length == 0) {
      widgets.add(ImageView(
        imagePath: 'assets/nomore.png',
        width: 200,
        height: 100,
      ));
    }
    return widgets;
  }

  void checkIfSaved() async {
    final docs = await firebase_GetAllDocumentsQueried('${appName}_Favorites', [
      {'field': 'userId', 'operator': '==', 'value': widget.dm.user['id']},
      {'field': 'adId', 'operator': '==', 'value': widget.ad['id']}
    ]);
    if (docs.isNotEmpty) {
      setState(() {
        _savedId = docs[0]['id'];
        _isSaved = true;
      });
    }
  }

  void checkIfFollowing() async {
    final docs = await firebase_GetAllDocumentsQueried('${appName}_Following', [
      {'field': 'userId', 'operator': '==', 'value': widget.dm.user['id']},
      {'field': 'businessId', 'operator': '==', 'value': businessInfo?['id']}
    ]);
    if (docs.isNotEmpty) {
      setState(() {
        _followId = docs[0]['id'];
        _isFollowing = true;
      });
    }
  }

  void onSaveUnsave() async {
    if (_isSaved) {
      print(_savedId);
      final success =
          await firebase_DeleteDocument('${appName}_Favorites', _savedId);
      if (success) {
        setState(() {
          _isSaved = false;
        });
      }
    } else {
      final savedId = randomString(25);
      final success =
          await firebase_CreateDocument('${appName}_Favorites', savedId, {
        'userId': widget.dm.user['id'],
        'adId': widget.ad['id'],
      });
      if (success) {
        setState(() {
          _savedId = savedId;
          _isSaved = true;
        });
      }
    }
  }

  void onFollowUnfollow() async {
    setState(() {
      widget.dm.setToggleLoading(true);
    });
    if (_isFollowing) {
      // UNFOLLOW NOW
      final success =
          await firebase_DeleteDocument('${appName}_Following', _followId);
      if (success) {
        setState(() {
          widget.dm.setToggleLoading(false);
          _isFollowing = false;
        });
      } else {
        setState(() {
          widget.dm.setToggleLoading(false);
          widget.dm.alertSomethingWrong();
        });
      }
    } else {
      final followId = randomString(25);
      final success =
          await firebase_CreateDocument('${appName}_Following', followId, {
        'userId': widget.dm.user['id'],
        'businessId': businessInfo?['id'],
        'businessName': businessInfo?['name'],
      });
      if (success) {
        setState(() {
          _followId = followId;
          _isFollowing = true;
          widget.dm.setToggleLoading(false);
        });
      } else {
        setState(() {
          widget.dm.setToggleLoading(false);
          widget.dm.alertSomethingWrong();
        });
      }
    }
  }

  Future<bool> onCheckScan() async {
    final docs = await firebase_GetAllDocumentsQueried('${appName}_Scans', [
      {'field': 'userId', 'operator': '==', 'value': widget.dm.user['id']},
      {'field': 'adId', 'operator': '==', 'value': widget.ad['id']},
    ]);
    print(docs);
    if (!widget.ad['isRepeating'] && docs.length >= 1) {
      return false;
    } else {
      return true;
    }
  }

  void init() async {
    if (widget.ad['seenViews'] >= widget.ad['views']) {
      await firebase_UpdateDocument(
          '${appName}_Campaigns', widget.ad['id'], {'active': false});
      print('Ad ${widget.ad['id']} is now inactive.');
    }
    if (DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
                    11, 59, 59)
                .millisecondsSinceEpoch >
            widget.ad['expDate'] &&
        widget.ad['expDate'] != 0 &&
        widget.ad['active'] &&
        widget.ad['isCoupon']) {
      await firebase_UpdateDocument(
          '${appName}_Campaigns', widget.ad['id'], {'active': false});
      nav_Pop(context);
      setState(() {
        widget.dm.setToggleAlert(true);
        widget.dm.setAlertTitle('Coupon Expired');
        widget.dm.setAlertText('This coupon has expired.');
      });
    }
    final encoded = Geohash.decode(widget.ad['geohash']);
    setState(() {
      _location = LatLng(encoded['latitude']!, encoded['longitude']!);
    });
  }

  @override
  void initState() {
    super.initState();
    init();
    _fetchBusinessInfo();
    _fetchAds();
    checkIfSaved();
    checkIfFollowing();
  }

  @override
  Widget build(BuildContext context) {
    return MainView(dm: widget.dm, children: [
      // TOP
      PaddingView(
        paddingTop: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ButtonView(
                child: PillView(
                  backgroundColor: hexToColor("#F5F5FC"),
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_back,
                        size: 20,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      TextView(
                        text: 'back',
                        size: 18,
                        weight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
                onPress: () {
                  nav_Pop(context);
                }),
            Row(
              children: [
                IconButtonView(
                  icon: Icons.home,
                  iconColor: Colors.white,
                  backgroundColor: Colors.black,
                  onPress: () {
                    nav_PushAndRemove(context, UserBrowse(dm: widget.dm));
                  },
                ),
                SizedBox(
                  width: 15,
                ),
                IconButtonView(
                  backgroundColor: Colors.black,
                  icon: _isSaved ? Icons.favorite : Icons.favorite_outline,
                  iconColor: _isSaved ? hexToColor("#FF3535") : Colors.white,
                  onPress: () {
                    onSaveUnsave();
                  },
                )
              ],
            )
          ],
        ),
      ),
      //  MAIN
      if (businessInfo != null)
        Expanded(
            child: SingleChildScrollView(
          child: Column(
            children: [
              PaddingView(
                child: Column(
                  children: [
                    if (!_toggleQR)
                      Center(
                        child: ButtonView(
                          onPress: () async {
                            if (widget.ad['isCoupon']) {
                              final isGood = await onCheckScan();
                              if (isGood) {
                                setState(() {
                                  _toggleQR = true;
                                });
                              } else {
                                setState(() {
                                  widget.dm.setToggleAlert(true);
                                  widget.dm.setAlertTitle('Already scanned');
                                  widget.dm.setAlertText(
                                      'This coupon has already been redeemed by the business. Explore other offers and ads they have shared!');
                                });
                              }
                            }
                          },
                          child: AsyncImageView(
                            imagePath: widget.ad['imagePath'],
                            height: widget.ad['chosenOption'] != '2 x 1'
                                ? getWidth(context) * 0.9
                                : getWidth(context) * 0.45,
                            objectFit: BoxFit.fill,
                            width: getWidth(context) * 0.9,
                            radius: 10,
                          ),
                        ),
                      ),
                    if (_toggleQR && widget.ad['isCoupon'])
                      Center(
                        child: ButtonView(
                            onPress: () {
                              setState(() {
                                _toggleQR = false;
                              });
                            },
                            child: SizedBox(
                              height: getWidth(context) * 0.9,
                              width: getWidth(context) * 0.9,
                              child: QrcodeView(
                                data:
                                    '${widget.dm.user['id']}~${widget.ad['id']}',
                                size: getWidth(context) * 0.9,
                              ),
                            )),
                      ),
                    //
                    const SizedBox(
                      height: 10,
                    ),
                    if (widget.ad['isCoupon'])
                      Center(
                        child: RoundedCornersView(
                          topLeft: 15,
                          topRight: 15,
                          bottomLeft: 15,
                          bottomRight: 15,
                          backgroundColor: hexToColor("#F8FAFB"),
                          child: PaddingView(
                            child: Column(
                              children: [
                                TextView(
                                  text:
                                      'coupon expires on ${formatDate(DateTime.fromMillisecondsSinceEpoch(widget.ad['expDate']))}',
                                  size: 14,
                                  weight: FontWeight.w500,
                                ),
                                const TextView(
                                  text: 'tap to show QR code',
                                  size: 16,
                                  weight: FontWeight.w700,
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
              const Divider(
                color: Colors.black12,
              ),
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    // TITLE
                    PaddingView(
                      paddingTop: 0,
                      paddingBottom: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: TextView(
                              text: businessInfo?['name'],
                              size: 32,
                              weight: FontWeight.w800,
                              spacing: -1,
                              wrap: true,
                            ),
                          ),
                          if (_isFollowing)
                            ButtonView(
                                key: ValueKey(_isFollowing),
                                paddingTop: 8,
                                paddingBottom: 8,
                                paddingLeft: 18,
                                paddingRight: 18,
                                radius: 100,
                                backgroundColor: hexToColor('#F2F3F5'),
                                child: TextView(
                                  text: 'following',
                                  color: Colors.black,
                                  weight: FontWeight.w500,
                                  size: 16,
                                ),
                                onPress: () {
                                  onFollowUnfollow();
                                }),
                          if (!_isFollowing)
                            ButtonView(
                                key: ValueKey(_isFollowing),
                                paddingTop: 8,
                                paddingBottom: 8,
                                paddingLeft: 18,
                                paddingRight: 18,
                                radius: 100,
                                backgroundColor: hexToColor("#3490F3"),
                                child: TextView(
                                  text: 'follow',
                                  color: Colors.white,
                                  weight: FontWeight.w500,
                                  size: 16,
                                ),
                                onPress: () {
                                  onFollowUnfollow();
                                }),
                        ],
                      ),
                    ),

                    // INFO
                    // PHONE
                    PaddingView(
                      child: Row(
                        children: [
                          // PHONE
                          ButtonView(
                              radius: 100,
                              backgroundColor: hexToColor('#E9F1FA'),
                              child: PaddingView(
                                paddingLeft: 20,
                                paddingRight: 20,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextView(
                                      text: 'Call',
                                      size: 20,
                                      weight: FontWeight.w500,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(Icons.call)
                                  ],
                                ),
                              ),
                              onPress: () async {
                                await callPhoneNumber(businessInfo?['phone']);
                              }),
                          SizedBox(
                            width: 10,
                          ),
                          // ADDRESS
                          Expanded(
                            child: ButtonView(
                                radius: 100,
                                backgroundColor: hexToColor('#4D76FF'),
                                child: PaddingView(
                                  paddingLeft: 20,
                                  paddingRight: 20,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextView(
                                        text: 'Directions',
                                        size: 20,
                                        weight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        Icons.directions_car,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                ),
                                onPress: () async {
                                  await getDirections(_location);
                                }),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MapView(height: 140, locations: [_location]),
                    // const Divider(
                    //   color: Colors.black12,
                    // ),
                    SizedBox(
                      height: 10,
                    ),
                    // ADS
                    const PaddingView(
                      paddingTop: 0,
                      paddingBottom: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextView(
                            text: 'other ads',
                            weight: FontWeight.w600,
                            size: 18,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                    ...buildAdWidgets(context, ads),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              )
            ],
          ),
        ))
    ]);
  }
}
