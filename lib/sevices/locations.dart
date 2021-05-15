import 'dart:async';
import 'dart:convert';
import 'package:urbvan_test/models/iss_model.dart';
import 'package:urbvan_test/models/directions_model.dart';
import 'package:http/http.dart' as http;

class Service {
  Future<void> fetchIssPosition() async {
    final response =
        await http.get(Uri.http('api.open-notify.org', '/iss-now.json'));
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      return Iss.fromJson(body);
    } else {
      throw Exception("Unable to perform iss request!");
    }
  }

  Future<void> fetchGoogleDirection(String origin, String destination) async {
    final response = await http
        .get(Uri.https('maps.googleapis.com', '/maps/api/directions/json', {
      'origin': origin,
      'destination': destination,
      'key': 'ENTER_YOUR_API_KEY_HERE'
    }));
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      return Directions.fromJson(body);

    } else {
      throw Exception("Unable to perform direction request!");
    }
  }
}
