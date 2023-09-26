import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/invoice_entity.dart';
import '../repositories/provider_repo.dart';

class FinishWorkingUseCase {
  final ProviderRepo providerRepo;
  FinishWorkingUseCase({
    required this.providerRepo,
  });
  Future<Either<Failure, InvoiceEntity>> call({
    required int requestId,
    List<File>? images,
    String? comment,
  }) async {
    final res = await providerRepo.finishWorkingOnTheService(
      requestId: requestId,
      comment: comment,
      images: images,
    );
    return res.fold((l) => Left(l), (r) => Right(r));
  }
}
