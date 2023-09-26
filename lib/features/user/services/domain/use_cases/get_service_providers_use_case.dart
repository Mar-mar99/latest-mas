import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../entities/service_provider_entity.dart';
import '../repositories/explore_services_repo.dart';

class GetServiceProvidersUseCase {
  final ExploreServicesRepo exploreServicesRepo;
  GetServiceProvidersUseCase({
    required this.exploreServicesRepo,
  });

  Future<
      Either<
          Failure,
          Tuple4<List<ServiceProviderEntity>, List<ServiceProviderEntity>,
              List<ServiceProviderEntity>, int>>> call(
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
      Map<int, dynamic>? selectedAttributes,
      List<File>? images}) async {
    List<Tuple2<int, dynamic>>? selectedAttributesTuple = [];
    if (selectedAttributes != null) {
      for (var att in selectedAttributes.keys) {
        selectedAttributesTuple.add(Tuple2(att, selectedAttributes[att]));
      }
    }
    final res = await exploreServicesRepo.searchServiceProviders(
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
        selectedAttributes: selectedAttributesTuple);
    return res.fold((l) => Left(l), (r) => Right(r));
  }
}
