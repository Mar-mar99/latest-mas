import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/service_entity.dart';
import '../entities/service_info_entity.dart';
import '../repositories/explore_services_repo.dart';

class CancelRequestUseCase {
  final ExploreServicesRepo exploreServicesRepo;
  CancelRequestUseCase({
    required this.exploreServicesRepo,
  });

  Future<Either<Failure, Unit>> call({
    required int id,
    required String reason,
  }) async {
    final res = await exploreServicesRepo.cancelRequest(id: id, reason: reason);
    return res.fold((l) => Left(l), (r) => Right(r));
  }
}
