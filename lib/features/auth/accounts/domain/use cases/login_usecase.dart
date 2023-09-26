import 'package:dartz/dartz.dart';
import 'package:masbar/core/utils/enums/enums.dart';

import '../../../../../core/errors/failures.dart';

import '../repositories/auth_repo.dart';
import '../repositories/user_repo.dart';

class LoginUseCase {
  final UserRepo userRepo;
  final AuthRepo authRepo;
  LoginUseCase({required this.userRepo, required this.authRepo});

  Future<Either<Failure, Unit>> call({
    required String email,
    required String password,
    required LoginUserType type,
  }) async {
    final res = await userRepo.loggin(email, password, type);
    return res.fold(
      (f) {
        return Left(f);
      },
      (userEntity) async {
        await authRepo.saveUserData(userEntity);
        print('typeeee ${userEntity.type}');
        await authRepo.saveToken(userEntity.accessToken!);
        return const Right(unit);
      },
    );
  }
}
