// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/review_entity.dart';
import '../repositories/review_repo.dart';

class GetReviewUseCase {
  final ReviewRepo reviewRepo;
  GetReviewUseCase({
    required this.reviewRepo,
  });

  Future<Either<Failure,Tuple2<int, List<ReviewEntity>>>> call({required int page}) async {
    final res = await reviewRepo.getReviews(
      page: page,
    );
   return res.fold((l) => Left(l), (r) => Right(r));
  }
}
