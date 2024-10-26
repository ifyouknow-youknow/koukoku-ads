import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ads_mahem/MODELS/constants.dart';

Future<dynamic> server_POST(String endpoint, Map<String, dynamic> data) async {
  try {
    var uri = Uri.parse('$serverUrl/$endpoint');

    if (data.containsKey('file') && data['file'] is File) {
      // Handle case where 'file' key contains a File object
      var request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath(
        'audio',
        data['file'].path,
      ));

      // Add other data fields if any
      data.forEach((key, value) {
        if (key != 'file') {
          request.fields[key] = value.toString();
        }
      });

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        print('Server response: $responseBody');
        return responseBody;
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } else {
      // Handle regular JSON data POST
      var response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        print('Server response: $responseBody');
        return responseBody;
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    }
  } catch (e) {
    print('Error: $e');
  }
}

Future<void> server_GET(String endpoint) async {
  try {
    var url = Uri.parse('$serverUrl/$endpoint');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      print('Server response: $responseBody');
    } else {
      print('Error: ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
