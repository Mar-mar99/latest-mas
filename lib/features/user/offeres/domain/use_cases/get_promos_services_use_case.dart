import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/offer_service_entity.dart';
import '../repositories/offers_repo.dart';

class GetPromosServicesUseCase{
    final OffersRepo offersRepo;
  GetPromosServicesUseCase({
    required this.offersRepo,
  });
  Future<Either<Failure, List<OfferServiceEntity>>> call({required int id}) async {
    final res = await offersRepo.getPromosServices(id: id);
    return res.fold((l) => Left(l), (r) => Right(r));
  }
}
