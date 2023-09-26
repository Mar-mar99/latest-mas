import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:masbar/core/constants/api_constants.dart';

import 'package:masbar/core/utils/helpers/decode_response.dart';

import 'package:masbar/features/user_emirate/data/models/uae_state_model.dart';
import '../../../../../core/errors/exceptions.dart';

abstract class UAEStatesRemoteDataSource {
  Future<List<UAEStateModel>> fetchStates();
}

class UAEStatesDataSourceWithHttp implements UAEStatesRemoteDataSource {
  final http.Client client;
  UAEStatesDataSourceWithHttp({
    required this.client,
  });
  @override
  Future<List<UAEStateModel>> fetchStates() async {
    try {
      print('${ApiConstants.baseAppUrl}${ApiConstants.uaeStates}');
      final response = await client.get(
        Uri.parse('${ApiConstants.baseAppUrl}${ApiConstants.uaeStates}'),
        headers: {"content-type": "application/json; charset=utf-8"},
      );

      print('status code ${response.statusCode}');
      print('the body : ${response.body}');
      final decodedResponse = DecodeResponse.decode(response);
      List<UAEStateModel> uaeStatesList = (decodedResponse['states'] as List)
          .map((e) => UAEStateModel.fromJson(e))
          .toList();
      return uaeStatesList;
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
