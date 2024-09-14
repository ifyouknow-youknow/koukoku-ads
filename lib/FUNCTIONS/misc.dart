import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

String randomString(int length) {
  const String chars =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  Random random = Random();
  return String.fromCharCodes(Iterable.generate(
    length,
    (_) => chars.codeUnitAt(random.nextInt(chars.length)),
  ));
}

void copyToClipboard(String text) {
  Clipboard.setData(ClipboardData(text: text));
  print("Copied: $text");
}

Future<void> setInDevice(String key, dynamic value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  try {
    if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is List<String>) {
      await prefs.setStringList(key, value);
    } else {
      throw ArgumentError('Unsupported value type');
    }
  } catch (error) {
    print("Error storing data: $error");
  }
}

Future<dynamic> getInDevice(String key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  try {
    return prefs.get(key);
  } catch (error) {
    print("Error getting data: $error");
    return null;
  }
}

Future<void> removeInDevice(String key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  try {
    bool removed = await prefs.remove(key);
    if (!removed) {
      print("No data found for the key: $key");
    }
  } catch (error) {
    print("Error removing data: $error");
  }
}

Future<String> writeToFile(dynamic fileData) async {
  final directory = await getTemporaryDirectory();
  final filePath = '${directory.path}/thing.mp3';
  final file = File(filePath);
  await file.writeAsBytes(fileData);
  return filePath;
}

Future<void> callPhoneNumber(String phoneNumber) async {
  final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

  if (await canLaunchUrl(phoneUri)) {
    await launchUrl(phoneUri);
  } else {
    throw 'Could not launch $phoneNumber';
  }
}
