import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
