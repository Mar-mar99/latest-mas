// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:masbar/core/constants/api_constants.dart';
import 'package:permission_handler/permission_handler.dart';

class Locationprediction {
  final String id;
  final String text;
  Locationprediction({
    required this.id,
    required this.text,
  });
}

class LocationService {
  static Future<List<Locationprediction>> getSuggestion(String input) async {
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$baseURL?input=$input&key=${dotenv.env['googleApisKey']}';

    List<Locationprediction> places = [];
    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body.toString());
      print('body $body');
      List<dynamic> predictions = body["predictions"];
      for (var e in predictions) {
        places.add(
          Locationprediction(
            text: e["description"] as String,
            id: e["place_id"],
          ),
        );
      }
      return places;
    } else {
      return [];
    }
  }

  static Future<GeoLoc?> getLocationDetails(String id) async {
    String baseURL = 'https://maps.googleapis.com/maps/api/place/details/json';

    String request = '$baseURL?place_id=$id&key=${dotenv.env['googleApisKey']}';

    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      print('body $body');
      var results = body['result'] as Map<String, dynamic>;
      var lat = results["geometry"]["location"]["lat"];
      var lng = results["geometry"]["location"]["lng"];
      // List<Placemark> placeMark = await placemarkFromCoordinates(
      //   lat,
      //   lng,
      // );
      // var _address =
      //     '${placeMark.first.street}, ${placeMark.first.name}, ${placeMark.first.administrativeArea}, ${placeMark.first.country}';
      GeoLoc details = GeoLoc(
        lat: lat,
        lng: lng,
      );
      print('lng: $lng');
      print('lat: $lat');
      return details;
    }
  }

  static Future<GeoLoc?> getLocationCoords() async {
    LocationPermission status = await Geolocator.checkPermission();

    if (status == LocationPermission.whileInUse ||
        status == LocationPermission.always) {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        GeoLoc geoLoc = GeoLoc(
          lng: position.longitude,
          lat: position.latitude,
        );

        print('lng ${position.longitude} lat ${position.latitude}');

        return geoLoc;
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    } else {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
      ].request();
    }
  }

  static Future<String> fetchAddress(GeoLoc loc) async {
    final response = await http.get(
      Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=${loc.lat},${loc.lng}&key=${dotenv.env['googleApisKey']}'),
    );
    print('status code ${response.statusCode} ');
    if (response.statusCode == 200) {
      Map<String, dynamic> responseJson = json.decode(response.body);
      print(responseJson.toString());
      if (responseJson["results"] != null &&
          responseJson["results"].length > 0) {
        return responseJson["results"][0]["formatted_address"];
      } else {
        return 'UAE';
      }
    } else {
      return 'UAE';
    }
  }
}

class GeoLoc {
  late double lat;
  late double lng;

  GeoLoc({required this.lat, required this.lng});

  GeoLoc.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}
