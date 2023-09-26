// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:masbar/core/network/check_internet.dart';
import 'package:masbar/core/utils/enums/enums.dart';

import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failures.dart';

import '../../domain/repositories/update_profile_repo.dart';

import '../data_source/update_profile_data_source.dart';

class UpdateProfileRepoImpl implements UpdateProfileRepo {
  final NetworkInfo networkInfo;
  final UpdateProfileDataSource updateProfileDataSource;
  UpdateProfileRepoImpl({
    required this.networkInfo,
    required this.updateProfileDataSource,
  });

  @override
  Future<Either<Failure, Unit>> updateUserProfile({
    required String firstName,
    required String lastName,
    required int state,
    File? avatar,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final info = await updateProfileDataSource.updateUserProfile(
            firstName: firstName,
            lastName: lastName,
            state: state,
            avatar: avatar);
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
  Future<Either<Failure, Unit>> updateUserPhone({
    required String phone,
    required TypeAuth typeAuth,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final info = await updateProfileDataSource.updateUserPhone(
            phone: phone, typeAuth: typeAuth);
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
  Future<Either<Failure, Unit>> updateCompanyProfile({
    required String firstName,
    required String address,
    required int local,
    required int state,
    File? avatar,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final info = await updateProfileDataSource.updateCompanyProfile(
            firstName: firstName,
            address: address,
            local: local,
            state: state,
            avatar: avatar);
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
  Future<Either<Failure, Unit>> updateProviderProfile({
    required String firstName,
    required String lastName,
    required int state,
    File? avatar,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final info = await updateProfileDataSource.updateProviderProfile(
            firstName: firstName,
            lastName: lastName,
            state: state,
            avatar: avatar);
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
  Future<Either<Failure, Unit>> verifyUserPhone({
    required String phone,
    required String phoneCode,
    required TypeAuth typeAuth,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final info = await updateProfileDataSource.verifyUserPhone(
          phone: phone,
          typeAuth: typeAuth,
          phoneCode: phoneCode,
        );
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
