import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:koukoku_ads/COMPONENTS/asyncimage_view.dart';
import 'package:koukoku_ads/COMPONENTS/button_view.dart';
import 'package:koukoku_ads/COMPONENTS/image_view.dart';
import 'package:koukoku_ads/COMPONENTS/main_view.dart';
import 'package:koukoku_ads/COMPONENTS/map_view.dart';
import 'package:koukoku_ads/COMPONENTS/padding_view.dart';
import 'package:koukoku_ads/COMPONENTS/qrcode_view.dart';
import 'package:koukoku_ads/COMPONENTS/roundedcorners_view.dart';
import 'package:koukoku_ads/COMPONENTS/text_view.dart';
import 'package:koukoku_ads/FUNCTIONS/colors.dart';
import 'package:koukoku_ads/FUNCTIONS/date.dart';
import 'package:koukoku_ads/FUNCTIONS/location.dart';
import 'package:koukoku_ads/FUNCTIONS/misc.dart';
import 'package:koukoku_ads/FUNCTIONS/nav.dart';
import 'package:koukoku_ads/MODELS/DATAMASTER/datamaster.dart';
import 'package:koukoku_ads/MODELS/constants.dart';
import 'package:koukoku_ads/MODELS/firebase.dart';
import 'package:koukoku_ads/MODELS/screen.dart';
import 'package:koukoku_ads/VIEWS/login.dart';

class BusinessProfile extends StatefulWidget {
  final DataMaster dm;
  final Map<String, dynamic> ad;
  const BusinessProfile({super.key, required this.dm, required this.ad});

  @override
  State<BusinessProfile> createState() => _BusinessProfileState();
}

class _BusinessProfileState extends State<BusinessProfile> {
  Map<String, dynamic>? businessInfo;
  List<dynamic> ads = [];
  bool _toggleQR = false;

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
    final docs = await firebase_GetAllDocumentsQueried('KoukokuAds_Campaigns', [
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
                nav_Push(context, BusinessProfile(dm: widget.dm, ad: ads[i]),
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
                nav_Push(context, BusinessProfile(dm: widget.dm, ad: ads[i]),
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
                          BusinessProfile(dm: widget.dm, ad: ads[i - 1]), () {
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
                      nav_Push(
                          context, BusinessProfile(dm: widget.dm, ad: ads[i]),
                          () {
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
                      nav_Push(
                          context, BusinessProfile(dm: widget.dm, ad: ads[i]),
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
    return widgets;
  }

  void init() async {
    if (DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
                    11, 59, 59)
                .millisecondsSinceEpoch >
            widget.ad['date'] &&
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
  }

  @override
  void initState() {
    super.initState();
    init();
    _fetchBusinessInfo();
    _fetchAds();
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
                            final signedIn = await widget.dm.checkUser();
                            if (widget.ad['isCoupon'] && signedIn) {
                              setState(() {
                                _toggleQR = true;
                              });
                            } else {
                              nav_Push(context, Login(dm: widget.dm));
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
                    if (_toggleQR)
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
                                      'coupon expires on ${formatDate(DateTime.fromMillisecondsSinceEpoch(widget.ad['date']))}',
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
              // TITLE
              PaddingView(
                paddingTop: 0,
                paddingBottom: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextView(
                      text: businessInfo?['name'],
                      size: 32,
                      weight: FontWeight.w800,
                      spacing: -1,
                      wrap: true,
                    ),
                  ],
                ),
              ),

              // INFO
              // PHONE
              PaddingView(
                paddingTop: 0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: RoundedCornersView(
                        topLeft: 15,
                        topRight: 15,
                        bottomLeft: 15,
                        bottomRight: 15,
                        backgroundColor: hexToColor("#F8FAFB"),
                        child: SizedBox(
                          width: double.infinity,
                          child: PaddingView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const TextView(
                                  text: 'phone',
                                  size: 14,
                                  color: Colors.black54,
                                ),
                                TextView(
                                  text: businessInfo?['phone'] ?? 'loading...',
                                  weight: FontWeight.w600,
                                  size: 16,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ButtonView(
                        radius: 15,
                        backgroundColor: hexToColor("#FF1F54"),
                        child: const PaddingView(
                          child: Icon(
                            Icons.call,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        onPress: () async {
                          await callPhoneNumber(businessInfo?['phone']);
                        })
                  ],
                ),
              ),
              // ADDRESS
              PaddingView(
                paddingTop: 0,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: RoundedCornersView(
                            topLeft: 15,
                            topRight: 15,
                            bottomLeft: 15,
                            bottomRight: 15,
                            backgroundColor: hexToColor("#F8FAFB"),
                            child: SizedBox(
                              width: double.infinity,
                              child: PaddingView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const TextView(
                                      text: 'address',
                                      size: 14,
                                      color: Colors.black54,
                                    ),
                                    TextView(
                                      text: businessInfo?['address'] ??
                                          'loading..',
                                      weight: FontWeight.w600,
                                      size: 16,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ButtonView(
                            radius: 15,
                            backgroundColor: hexToColor("#FF1F54"),
                            child: const PaddingView(
                              child: Icon(
                                Icons.directions_car,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                            onPress: () {
                              getDirections(LatLng(
                                  businessInfo?['location']['latitude'],
                                  businessInfo?['location']['longitude']));
                            })
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MapView(height: 140, locations: [
                      LatLng(businessInfo?['location']['latitude'],
                          businessInfo?['location']['longitude'])
                    ]),
                    const Divider(
                      color: Colors.black12,
                    )
                  ],
                ),
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

              const SizedBox(
                height: 30,
              )
            ],
          ),
        ))
    ]);
  }
}
