// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:masbar/core/errors/failures.dart';
import 'package:masbar/core/utils/enums/enums.dart';
import 'package:masbar/features/user/services/domain/entities/category_entity.dart';
import 'package:masbar/features/user/services/domain/entities/request_details_entity.dart';
import 'package:masbar/features/user/services/domain/entities/request_service_entity.dart';
import 'package:masbar/features/user/services/domain/entities/service_entity.dart';
import 'package:masbar/features/user/services/domain/entities/service_info_entity.dart';
import 'package:masbar/features/user/services/domain/entities/service_provider_entity.dart';

import '../../../../../core/api_service/base_repo.dart';
import '../../domain/entities/created_request_result_entity.dart';
import '../../domain/repositories/explore_services_repo.dart';
import '../data_source/explore_services_data_source.dart';
import '../model/request_service_model.dart';

class ExploreServicesRepoImpl implements ExploreServicesRepo {
  final ExploreServicesDataSource exploreServicesDataSource;
  ExploreServicesRepoImpl({
    required this.exploreServicesDataSource,
  });
  @override
  Future<Either<Failure, List<ServiceEntity>>> getAllServices(
      {required int id}) async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await exploreServicesDataSource.getCategoryServices(
            categoryId: id);
      },
    );
    return data.fold((f) => Left(f), (data) => Right(data));
  }

  @override
  Future<Either<Failure, ServiceInfoEntity>> getServiceDetails(
      {required int serviceId, required int stateId}) async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await exploreServicesDataSource.getServiceDetails(
            serviceId: serviceId, stateId: stateId);
      },
    );
    return data.fold((f) => Left(f), (data) => Right(data));
  }

  @override
  Future<Either<Failure, List<ServiceEntity>>> searchServices({
    int? categoryId,
    required String text,
    String type = '',
    double distance = 0,
  }) async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await exploreServicesDataSource.searchServes(
          categoryId: categoryId,
          text: text,
          type: type,
          distance: distance,
        );
      },
    );
    return data.fold((f) => Left(f), (data) => Right(data));
  }

  @override
  Future<Either<Failure, CreatedRequestResultEntity>> createService(
      {required RequestServiceEntity requestService,
      List<File>? images}) async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        RequestServiceModel requestServiceModel = RequestServiceModel(
            latitude: requestService.latitude,
            longitude: requestService.longitude,
            address: requestService.address,
            serviceType: requestService.serviceType,
            paymentStatus: requestService.paymentStatus,
            distance: requestService.distance,
            stateId: requestService.stateId,
            selectedAttributes: requestService.selectedAttributes,
            images: requestService.images,
            note: requestService.note,
            paymentMethod: requestService.paymentMethod,
            promoCode: requestService.promoCode,
            scheduleDate: requestService.scheduleDate,
            scheduleTime: requestService.scheduleTime);

        return await exploreServicesDataSource.createService(
          requestServiceModel: requestServiceModel,
          images: images,
        );
      },
    );
    return data.fold((f) => Left(f), (data) => Right(data));
  }

  Future<Either<Failure, Unit>> cancelRequest(
      {required int id, required String reason}) async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await exploreServicesDataSource.cancelRequest(
          id: id,
          reason: reason,
        );
      },
    );
    return data.fold((f) => Left(f), (data) => Right(unit));
  }

  @override
  Future<Either<Failure, RequestDetailsEntity>> getRequestDetails(
      {required int id}) async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await exploreServicesDataSource.getRequestDetails(
          id: id,
        );
      },
    );
    return data.fold((f) => Left(f), (data) => Right(data));
  }

  @override
  Future<Either<Failure, int?>> getActive() async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await exploreServicesDataSource.getActive();
      },
    );
    return data.fold((f) => Left(f), (data) => Right(data));
  }

  @override
  Future<Either<Failure, int?>> getPending() async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await exploreServicesDataSource.getPending();
      },
    );
    return data.fold((f) => Left(f), (data) => Right(data));
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await exploreServicesDataSource.getCategories();
      },
    );
    return data.fold((f) => Left(f), (data) => Right(data));
  }

  @override
  Future<
      Either<
          Failure,
          Tuple4<List<ServiceProviderEntity>, List<ServiceProviderEntity>,
              List<ServiceProviderEntity>,int>>> searchServiceProviders(
      {required int state,
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
      List<File>? images}) async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await exploreServicesDataSource.searchServiceProviders(
          state: state,
          lat: lat,
          lng: lng,
          address: address,
          serviceType: serviceType,
          paymentStatus: paymentStatus,
          paymentMethod: paymentMethod,
          distance: distance,
          notes: notes,
          promoCode: promoCode,
          scheduleDate: scheduleDate,
          scheduleTime: scheduleTime,
          images: images,
        selectedAttributes: selectedAttributes
        );
      },
    );
    return data.fold((f) => Left(f), (data) => Right(data));
  }

  @override
  Future<Either<Failure, Unit>> requestBusyProvider({
    required int providerId,
    required int requestId,
    required DateTime scheduleDate,
    required DateTime scheduleTime,
       List<File>? images,
      String? notes
  }) async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await exploreServicesDataSource.requestBusyProvider(
            providerId: providerId,
            requestId: requestId,
            scheduleDate: scheduleDate,
            scheduleTime: scheduleTime,
            images: images,
            notes:notes
            );
      },
    );
    return data.fold((f) => Left(f), (data) => Right(unit));
  }

  @override
  Future<Either<Failure, Unit>> requestOfflineProvider({
    required int providerId,
    required int requestId,
    required DateTime scheduleDate,
    required DateTime scheduleTime,
       List<File>? images,
      String? notes
  }) async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await exploreServicesDataSource.requestOfflineProvider(
            providerId: providerId,
            requestId: requestId,
            scheduleDate: scheduleDate,
            scheduleTime: scheduleTime,
            images: images,
            notes: notes
            );
      },
    );
    return data.fold((f) => Left(f), (data) => Right(unit));
  }

  @override
  Future<Either<Failure, Unit>> requestOnlineProvider({
    required int providerId,
    required int requestId,
    DateTime? scheduleDate,
    DateTime? scheduleTime,
       List<File>? images,
      String? notes
  }) async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await exploreServicesDataSource.requestOnlineProvider(
          providerId: providerId,
          requestId: requestId,
          scheduleDate: scheduleDate,
          scheduleTime: scheduleTime,
          images: images,
          notes: notes
        );
      },
    );
    return data.fold((f) => Left(f), (data) => Right(unit));
  }
    @override
      Future<Either<Failure, Unit>> acceptProviderSechdule({required int providerId, required int requestId,})async{
        final data = await BaseRepo.repoRequest(
      request: () async {
        return await exploreServicesDataSource.acceptProviderSchedule(providerId: providerId, requestId: requestId);
      },
    );
    return data.fold((f) => Left(f), (data) => Right(unit));
    }
}
