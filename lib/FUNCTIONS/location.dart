import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

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
