import 'dart:io';

import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failures.dart';
import 'package:dartz/dartz.dart';

import '../../data/model/request_provider_model.dart';
import '../entities/invoice_entity.dart';
import '../entities/offline_request_entity.dart';
import '../entities/request_provider_entity.dart';

abstract class ProviderRepo {
  Future<Either<Failure, Unit>> submitProviderLocation(
      {required double lat, required double lng});
  Future<Either<Failure, Unit>> goOnlineOrOffline({required bool goOnline});
  Future<Either<Failure, RequestProviderEntity>> getIncomingRequestDetails({
    required int requestId,
  });
   Future<Either<Failure,Unit>> acceptRequest({
    required int id,
  });
  Future<Either<Failure,Unit>> rejectRequest({
    required int id,
  });
    Future<Either<Failure,RequestProviderEntity?>> currentRequestsApi();
     Future<Either<Failure,Unit>> arrivedToLocation({
    required int id,
  });
  Future<Either<Failure,Unit>> cancelAfterAccept({
    required int id,
    required String reason,
  });
  Future<Either<Failure,Unit>> startWorkingOnTheService({
    required int id,
  });
  Future<Either<Failure,InvoiceEntity>> finishWorkingOnTheService({
    required int requestId,
    List<File>? images,
    String? comment,
  });
 Future<Either<Failure,Unit>> recieveCash({
    required int id,
  });
    Future<Either<Failure,RequestProviderEntity>> getRequestDetails(
      {required int requestId});
      Future<Either<Failure, Unit>> suggestAnotherTime(
      {required int requestId,
      required DateTime date,
      required DateTime time});
       Future<Either<Failure,List<OfflineRequestEntity>>> fetchOfflineRequests();
}
