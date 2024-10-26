import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ads_mahem/COMPONENTS/border_view.dart';
import 'package:ads_mahem/COMPONENTS/button_view.dart';
import 'package:ads_mahem/COMPONENTS/main_view.dart';
import 'package:ads_mahem/COMPONENTS/map_view.dart';
import 'package:ads_mahem/COMPONENTS/padding_view.dart';
import 'package:ads_mahem/COMPONENTS/pill_view.dart';
import 'package:ads_mahem/COMPONENTS/slider_view.dart';
import 'package:ads_mahem/COMPONENTS/text_view.dart';
import 'package:ads_mahem/FUNCTIONS/colors.dart';
import 'package:ads_mahem/FUNCTIONS/nav.dart';
import 'package:ads_mahem/MODELS/DATAMASTER/datamaster.dart';
import 'package:ads_mahem/MODELS/constants.dart';
import 'package:ads_mahem/MODELS/firebase.dart';
import 'package:ads_mahem/MODELS/geohash.dart';

class Filters extends StatefulWidget {
  final DataMaster dm;
  const Filters({super.key, required this.dm});

  @override
  State<Filters> createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  int _distance = 60;
  String _category = "";
  List<String> _categories = [];

  void onTapMarker(location) async {
    setState(() {
      widget.dm.setToggleAlert(true);
      widget.dm.setAlertTitle('New Location');
      widget.dm.setAlertText(
          'Are you sure you want to pick this location \n(${location.latitude}, ${location.longitude})?');
      widget.dm.setAlertButtons([
        PaddingView(
          paddingTop: 0,
          paddingBottom: 0,
          child: ButtonView(
            backgroundColor: hexToColor('#3490F3'),
            paddingTop: 8,
            paddingBottom: 8,
            paddingLeft: 18,
            paddingRight: 18,
            radius: 100,
            child: TextView(
              text: 'Confirm',
              color: Colors.white,
              size: 16,
              weight: FontWeight.w500,
            ),
            onPress: () async {
              setState(() {
                widget.dm.setToggleAlert(false);
                widget.dm.setToggleLoading(true);
              });

              final geohash =
                  Geohash.encode(location.latitude, location.longitude);
              final succ = await firebase_UpdateDocument('${appName}_Users',
                  widget.dm.user['id'], {'geohash': geohash});
              if (succ) {
                setState(() {
                  widget.dm.setToggleLoading(false);
                  widget.dm.setToggleBubble(true);
                  widget.dm.setBubbleText('saved.');
                  widget.dm.setUser({...widget.dm.user, 'geohash': geohash});
                  Future.delayed(Duration(seconds: 1), () {
                    setState(() {
                      widget.dm.setToggleBubble(false);
                    });
                  });
                });
              }
            },
          ),
        )
      ]);
    });
  }

  void onSaveChanges() async {
    setState(() {
      widget.dm.setToggleAlert(true);
      widget.dm.setAlertTitle('Save Changes');
      widget.dm.setAlertText('Are you sure you want to save these filters?');
      widget.dm.setAlertButtons([
        ButtonView(
          child: PillView(
              backgroundColor: hexToColor('#3490F3'),
              child: TextView(
                text: 'Proceed',
                color: Colors.white,
                size: 16,
                weight: FontWeight.w500,
              )),
          onPress: () async {
            setState(
              () {
                widget.dm.setToggleAlert(false);
                widget.dm.setToggleLoading(true);
              },
            );
            final succ = await firebase_UpdateDocument(
                '${appName}_Users',
                widget.dm.user['id'],
                {'distance': _distance, 'category': _category});
            if (succ) {
              setState(() {
                widget.dm.setToggleLoading(false);
                widget.dm.setToggleBubble(true);
                widget.dm.setBubbleText('saved');
                widget.dm.setUser({
                  ...widget.dm.user,
                  'distance': _distance,
                  'category': _category
                });
                Future.delayed(Duration(seconds: 1), () {
                  print(widget.dm.user);
                  setState(() {
                    widget.dm.setToggleBubble(false);
                  });
                });
              });
            }
          },
        )
      ]);
    });
  }

