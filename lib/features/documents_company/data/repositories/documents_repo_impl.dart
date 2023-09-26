// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';

import 'package:masbar/core/errors/failures.dart';
import 'package:masbar/core/network/check_internet.dart';

import '../../../../../core/errors/exceptions.dart';
import '../../domain/entities/document_entity.dart';
import '../../domain/repositories/documents_repo.dart';
import '../data_source/documents_data_source.dart';

class DocumentsRepoImpl extends DocumentsRepo {
  final DocumentsDataSource documentsDataSource;
  final NetworkInfo networkInfo;
  DocumentsRepoImpl({
    required this.documentsDataSource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, Unit>> deleteDocument({
    required int id,
    required String token,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final data =
            await documentsDataSource.deleteDocument(id: id, token: token);
        return const Right(unit);
      } on ExceptionTimeout {
        return Left(NetworkErrorFailure(message: 'Time out'));
      } on ExceptionSocket {
        return Left(NetworkErrorFailure(message: 'Socket Error'));
      } on ExceptionFormat {
        return Left(NetworkErrorFailure(message: 'Bad Response Format'));
      } on ExceptionHandshake {
        return Left(NetworkErrorFailure(message: 'Handshake Error'));
      } on ExceptionOther {
        return Left(NetworkErrorFailure(message: 'Error'));
      } on CustomException catch (e) {
        return Left(NetworkErrorFailure(message: e.message));
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> editDocument(
      {required File file, required int id, required String token})  async {
    if (await networkInfo.isConnected) {
      try {
        final data =
            await documentsDataSource.editDocument(file: file, id: id, token: token);
        return const Right(unit);
      } on ExceptionTimeout {
        return Left(NetworkErrorFailure(message: 'Time out'));
      } on ExceptionSocket {
        return Left(NetworkErrorFailure(message: 'Socket Error'));
      } on ExceptionFormat {
        return Left(NetworkErrorFailure(message: 'Bad Response Format'));
      } on ExceptionHandshake {
        return Left(NetworkErrorFailure(message: 'Handshake Error'));
      } on ExceptionOther {
        return Left(NetworkErrorFailure(message: 'Error'));
      } on CustomException catch (e) {
        return Left(NetworkErrorFailure(message: e.message));
      }
    } else {
      return Left(OfflineFailure());
    }
  }


  @override
  Future<Either<Failure, List< DocumentEntity>>> getDocuments(
      {required String token}) async {
    if (await networkInfo.isConnected) {
      try {
        final data =
            await documentsDataSource.getDocuments( token: token);
        return  Right(data);
      } on ExceptionTimeout {
        return Left(NetworkErrorFailure(message: 'Time out'));
      } on ExceptionSocket {
        return Left(NetworkErrorFailure(message: 'Socket Error'));
      } on ExceptionFormat {
        return Left(NetworkErrorFailure(message: 'Bad Response Format'));
      } on ExceptionHandshake {
        return Left(NetworkErrorFailure(message: 'Handshake Error'));
      } on ExceptionOther {
        return Left(NetworkErrorFailure(message: 'Error'));
      } on CustomException catch (e) {
        return Left(NetworkErrorFailure(message: e.message));
      }
    } else {
      return Left(OfflineFailure());
    }
  }


  @override
  Future<Either<Failure, Unit>> uploadDocument(
      {required File file, required String token})  async {
    if (await networkInfo.isConnected) {
      try {
        final data =
            await documentsDataSource.uploadDocument(file: file, token: token);
        return const Right(unit);
      } on ExceptionTimeout {
        return Left(NetworkErrorFailure(message: 'Time out'));
      } on ExceptionSocket {
        return Left(NetworkErrorFailure(message: 'Socket Error'));
      } on ExceptionFormat {
        return Left(NetworkErrorFailure(message: 'Bad Response Format'));
      } on ExceptionHandshake {
        return Left(NetworkErrorFailure(message: 'Handshake Error'));
      } on ExceptionOther {
        return Left(NetworkErrorFailure(message: 'Error'));
      } on CustomException catch (e) {
        return Left(NetworkErrorFailure(message: e.message));
      }
    } else {
      return Left(OfflineFailure());
    }


  }


}
