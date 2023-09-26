// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:masbar/core/network/check_internet.dart';
import 'package:masbar/features/company/manage_providers/data/data_source/manage_provider_data_source.dart';
import 'package:masbar/features/company/manage_providers/domain/entities/provider_entity.dart';

import '../../../../../core/api_service/base_repo.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failures.dart';
import '../../domain/entities/provider_info_entity.dart';
import '../../domain/repositories/manage_provider_repo.dart';

class ManageProviderRepoImpl implements ManageProviderRepo {
  final NetworkInfo networkInfo;
  final ManageProvidersDataSource manageProvidersDataSource;
  ManageProviderRepoImpl({
    required this.networkInfo,
    required this.manageProvidersDataSource,
  });

  @override
  Future<Either<Failure, Unit>> disableUser({required int id}) async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await manageProvidersDataSource.disableUser(id: id);
      },
    );
    return data.fold((f) => Left(f), (data) => Right(unit));
  }

  @override
  Future<Either<Failure, Unit>> enableUser({required int id}) async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await manageProvidersDataSource.enableUser(id: id);
      },
    );
    return data.fold((f) => Left(f), (data) => Right(unit));
  }

  @override
  Future<Either<Failure, List<ProviderEntity>>> getPending() async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await manageProvidersDataSource.getPending();
      },
    );
    return data.fold((f) => Left(f), (data) => Right(data));
  }

  @override
  Future<Either<Failure, ProviderInfoEntity>> getProvidersInfo() async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await manageProvidersDataSource.getProvidersInfo();
      },
    );
    return data.fold((f) => Left(f), (data) => Right(data));
  }

  @override
  Future<Either<Failure, Unit>> invite(
      {required String firstname,
      required String lastname,
      required String mobile,
      required int state}) async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await manageProvidersDataSource.invite(
          firstname: firstname,
          lastname: lastname,
          mobile: mobile,
          state: state,
        );
      },
    );
    return data.fold((f) => Left(f), (data) => Right(unit));
  }

  @override
  Future<Either<Failure, Unit>> deleteInvitation({required int id}) async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await manageProvidersDataSource.deleteInvitation(id: id);
      },
    );
    return data.fold((f) => Left(f), (data) => Right(unit));
  }

  @override
  Future<Either<Failure, Unit>> reSendInvitations({required int id}) async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await manageProvidersDataSource.reSendInvitations(id: id);
      },
    );
    return data.fold((f) => Left(f), (data) => Right(unit));
  }

  @override
  Future<Either<Failure, List<ProviderEntity>>> searchActiveProviders({required String key}) async{
  final data = await BaseRepo.repoRequest(
      request: () async {
        return await manageProvidersDataSource.searchActiveProviders(key: key);
      },
    );
    return data.fold((f) => Left(f), (data) => Right(data));
  }
}