  void init() async {
    if (widget.dm.user['distance'] != null) {
      setState(() {
        _distance = widget.dm.user['distance'];
      });
    }
    if (widget.dm.user['category'] != null ||
        widget.dm.user['category'] != "") {
      setState(() {
        _category = widget.dm.user['category'];
      });
    }

    final docs = await firebase_GetAllDocumentsOrdered(
        '${appName}_Categories', 'category', 'asc');
    setState(() {
      _categories = docs.map((doc) => doc['category'] as String).toList();
    });
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainView(dm: widget.dm, children: [
      PaddingView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ButtonView(
                child: PillView(
                  backgroundColor: hexToColor("#F5F5FC"),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_back,
                        size: 18,
                      ),
                      TextView(
                        text: 'back',
                        size: 16,
                      )
                    ],
                  ),
                ),
                onPress: () {
                  widget.dm.setToggleAlert(false);
                  widget.dm.setToggleBubble(false);
                  widget.dm.setToggleLoading(false);
                  nav_Pop(context);
                }),
            ButtonView(
                child: PillView(
                  backgroundColor: hexToColor('#FF5858'),
                  child: TextView(
                    text: 'save',
                    color: Colors.white,
                    size: 18,
                    weight: FontWeight.w600,
                  ),
                ),
                onPress: () {
                  onSaveChanges();
                })
          ],
        ),
      ),
      //  MAIN
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // DISTANCE
              PaddingView(
                paddingBottom: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextView(
                      text: 'Distance in km',
                      size: 22,
                      weight: FontWeight.w400,
                      spacing: -1,
                    ),
                    TextView(
                      text: '${_distance}km',
                      size: 26,
                      weight: FontWeight.w600,
                      color: hexToColor('#4D76FF'),
                    )
                  ],
                ),
              ),
              PaddingView(
                paddingTop: 0,
                paddingBottom: 0,
                child: Row(
                  children: [
                    TextView(
                      text: '1km',
                      weight: FontWeight.w400,
                    ),
                    Expanded(
                        child: SliderView(
                      start: _distance.toDouble(),
                      min: 1,
                      max: 60,
                      increment: 1,
                      onChange: (value) {
                        setState(() {
                          _distance = value.toInt();
                        });
                      },
                    )),
                    TextView(
                      text: '60km',
                      weight: FontWeight.w400,
                    ),
                  ],
                ),
              ),
              // LOCATION
              PaddingView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextView(
                      text: 'Location',
                      size: 22,
                      weight: FontWeight.w400,
                      spacing: -1,
                    ),
                    TextView(
                      text:
                          'search for a location and tap on the marker to confirm.',
                    ),
                  ],
                ),
              ),
              MapView(
                isScrolling: true,
                locations: [
                  widget.dm.myLocation != null
                      ? widget.dm.myLocation!
                      : testCoordinates2
                ],
                isSearchable: true,
                onMarkerTap: (loc) {
                  onTapMarker(loc);
                },
              ),
              // CATEGORIES
              PaddingView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextView(
                      text: 'Categories',
                      size: 22,
                      weight: FontWeight.w400,
                      spacing: -1,
                    ),
                  ],
                ),
              ),
              for (var cat in _categories)
                PaddingView(
                  paddingTop: 0,
                  paddingBottom: 6,
                  child: ButtonView(
                      child: PillView(
                        backgroundColor: _category == cat
                            ? hexToColor('#4D76FF')
                            : hexToColor('#F6F8FA'),
                        child: SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextView(
                                text: cat,
                                color: _category == cat
                                    ? Colors.white
                                    : Colors.black,
                                size: 18,
                              ),
                              if (_category == cat)
                                Icon(
                                  Icons.check,
                                  color: _category == cat
                                      ? Colors.white
                                      : Colors.black,
                                  size: 26,
                                )
                            ],
                          ),
                        ),
                      ),
                      onPress: () {
                        if (_category == cat) {
                          setState(() {
                            _category = "";
                          });
                        } else {
                          setState(() {
                            _category = cat;
                          });
                        }
                      }),
                ),

              SizedBox(
                height: 60,
              ),
              PaddingView(
                  paddingBottom: 40,
                  child: TextView(
                    text: 'A nothing bagel.',
                    color: Colors.black,
                  )),
            ],
          ),
        ),
      ),
    ]);
  }
}
