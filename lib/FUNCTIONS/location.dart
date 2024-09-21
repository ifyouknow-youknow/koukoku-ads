import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:koukoku_ads/MODELS/geohash.dart';
import 'package:url_launcher/url_launcher.dart';

Future<Position?> getLocation(BuildContext context) async {
  while (true) {
    try {
      // Request permission to access location
      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        // Permission granted, get current position
        Position userLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        return userLocation; // Return the user location
      } else if (permission == LocationPermission.deniedForever) {
        // Permission is permanently denied
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Location Permission Needed'),
            content: Text(
                'Please enable location permissions in your device settings to use this feature.'),
            actions: <Widget>[
              TextButton(
                child: Text('Settings'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Geolocator.openLocationSettings(); // Open location settings
                },
              ),
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          ),
        );
        return null;
      } else {
        // Permission denied, request again
        await Future.delayed(
            Duration(seconds: 1)); // Optional delay to prevent rapid retries
      }
    } catch (error) {
      // Handle any other errors
      print('Error getting location: $error');
      return null;
    }
  }
}

Future<void> getDirections(LatLng destination) async {
  final String googleMapsUrl =
      'https://www.google.com/maps/dir/?api=1&destination=${destination.latitude},${destination.longitude}&travelmode=driving';

  if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
    await launchUrl(
      Uri.parse(googleMapsUrl),
      mode: LaunchMode
          .externalApplication, // Ensures it opens in the default browser
    );
  } else {
    throw 'Could not open Google Maps for directions';
  }
}

// Function to calculate geohash range based on the center and distance
List<String> calculateGeohashRange(double lat, double lon, double distance) {
  // Calculate precision based on distance
// Ensure precision is in a valid range (1 to 12)

  // Calculate bounding box coordinates (lower-left and upper-right)
  var lowerLeft = calculateLatLonOffset(lat, lon, -distance, -distance);
  var upperRight = calculateLatLonOffset(lat, lon, distance, distance);

  // Generate geohashes for bounding box corners
  String lowerLeftHash = Geohash.encode(lowerLeft[0], lowerLeft[1]);
  print('Lower Left Geohash: $lowerLeftHash');

  String upperRightHash = Geohash.encode(upperRight[0], upperRight[1]);
  print('Upper Right Geohash: $upperRightHash');

  return [lowerLeftHash, upperRightHash];
}

// Helper function to calculate the latitude/longitude offsets for bounding box
List<double> calculateLatLonOffset(
    double lat, double lon, double latOffsetKm, double lonOffsetKm) {
  const double earthRadius = 6371.0; // Earth radius in kilometers

  double latOffset = latOffsetKm / earthRadius;
  double lonOffset = lonOffsetKm / (earthRadius * cos(lat * pi / 180));

  double newLat = lat + (latOffset * 180 / pi);
  double newLon = lon + (lonOffset * 180 / pi);

  return [newLat, newLon];
}

int calculateGeohashPrecision(double distance) {
  if (distance > 2500) return 1; // Very large area
  if (distance > 1250) return 2;
  if (distance > 625) return 3;
  if (distance > 300) return 4;
  if (distance > 150) return 5;
  return 6; // Max precision supported by your geohash library
}
