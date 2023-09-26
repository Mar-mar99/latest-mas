import 'package:dio/dio.dart';

import 'exceptions.dart';

class DioExceptions implements Exception {
  late String message;

  DioExceptions.fromDioError(DioError dioError) {
    print('dio error ${dioError.toString()}');
    switch (dioError.type) {
      case DioErrorType.cancel:
       throw CustomException(message: 'Error');
        // message = "Request to API server was cancelled";

      case DioErrorType.connectionTimeout:
        throw ExceptionTimeout();

      case DioErrorType.receiveTimeout:
        throw ExceptionTimeout();

      case DioErrorType.badResponse:
        String errorMessage = dioError.response?.data['error'];
        throw CustomException(message: errorMessage);

      case DioErrorType.sendTimeout:
        throw ExceptionTimeout();
      // case DioErrorType.other:
      //   if (dioError.message.contains("SocketException")) {
      //     message = 'No Internet';
      //     break;
      //   }
      // message = "Unexpected error occurred";
      // break;
      // default:
      //   message = "Something went wrong";
      //   break;
      case DioErrorType.badCertificate:
        throw CustomException(message: 'Error');

      case DioErrorType.connectionError:
 throw ExceptionSocket();

      case DioErrorType.unknown:
          throw CustomException(message: 'Error');

        // message = _handleError(
        //   dioError.response?.statusCode,
        //   dioError.response?.data,
        // );
        
    }
  }

  String _handleError(int? statusCode, dynamic error) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return error['message'];
      case 500:
        return 'Internal server error';
      case 502:
        return 'Bad gateway';
      default:
        return 'Oops something went wrong';
    }
  }

  @override
  String toString() => message;
}
