import '../repositories/explore_services_repo.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/service_entity.dart';

class SerachServicesUseCase {
  final ExploreServicesRepo exploreServicesRepo;
  SerachServicesUseCase({
    required this.exploreServicesRepo,
  });

  Future<Either<Failure, List<ServiceEntity>>> call({
    int? categoryId,
    required String text,
    String type = '',
    double distance = 0,
  }) async {
    final res = await exploreServicesRepo.searchServices(
      categoryId: categoryId,
      text: text,
      distance: distance,
      type: type,
    );
    return res.fold((l) => Left(l), (r) => Right(r));
  }
}
