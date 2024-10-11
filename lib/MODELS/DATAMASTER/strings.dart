// strings.dart
part of 'datamaster.dart';

mixin _DataMasterStrings {
  String _alertTitle = "Alert Title";
  String _alertText = "Alert Text";
  String _bubbleText = "You are the bagel, the bagel is nothing.";

  String get alertTitle => _alertTitle;
  String get alertText => _alertText;
  String get bubbleText => _bubbleText;

  void setAlertTitle(String value) => _alertTitle = value;
  void setAlertText(String value) => _alertText = value;
  void setBubbleText(String value) => _bubbleText = value;
}
