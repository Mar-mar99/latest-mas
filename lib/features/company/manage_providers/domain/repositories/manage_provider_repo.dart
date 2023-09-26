import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/provider_entity.dart';
import '../entities/provider_info_entity.dart';

abstract class ManageProviderRepo{
   Future<Either<Failure,ProviderInfoEntity>> getProvidersInfo();
  Future<Either<Failure,List<ProviderEntity>>> searchActiveProviders({required String key});
  Future<Either<Failure,List <ProviderEntity>>> getPending();
  Future<Either<Failure,Unit>> invite({
    required String firstname,
    required String lastname,
    required String mobile,
    required int state,
  });
  Future<Either<Failure,Unit>> enableUser({required int id});
  Future<Either<Failure,Unit>> disableUser({required int id});
    Future<Either<Failure,Unit>> reSendInvitations({required int id});
  Future<Either<Failure,Unit>> deleteInvitation({required int id});
}
