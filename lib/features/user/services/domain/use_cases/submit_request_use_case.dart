// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:masbar/features/user/services/domain/repositories/explore_services_repo.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/utils/services/shared_preferences.dart';
import '../entities/created_request_result_entity.dart';
import '../entities/request_service_entity.dart';

class SubmitRequestUseCase {
  final ExploreServicesRepo exploreServicesRepo;
  SubmitRequestUseCase({
    required this.exploreServicesRepo,
  });
  Future<Either<Failure, CreatedRequestResultEntity>> call({
    required RequestServiceEntity requestService,
    List<File>? images,
  }) async {
    final res = await exploreServicesRepo.createService(
      requestService: requestService,
      images: images,
    );
    return await res.fold((f) => Left(f), (data) async {
      await PreferenceUtils.setInt("requestId", data.requestId);
      return Right(data);
    });
  }
}
