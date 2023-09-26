import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../entities/category_entity.dart';
import '../entities/created_request_result_entity.dart';
import '../entities/request_details_entity.dart';
import '../entities/request_service_entity.dart';
import '../entities/service_entity.dart';
import '../entities/service_info_entity.dart';
import '../entities/service_provider_entity.dart';

abstract class ExploreServicesRepo {
  Future<Either<Failure, List<ServiceEntity>>> getAllServices({required int id});
  Future<Either<Failure, List<ServiceEntity>>> searchServices({
     int? categoryId,
    required String text,
    String type = '',
    double distance = 0,
  });
  Future<Either<Failure, ServiceInfoEntity>> getServiceDetails(
      {required int serviceId, required int stateId});
  Future<Either<Failure, CreatedRequestResultEntity>> createService({
    required RequestServiceEntity requestService,
    List<File>? images,
  });

  Future<Either<Failure, Unit>> cancelRequest({
    required int id,
    required String reason,
  });
   Future<Either<Failure,RequestDetailsEntity>> getRequestDetails({
    required int id,
  });
   Future<Either<Failure,int?>> getPending();
  Future<Either<Failure,int?>> getActive();
   Future<Either<Failure,List<CategoryEntity>>> getCategories();
    Future<Either<Failure,
      Tuple4<List<ServiceProviderEntity>, List<ServiceProviderEntity>,
          List<ServiceProviderEntity>,int>>> searchServiceProviders({
    required int state,
    required double lat,
    required double lng,
    required String address,
    required int serviceType,
    required ServicePaymentType paymentStatus,
    required PaymentMethod paymentMethod,
    required int distance,
    DateTime? scheduleDate,
    DateTime? scheduleTime,
    String? notes,
    String? promoCode,
     List<Tuple2<int,dynamic>>?selectedAttributes,
      List<File>? images
  });
   Future<Either<Failure, Unit>> requestOnlineProvider({
    required int providerId,
    required int requestId,
    DateTime? scheduleDate,
    DateTime? scheduleTime,
       List<File>? images,
      String? notes
  });
  Future<Either<Failure, Unit>> requestOfflineProvider({
    required int providerId,
    required int requestId,
    required DateTime scheduleDate,
    required DateTime scheduleTime,
       List<File>? images,
      String? notes
  });
  Future<Either<Failure, Unit>> requestBusyProvider({
    required int providerId,
    required int requestId,
    required DateTime scheduleDate,
    required DateTime scheduleTime,
       List<File>? images,
      String? notes
  });
     Future<Either<Failure, Unit>> acceptProviderSechdule({required int providerId, required int requestId,});
}
