// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:masbar/core/constants/api_constants.dart';

import '../../../../../core/api_service/base_api_service.dart';
import '../model/review_model.dart';

abstract class ReviewDataSource {
  Future<Tuple2<int,List<ReviewModel>>> getReviews({required int page});
}

class ReviewDataSourceWithHttp extends ReviewDataSource {
  final BaseApiService client;
  ReviewDataSourceWithHttp({
    required this.client,
  });

  @override
  Future<Tuple2<int,List<ReviewModel>>> getReviews({required int page}) async {
    final res = await client.getRequest(
      url: '${ApiConstants.providerProfileReviews}?page=$page',
    );
    List<ReviewModel> reviews = [];
    res['data'].forEach((c) {
      reviews.add(ReviewModel.fromJson(c));
    });
    return Tuple2(res['total'], reviews);
  }
}
