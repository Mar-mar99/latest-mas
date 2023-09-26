import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../errors/dio_exceptions.dart';
import '../errors/exceptions.dart';
import '../utils/services/shared_preferences.dart';
import 'base_api_service.dart';

class NetworkServiceDio implements BaseApiService {

  Future<Dio> get dio async {
    String? token = PreferenceUtils.getString("TOKEN");

    return Dio(BaseOptions(
      baseUrl: ApiConstants.baseAppUrl,
      connectTimeout: const Duration(seconds: 100000),
      receiveTimeout: const Duration(seconds: 100000),
      headers: {
        'api': '1.0.0',
        'X-Requested-With': "XMLHttpRequest",
        if (token != null) 'Authorization': 'Bearer $token',
      },
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    ));
  }

  @override
  Future deleteRequest({required String url}) {
    // TODO: implement deleteRequest
    throw UnimplementedError();
  }

  @override
  Future getRequest({required String url}) {
    // TODO: implement getRequest
    throw UnimplementedError();
  }

  @override
  Future multipartRequest({
    required String url,
    required Map<String, dynamic> jsonBody,
    required String? attributeName,
    required List<File>? files,
  }) async {
    try {
      Dio _dio = await dio;

      if (attributeName != null && files != null) {
        List<MultipartFile> docsFile = [];
        for (var element in files) {
          String fileName = element.path.split('/').last;
          docsFile.add(
            await MultipartFile.fromFile(
              element.path,
              filename: fileName,
            ),
          );
        }
        jsonBody[attributeName] = docsFile;
      }
      print('url $url');
      print('the posted body ${jsonBody.toString()}');
      FormData formData = FormData.fromMap(jsonBody);
      print('the posted form data ${formData.fields.toList()}');
      final response = await _dio.post(url, data: formData);
      print('statusss code ${response.statusCode}');
      print('the body : ${response.data}');
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! <= 299) {
        return response.data;
      } else {
        String errorMessage = response.data['error'];
        throw CustomException(message: errorMessage);
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      // throw CustomException(message: errorMessage);
      rethrow ;
    }
  }

  @override
  Future postRequest(
      {required String url, required Map<String, dynamic> jsonBody}) {
    // TODO: implement postRequest
    throw UnimplementedError();
  }
}
