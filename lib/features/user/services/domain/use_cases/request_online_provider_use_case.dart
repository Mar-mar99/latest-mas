import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../repositories/explore_services_repo.dart';

class RequestOnlineProviderUseCase {
  final ExploreServicesRepo exploreServicesRepo;
  RequestOnlineProviderUseCase({
    required this.exploreServicesRepo,
  });

  Future<Either<Failure, Unit>> call({
    required int providerId,
    required int requestId,
    DateTime? scheduleDate,
    DateTime? scheduleTime,
       List<File>? images,
      String? notes
  }) async {
    final res = await exploreServicesRepo.requestOnlineProvider(
      providerId: providerId,
      requestId: requestId,
      scheduleDate: scheduleDate,
      scheduleTime: scheduleTime,
      images:images,
      notes:notes,
    );
    return res.fold((l) => Left(l), (r) => Right(r));
  }
}
