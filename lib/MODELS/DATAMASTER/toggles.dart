// toggles.dart
part of 'datamaster.dart';

mixin _DataMasterToggles {
  bool _toggleLoading = false;
  bool _toggleAlert = false;
  bool _toggleBubble = false;
  bool _toggleSplash = true;
  bool _toggleSplash2 = false;

  bool get toggleLoading => _toggleLoading;
  bool get toggleAlert => _toggleAlert;
  bool get toggleBubble => _toggleBubble;
  bool get toggleSplash => _toggleSplash;
  bool get toggleSplash2 => _toggleSplash2;

  void setToggleLoading(bool value) => _toggleLoading = value;
  void setToggleAlert(bool value) => _toggleAlert = value;
  void setToggleBubble(bool value) => _toggleBubble = value;
  void setToggleSplash(bool value) => _toggleSplash = value;
  void setToggleSplash2(bool value) => _toggleSplash2 = value;
}
