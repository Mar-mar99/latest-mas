// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/utils/services/shared_preferences.dart';
import '../entities/request_provider_entity.dart';
import '../repositories/provider_repo.dart';

class GetIncomingRequestDetailsUseCase {
  final ProviderRepo providerRepo;
  GetIncomingRequestDetailsUseCase({
    required this.providerRepo,
  });

  Future<Either<Failure, RequestProviderEntity>> call(
      {required int requestId}) async {
    final res = await providerRepo.getIncomingRequestDetails(requestId: requestId);

    return res.fold((l) => Left(l), (r) => Right(r));
  }
}
