// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/request_provider_entity.dart';
import '../repositories/provider_repo.dart';

class GetProviderRequestDetailsUseCase {
  final ProviderRepo providerRepo;
  GetProviderRequestDetailsUseCase({
    required this.providerRepo,
  });

  Future<Either<Failure, RequestProviderEntity>> call(
      {required int requestId}) async {
    final res = await providerRepo.getRequestDetails(requestId: requestId);

    return res.fold((l) => Left(l), (r) => Right(r));
  }
}
