import 'package:dartz/dartz.dart';

import '../../../../../core/api_service/base_repo.dart';
import '../../../../../core/errors/failures.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/repositories/review_repo.dart';
import '../data_source/review_data_source.dart';

class ReviewRepoImpl implements ReviewRepo {
  final ReviewDataSource reviewDataSource;
  ReviewRepoImpl({
    required this.reviewDataSource,
  });

  @override
  Future<Either<Failure, Tuple2<int,List<ReviewEntity>>>> getReviews({required int page})async {
  final data = await BaseRepo.repoRequest(
      request: () async {
        return await reviewDataSource.getReviews(page: page);
      },
    );
    return data.fold((f) => Left(f), (data) => Right(data));
  }
}
