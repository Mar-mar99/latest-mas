// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/expert_activity_entity.dart';
import '../repositories/user_activity_repo.dart';

class GetExpertsActivityUseCase {
  final UserActivityRepo userActivityRepo;
  GetExpertsActivityUseCase({
    required this.userActivityRepo,
  });
  Future<Either<Failure,  Tuple2<int, List<UserActivityEntity>>>> call({int page = 1}) async {
    final res = await userActivityRepo.getExpertsActivity(page: page);
    return res.fold((l) => Left(l), (r) => Right(r));
  }
}
