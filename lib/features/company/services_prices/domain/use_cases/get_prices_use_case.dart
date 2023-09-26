// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';

import '../entities/services_prices_entity.dart';
import '../repositories/services_prices_repo.dart';

class GetPricesUseCase {
  final ServicesPricesRepo servicesPricesRepo;
  GetPricesUseCase({
    required this.servicesPricesRepo,
  });

  Future<Either<Failure,List<ServicePriceEntity>>> call({required int id}) async {
    final res = await servicesPricesRepo.getPrices(id: id);
    return res.fold((l) => Left(l), (r) => Right(r));
  }
}
