import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../repositories/explore_services_repo.dart';

class RequestOfflineProviderUseCase {
  final ExploreServicesRepo exploreServicesRepo;
  RequestOfflineProviderUseCase({
    required this.exploreServicesRepo,
  });

  Future<Either<Failure, Unit>> call({
    required int providerId,
    required int requestId,
    required DateTime scheduleDate,
    required DateTime scheduleTime,
       List<File>? images,
      String? notes
  }) async {
    final res = await exploreServicesRepo.requestOfflineProvider(
        providerId: providerId,
        requestId: requestId,
        scheduleDate: scheduleDate,
        scheduleTime: scheduleTime,

        images:images,
        notes:notes
        );
    return res.fold((l) => Left(l), (r) => Right(r));
  }
}
