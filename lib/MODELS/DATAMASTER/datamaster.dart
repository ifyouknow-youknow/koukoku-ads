import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:koukoku_ads/MODELS/constants.dart';
import 'package:koukoku_ads/MODELS/firebase.dart';

part 'toggles.dart';
part 'strings.dart';
part 'lists.dart';

class DataMaster with _DataMasterToggles, _DataMasterStrings, _DataMasterLists {
  Map<String, dynamic> _user = {};
  Map<String, dynamic> get user => _user;
  void setUser(Map<String, dynamic> value) => _user = value;
  //
  LatLng _myLocation = const LatLng(0, 0);
  LatLng get myLocation => _myLocation;
  void setMyLocation(LatLng value) => _myLocation = value;
  //

  DataMaster();

// FUNCTIONS
  Future<bool> checkUser() async {
    final user = await auth_CheckUser();
    if (user != null) {
      var userDoc = await firebase_GetDocument('${appName}_Users', user.uid);

      if (userDoc['token'] == "" || userDoc['token'] == null) {
        final token = await messaging_SetUp();
        final success = await firebase_UpdateDocument(
            '${appName}_Users', userDoc['id'], {'token': token});
        if (success) {
          userDoc = {...userDoc, 'token': token};
        }
      }
      setUser(userDoc);
      return true;
    } else {
      return false;
    }
  }

  void alertSomethingWrong() {
    setAlertTitle('Uh Oh!');
    setAlertText('Something went wrong. Please try again.');
    setToggleAlert(true);
  }

  void alertMissingInfo() {
    setAlertTitle('Missing Info');
    setAlertText(
        'Please fill out all fields with the appropriate information.');
    setToggleAlert(true);
  }
}
