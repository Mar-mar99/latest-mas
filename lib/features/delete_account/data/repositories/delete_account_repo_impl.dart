// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:masbar/core/errors/failures.dart';
import 'package:masbar/core/network/check_internet.dart';
import 'package:masbar/core/utils/enums/enums.dart';

import '../../../../core/errors/exceptions.dart';
import '../../domain/repositories/delete_account_repo.dart';
import '../data_source/delete_account_data_source.dart';

class DeleteAccountRepoImpl implements DeleteAccountRepo {
  final DeleteAccountDataSource deleteAccountDataSource;
  final NetworkInfo networkInfo;
  DeleteAccountRepoImpl({
    required this.deleteAccountDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Unit>> deleteAccount(
      {required TypeAuth typeAuth}) async {
    if (await networkInfo.isConnected) {
      try {
        final info =
            await deleteAccountDataSource.deleteAccount(typeAuth: typeAuth);
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
