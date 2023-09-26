// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../../core/api_service/base_repo.dart';
import '../../../../../core/errors/failures.dart';
import '../../data/data_source/review_data_source.dart';
import '../../data/model/review_model.dart';
import '../entities/review_entity.dart';

abstract class ReviewRepo {
  Future<Either<Failure,Tuple2<int,List<ReviewEntity>>>> getReviews({required int page});
}
