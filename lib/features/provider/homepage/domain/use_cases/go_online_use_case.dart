import '../../../../../core/utils/services/shared_preferences.dart';
import '../repositories/provider_repo.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';

class GoOnlineUseCase {
  final ProviderRepo providerRepo;
  GoOnlineUseCase({
    required this.providerRepo,
  });
  Future<Either<Failure, Unit>> call({required bool goOnline}) async {
    final res = await providerRepo.goOnlineOrOffline(goOnline: goOnline);

    return res.fold((l) => Left(l), (r) async {
      await PreferenceUtils.setBool(
        "isWorking",
        goOnline
      );
      return Right(r);
    });
  }
}
