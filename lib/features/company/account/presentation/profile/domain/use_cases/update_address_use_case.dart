// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../../../../core/errors/failures.dart';
import '../../../../../../../core/utils/enums/enums.dart';
import '../../../../../../auth/accounts/domain/repositories/auth_repo.dart';
import '../../../../../../auth/accounts/domain/repositories/user_repo.dart';
import '../repositories/company_profile_repo.dart';

class UpdateAddressUseCase {
  final CompanyProfileRepo companyProfileRepo;
  final UserRepo userRepo;
  final AuthRepo authRepo;
  UpdateAddressUseCase({
    required this.companyProfileRepo,
    required this.userRepo,
    required this.authRepo,
  });
  Future<Either<Failure, Unit>> call(
      {required String address}) async {
    final res = await companyProfileRepo.updateAddress(address: address);
     return await res.fold(
      (l) {
        return Left(l);
      },
      (_) async {
        final dataInfo = await userRepo.getUserData(typeAuth: TypeAuth.company);
        return await dataInfo.fold(
          (l) {
            return Left(l);
          },
          (userEntity) async {
            await authRepo.saveUserData(userEntity);

            return const Right(unit);
          },
        );
      },
    );
  }
}
