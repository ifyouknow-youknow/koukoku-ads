import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:koukoku_ads/COMPONENTS/padding_view.dart';
import 'package:koukoku_ads/COMPONENTS/textfield_view.dart';
import 'package:koukoku_ads/FUNCTIONS/colors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

final googleKey = dotenv.env['GOOGLE_KEY'] ?? "";

class MapView extends StatefulWidget {
  final List<LatLng> locations;
  final double height;
  final double delta;
  final bool isScrolling;
  final bool isSearchable;
  final void Function(LatLng location)? onMarkerTap;
  final LatLng? initialArea;

  const MapView({
    Key? key,
    required this.locations,
    this.height = 300,
    this.delta = 0.001,
    this.isScrolling = false,
    this.isSearchable = false,
    this.onMarkerTap,
    this.initialArea,
  }) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late GoogleMapController _mapController;
  TextEditingController _searchController = TextEditingController();
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    if (await Permission.locationWhenInUse.request().isGranted) {
      print("Location permission granted");
    } else {
      print("Location permission denied");
    }
  }

  void _addMarkers() {
    Set<Marker> markers = widget.locations.map((location) {
      return Marker(
        markerId: MarkerId(location.toString()),
        position: location,
        onTap: () {
          if (widget.onMarkerTap != null) {
            widget.onMarkerTap!(location);
          }
        },
      );
    }).toSet();

    setState(() {
      _markers = markers;
    });
  }

  Future<void> _searchLocation(String address) async {
    final String apiKey = googleKey;
    final String url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        final location = data['results'][0]['geometry']['location'];
        final LatLng newPosition = LatLng(location['lat'], location['lng']);

        _mapController.animateCamera(
          CameraUpdate.newLatLng(newPosition),
        );
        setState(() {
          _markers.add(
            Marker(
              markerId: const MarkerId('searched_location'),
              position: newPosition,
              onTap: () {
                if (widget.onMarkerTap != null) {
                  widget.onMarkerTap!(newPosition);
                }
              },
            ),
          );
        });
      } else {
        print('Error: ${data['status']}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  void _setMapBounds() {
    if (widget.locations.isNotEmpty) {
      double southWestLat = widget.locations.first.latitude;
      double southWestLng = widget.locations.first.longitude;
      double northEastLat = widget.locations.first.latitude;
      double northEastLng = widget.locations.first.longitude;

      for (var location in widget.locations) {
        if (location.latitude < southWestLat) southWestLat = location.latitude;
        if (location.longitude < southWestLng)
          southWestLng = location.longitude;
        if (location.latitude > northEastLat) northEastLat = location.latitude;
        if (location.longitude > northEastLng)
          northEastLng = location.longitude;
      }

      double delta = widget.delta;

      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(southWestLat - delta, southWestLng - delta),
        northeast: LatLng(northEastLat + delta, northEastLng + delta),
      );

      _mapController.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 50),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.isSearchable)
          PaddingView(
            paddingTop: 0,
            paddingBottom: 10,
            child: Row(
              children: [
                Expanded(
                    child: TextfieldView(
                  controller: _searchController,
                  backgroundColor: hexToColor('#F6F8FA'),
                )),
                IconButton(
                  icon: const Icon(Icons.search, size: 30),
                  onPressed: () {
                    _searchLocation(_searchController.text);
                  },
                ),
              ],
            ),
          ),
        Container(
          height: widget.height,
          child: GoogleMap(
            onMapCreated: (controller) {
              _mapController = controller;
              if (widget.locations.isNotEmpty) {
                _addMarkers();
                _setMapBounds();
              }
            },
            initialCameraPosition: CameraPosition(
              target: widget.initialArea ??
                  (widget.locations.isNotEmpty
                      ? widget.locations.first
                      : const LatLng(0, 0)),
              zoom: 10,
            ),
            markers: _markers,
            scrollGesturesEnabled: widget.isScrolling,
            onTap: (position) {
              if (widget.locations.isEmpty) {
                setState(() {
                  _markers.add(
                    Marker(
                      markerId: const MarkerId('single_marker'),
                      position: position,
                      onTap: () {
                        if (widget.onMarkerTap != null) {
                          widget.onMarkerTap!(position);
                        }
                      },
                    ),
                  );
                });
              }
            },
          ),
        ),
      ],
    );
  }
}
