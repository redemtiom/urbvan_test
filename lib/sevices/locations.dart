import 'dart:async';
import 'dart:convert';
import 'package:urbvan_test/models/iss_model.dart';
//import 'package:urbvan_test/models/directions_model.dart';
import 'package:urbvan_test/global_environments.dart';
import 'package:http/http.dart' as http;

class Service {
  Future fetchIssPosition() async {
    final response =
        await http.get(Uri.http('api.open-notify.org', '/iss-now.json'));
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      return body;
    } else {
      throw Exception("Unable to perform iss request!");
    }
  }

  Future fetchGoogleDirection(String origin, String destination) async {
    final response = await http
        .get(Uri.https('maps.googleapis.com', '/maps/api/directions/json', {
      'origin': origin,
      'destination': destination,
      'key': mapApiKey
    }));
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      return body['routes'][0]['overview_polyline']['points'];

    } else {
      throw Exception("Unable to perform direction request!");
    }
  }
}
