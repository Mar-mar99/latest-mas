// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:masbar/features/company/manage_providers/domain/entities/provider_info_entity.dart';
import 'package:masbar/features/company/manage_providers/domain/repositories/manage_provider_repo.dart';
import 'package:masbar/features/company/manage_providers/presentation/screens/manage_providers_screen.dart';

import '../../../../../core/errors/failures.dart';

class GetProviderInfoUseCase {
  final ManageProviderRepo manageProviderRepo;
  GetProviderInfoUseCase({
    required this.manageProviderRepo,
  });

  Future<Either<Failure, ProviderInfoEntity>> call() async {
    final res = await manageProviderRepo.getProvidersInfo();
    return res.fold((l) => Left(l), (info) => Right(info));
  }
}
