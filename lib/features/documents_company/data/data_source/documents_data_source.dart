// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/utils/helpers/decode_response.dart';
import '../models/document_model.dart';

abstract class DocumentsDataSource {
  Future<List<DocumentModel>> getDocuments({required String token});
  Future<void> uploadDocument({required File file, required String token});
  Future<void> editDocument(
      {required File file, required int id, required String token});
  Future<void> deleteDocument({required int id, required String token});
}

class DocumentsDataSourceWithHttp extends DocumentsDataSource {
  final http.Client client;
  DocumentsDataSourceWithHttp({
    required this.client,
  });

  @override
  Future<void> deleteDocument({required int id, required String token}) async {
    try {

      final response = await client.get(
        Uri.parse(
          '${ApiConstants.baseAppUrl}${ApiConstants.deleteDocumentAPI}$id',
        ),
        headers: {
          "content-type": "application/json; charset=utf-8",
          'api': '1.0.0',
          'X-Requested-With': "XMLHttpRequest",
          "Accept": "application/json",
          'Authorization': 'Bearer $token',
        },
      );
      print('status code ${response.statusCode}');
      print('the body : ${response.body}');
      return;
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
  Future<void> editDocument(
      {required File file, required int id, required String token}) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          '${ApiConstants.baseAppUrl}${ApiConstants.reUploadDocumentAPI}$id',
        ),
      );
      request.headers['X-Requested-With'] = "XMLHttpRequest";
      request.headers['content-type'] = "application/json; charset=utf-8";
      request.headers['Authorization'] = "Bearer $token";
      request.files.add(await http.MultipartFile.fromPath(
        'document',
        file.path,
      ));

      final response = await request.send();
      String responseString = '';
      final responseData = await response.stream.toBytes();
      print('responseData $responseData');
      responseString = String.fromCharCodes(responseData);

      print('status code ${response.statusCode}');
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        print('response $response');
        print('responseString $responseString');
        return;
      } else {
        print('decoding....');
        final errorData = json.decode(responseString);
        print('responseString $responseString');
        String errorMessage = errorData['error'];
        throw CustomException(message: errorMessage);
      }
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
  Future<List<DocumentModel>> getDocuments({required String token}) async {
    try {
      final response = await client.get(
        Uri.parse(
          '${ApiConstants.baseAppUrl}${ApiConstants.getDocumentAPI}',
        ),
        headers: {
          "content-type": "application/json; charset=utf-8",
          'api': '1.0.0',
          'X-Requested-With': "XMLHttpRequest",
          "Accept": "application/json",
          'Authorization': 'Bearer $token',
        },
      );
      print('status code ${response.statusCode}');
      print('the body : ${response.body}');
      final decodedResponse = DecodeResponse.decode(response) as List;
      List<DocumentModel> documets = [];
      for (var c in decodedResponse) {
        documets.add(DocumentModel.fromJson(c));
      }
      return documets;
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
  Future<void> uploadDocument(
      {required File file, required String token}) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          '${ApiConstants.baseAppUrl}${ApiConstants.uploadDocumentAPI}',
        ),
      );
      request.headers['X-Requested-With'] = "XMLHttpRequest";
      request.headers['content-type'] = "application/json; charset=utf-8";
      request.headers['Authorization'] = "Bearer $token";
      request.files.add(await http.MultipartFile.fromPath(
        'document',
        file.path,
      ));

      final response = await request.send();
      String responseString = '';
      final responseData = await response.stream.toBytes();
      print('responseData $responseData');
      responseString = String.fromCharCodes(responseData);

      print('status code ${response.statusCode}');
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        print('response $response');
        print('responseString $responseString');
        return;
      } else {
        print('decoding....');
        final errorData = json.decode(responseString);
        print('responseString $responseString');
        String errorMessage = errorData['error'];
        throw CustomException(message: errorMessage);
      }
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
