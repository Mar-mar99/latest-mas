// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:masbar/core/network/check_internet.dart';
import 'package:masbar/core/utils/enums/enums.dart';

import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failures.dart';

import '../../domain/repositories/edit_password_repo.dart';
import '../data_source/edit_password_data_source.dart';

class EditPasswordRepoImpl implements EditPasswordRepo {
  final NetworkInfo networkInfo;
  final EditPasswordDataSource editPasswordDataSource;
  EditPasswordRepoImpl({
    required this.networkInfo,
    required this.editPasswordDataSource,
  });

  @override
  Future<Either<Failure, Unit>> updatePassword({
    required String oldPassword,
    required String password,
    required String passwordConfirmation,
    required TypeAuth typeAuth,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final info = await editPasswordDataSource.updatePassword(
            oldPassword: oldPassword,
            password: password,
            passwordConfirmation: passwordConfirmation,
            typeAuth: typeAuth);
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
