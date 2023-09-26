import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../repositories/provider_repo.dart';

class StartWorkingUseCase{
 final ProviderRepo providerRepo;
  StartWorkingUseCase({
    required this.providerRepo,
  });
  Future<Either<Failure, Unit>> call( { required int id,})async{
     final res = await providerRepo.startWorkingOnTheService(id: id);
    return res.fold((l) => Left(l), (r) => Right(unit));


  }
}
