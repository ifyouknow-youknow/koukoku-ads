// toggles.dart
part of 'datamaster.dart';

mixin _DataMasterToggles {
  bool _toggleLoading = false;
  bool _toggleAlert = false;
  bool _toggleBubble = false;

  bool get toggleLoading => _toggleLoading;
  bool get toggleAlert => _toggleAlert;
  bool get toggleBubble => _toggleBubble;

  void setToggleLoading(bool value) => _toggleLoading = value;
  void setToggleAlert(bool value) => _toggleAlert = value;
  void setToggleBubble(bool value) => _toggleBubble = value;
}
