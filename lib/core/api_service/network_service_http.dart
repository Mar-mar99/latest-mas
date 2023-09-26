import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../errors/exceptions.dart';
import '../managers/languages_manager.dart';
import '../utils/helpers/decode_response.dart';
import '../utils/services/shared_preferences.dart';
import 'base_api_service.dart';

class NetworkServiceHttp implements BaseApiService {
  @override
  Future<dynamic> getRequest({required String url}) async {
    try {
      String? token = PreferenceUtils.getString('TOKEN');
      String? lng = PreferenceUtils.getString('LANGUAGE');

      print('GET url ${ApiConstants.baseAppUrl}$url');
      print('lng $lng');
    
      final response = await http.get(
        Uri.parse('${ApiConstants.baseAppUrl}$url'),
        headers: {
          "Accept": "application/json; charset=utf-8",
          //'api': '1.0.0',
          //'X-Requested-With': "XMLHttpRequest",
          "locale": lng ?? LanguagesManager.English,
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      print('status code ${response.statusCode}');
      print('the body : ${response.body}');
      final decodedResponse = DecodeResponse.decode(response);

      return decodedResponse;
    } on SocketException {
      throw ExceptionSocket();
    } on FormatException {
      throw ExceptionFormat();
    } on TimeoutException {
      throw ExceptionTimeout();
    } on HandshakeException catch (e) {
      throw ExceptionHandshake();
    } on CustomException catch (e) {
      throw CustomException(message: e.message);
    } on Exception {
      throw ExceptionOther();
    }
  }

  @override
  Future postRequest({required String url, required jsonBody}) async {
    try {
      String? token = PreferenceUtils.getString('TOKEN');
      String? lng = PreferenceUtils.getString('LANGUAGE');

      print('POST url ${ApiConstants.baseAppUrl}$url');
      print('the posted body ${jsonBody.toString()}');
      print('lng ${lng ?? LanguagesManager.English}');
      final response =
          await http.post(Uri.parse('${ApiConstants.baseAppUrl}$url'),
              headers: {
                "content-type": "application/json; charset=utf-8",
                //'api': '1.0.0',
                'X-Requested-With': "XMLHttpRequest",
                "Accept": "application/json",
                "locale": lng ?? LanguagesManager.English,

                if (token != null) 'Authorization': 'Bearer $token',
              },
              body: json.encode(jsonBody));

      print('status code ${response.statusCode}');
      print('the body : ${response.body}');
      final decodedResponse = DecodeResponse.decode(response);

      return decodedResponse;
    } on SocketException {
      throw ExceptionSocket();
    } on FormatException {
      throw ExceptionFormat();
    } on TimeoutException {
      throw ExceptionTimeout();
    } on HandshakeException catch (e) {
      throw ExceptionHandshake();
    } on CustomException catch (e) {
      throw CustomException(message: e.message);
    } on Exception {
      throw ExceptionOther();
    }
  }

  @override
  Future multipartRequest({
    required String url,
    required Map<String, dynamic> jsonBody,
    required String? attributeName,
    required List<File>? files,
  }) async {
    try {
      String? token = PreferenceUtils.getString('TOKEN');
      String? lng = PreferenceUtils.getString('LANGUAGE');

      print('url $url');
      print('the posted body ${jsonBody.toString()}');
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConstants.baseAppUrl}$url'),
      );
      request = jsonToFormData(request, jsonBody);
      print('request ${request.fields.toString()}');
      if (files != null) {
        for (var element in files) {
          print('file: ${element.path}');
          request.files.add(await http.MultipartFile.fromPath(
            attributeName!,
            element.path,
          ));
        }
      }

      request.headers['X-Requested-With'] = "XMLHttpRequest";
      request.headers['Accept'] = "application/json; charset=utf-8";
      request.headers["locale"] = lng ?? LanguagesManager.English;

      if (token != null) request.headers['Authorization'] = "Bearer $token";
      final response = await request.send();
      final decodedResponse =
          DecodeResponse.decodeMultiplePartResponse(response);
      return decodedResponse;
    } on SocketException {
      throw ExceptionSocket();
    } on FormatException {
      throw ExceptionFormat();
    } on TimeoutException {
      throw ExceptionTimeout();
    } on HandshakeException catch (e) {
      throw ExceptionHandshake();
    } on CustomException catch (e) {
      throw CustomException(message: e.message);
    } on Exception {
      throw ExceptionOther();
    }
  }

  @override
  Future deleteRequest({required String url}) async {
    try {
      String? token = PreferenceUtils.getString('TOKEN');
      String? lng = PreferenceUtils.getString('LANGUAGE');
      print('url $url');

      final response = await http.delete(
        Uri.parse('${ApiConstants.baseAppUrl}$url'),
        headers: {
          // "content-type": "application/json; charset=utf-8",
          'api': '1.0.0',
          'X-Requested-With': "XMLHttpRequest",
          "Accept": "application/json",
          "locale": lng ?? LanguagesManager.English,
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      print('status code ${response.statusCode}');
      print('the body : ${response.body}');
      final decodedResponse = DecodeResponse.decode(response);

      return decodedResponse;
    } on SocketException {
      throw ExceptionSocket();
    } on FormatException {
      throw ExceptionFormat();
    } on TimeoutException {
      throw ExceptionTimeout();
    } on HandshakeException catch (e) {
      throw ExceptionHandshake();
    } on CustomException catch (e) {
      throw CustomException(message: e.message);
    } on Exception {
      throw ExceptionOther();
    }
  }
}

jsonToFormData(http.MultipartRequest request, Map<String, dynamic> data) {
  for (var key in data.keys) {
    request.fields[key] = data[key].toString();
  }
  return request;
}
