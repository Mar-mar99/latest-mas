// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:masbar/features/provider/homepage/data/model/request_provider_model.dart';
import 'package:masbar/features/provider/homepage/domain/entities/invoice_entity.dart';
import 'package:masbar/features/provider/homepage/domain/entities/offline_request_entity.dart';
import 'package:masbar/features/provider/homepage/domain/entities/request_provider_entity.dart';

import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failures.dart';
import '../../domain/repositories/provider_repo.dart';
import '../date_source/provider_data_source.dart';
import '../../../../../core/api_service/base_repo.dart';

class ProviderRepoImpl implements ProviderRepo {
  final ProviderDataSource providerDataSource;
  ProviderRepoImpl({
    required this.providerDataSource,
  });
  @override
  Future<Either<Failure, Unit>> goOnlineOrOffline(
      {required bool goOnline}) async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await providerDataSource.goOnlineOrOffline(goOnline: goOnline);
      },
    );
    return data.fold((f) => Left(f), (_) => const Right(unit));
  }

  @override
  Future<Either<Failure, Unit>> submitProviderLocation(
      {required double lat, required double lng}) async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await providerDataSource.submitProviderLocation(
            lat: lat, lng: lng);
      },
    );
    return data.fold((f) => Left(f), (_) => const Right(unit));
  }

  @override
  Future<Either<Failure, RequestProviderEntity>> getIncomingRequestDetails(
      {required int requestId}) async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await providerDataSource.getIncomingRequestDetails(
            requestId: requestId);
      },
    );
    return data.fold((f) => Left(f), (data) => Right(data));
  }

  @override
  Future<Either<Failure, Unit>> acceptRequest({required int id}) async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await providerDataSource.acceptRequest(id: id);
      },
    );
    return data.fold((f) => Left(f), (_) => const Right(unit));
  }

  @override
  Future<Either<Failure, Unit>> rejectRequest({required int id}) async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await providerDataSource.rejectRequest(id: id);
      },
    );
    return data.fold((f) => Left(f), (_) => const Right(unit));
  }

  @override
  Future<Either<Failure, RequestProviderEntity?>> currentRequestsApi() async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await providerDataSource.currentRequestsApi();
      },
    );
    return data.fold((f) => Left(f), (data) => Right(data));
  }

  @override
  Future<Either<Failure, Unit>> arrivedToLocation({required int id}) async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await providerDataSource.arrivedToLocation(id: id);
      },
    );
    return data.fold((f) => Left(f), (data) => Right(unit));
  }

  @override
  Future<Either<Failure, Unit>> cancelAfterAccept(
      {required int id, required String reason}) async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await providerDataSource.cancelAfterAccept(
            id: id, reason: reason);
      },
    );
    return data.fold((f) => Left(f), (data) => Right(unit));
  }

  @override
  Future<Either<Failure, InvoiceEntity>> finishWorkingOnTheService({
    required int requestId,
    List<File>? images,
    String? comment,
  }) async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await providerDataSource.finishWorkingOnTheService(
          requestId: requestId,
          comment: comment,
          images: images,
        );
      },
    );
    return data.fold((f) => Left(f), (data) => Right(data));
  }

  @override
  Future<Either<Failure, Unit>> startWorkingOnTheService(
      {required int id}) async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await providerDataSource.startWorkingOnTheService(id: id);
      },
    );
    return data.fold((f) => Left(f), (data) => Right(unit));
  }

  @override
  Future<Either<Failure, Unit>> recieveCash({required int id}) async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await providerDataSource.recieveCash(id: id);
      },
    );
    return data.fold((f) => Left(f), (data) => Right(unit));
  }

  @override
  Future<Either<Failure, RequestProviderEntity>> getRequestDetails(
      {required int requestId}) async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await providerDataSource.getRequestDetails(requestId: requestId);
      },
    );
    return data.fold((f) => Left(f), (data) => Right(data));
  }
@override
  Future<Either<Failure, Unit>> suggestAnotherTime(
      {required int requestId,
      required DateTime date,
      required DateTime time}) async {
         final data = await BaseRepo.repoRequest(
      request: () async {
        return await providerDataSource.suggestAnotherTime(
      requestId: requestId,
      date: date,
      time: time,
    );
      },
    );
    return data.fold((f) => Left(f), (data) => Right(unit));
      }

  @override
    Future<Either<Failure,List<OfflineRequestEntity>>> fetchOfflineRequests() async{
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await providerDataSource.fetchOfflineRequests();
      },
    );
    return data.fold((f) => Left(f), (data) => Right(data));
  }
}
