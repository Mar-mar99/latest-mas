// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../repositories/provider_repo.dart';

class RecieveCashUseCase {
  final ProviderRepo providerRepo;
  RecieveCashUseCase({
    required this.providerRepo,
  });

  Future<Either<Failure, Unit>> call({required int id}) async {
    final res = await providerRepo.recieveCash(id: id);
    return res.fold((l) => Left(l), (r) => Right(unit));
  }
}
