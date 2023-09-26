import 'package:dartz/dartz.dart';
import 'package:masbar/core/errors/exceptions.dart';
import 'package:masbar/core/network/check_internet.dart';
import 'package:masbar/core/utils/enums/enums.dart';
import 'package:masbar/features/user_emirate/domain/entities/uae_state_entity.dart';

import '../../../../../core/errors/failures.dart';

import '../../domain/repositories/uae_state_repo.dart';
import '../data sources/uae_states_remote_data_source.dart';

class UAEStatesRepoImpl implements UaeStateRepo {
  UAEStatesRemoteDataSource uaeStatesRemoteDataSource;
  NetworkInfo networkInfo;

  UAEStatesRepoImpl({
    required this.uaeStatesRemoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<UAEStateEntity>>> fetchStates() async {
    if (await networkInfo.isConnected) {
      try {
        final states = await uaeStatesRemoteDataSource.fetchStates();
        return Right(states);
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
