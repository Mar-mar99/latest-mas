// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/offer_category_entity.dart';
import '../entities/offer_provider_entity.dart';
import '../repositories/offers_repo.dart';

class GetPromosProvidersUseCase {
  final OffersRepo offersRepo;
  GetPromosProvidersUseCase({
    required this.offersRepo,
  });
  Future<Either<Failure, List<OfferProviderEntity>>> call(  {required int serviceId, required String keyword}) async {
    final res = await offersRepo.getPromosProviders(serviceId: serviceId, keyword: keyword);
    return res.fold((l) => Left(l), (r) => Right(r));
  }
}
