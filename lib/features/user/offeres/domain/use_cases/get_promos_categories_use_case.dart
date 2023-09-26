// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/offer_category_entity.dart';
import '../repositories/offers_repo.dart';

class GetPromosCategoriesUseCase {
  final OffersRepo offersRepo;
  GetPromosCategoriesUseCase({
    required this.offersRepo,
  });
  Future<Either<Failure, List<OfferCategoryEntity>>> call() async {
    final res = await offersRepo.getPromosCategories();
    return res.fold((l) => Left(l), (r) => Right(r));
  }
}
