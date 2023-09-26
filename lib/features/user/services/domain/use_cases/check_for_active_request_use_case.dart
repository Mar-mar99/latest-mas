import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../repositories/explore_services_repo.dart';

class CheckForActiveRequestUseCase {
  final ExploreServicesRepo exploreServicesRepo;
  CheckForActiveRequestUseCase({
    required this.exploreServicesRepo,
  });

  Future<Either<Failure, int?>> call() async {
    print('get pending');
    final res1 = await exploreServicesRepo.getPending();

    return await res1.fold(
      (l) => Left(l),
      (r) async {
        if (r != null) {
          return Right(r);
        } else {
          print('get active');
          final res2 = await exploreServicesRepo.getActive();
          return await res2.fold(
            (l) => Left(l),
            (r) {
              if (r != null) {
                return Right(r);
              } else {
                return Right(null);
              }
            },
          );
        }
      },
    );
  }
}
