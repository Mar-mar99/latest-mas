import 'package:dartz/dartz.dart';
import 'package:masbar/features/auth/accounts/domain/repositories/auth_repo.dart';
import '../../../../../core/errors/failures.dart';

import '../repositories/user_repo.dart';

class UserSignupUseCase {
  final UserRepo userRepo;
  final AuthRepo authRepo;

  UserSignupUseCase({
    required this.userRepo,
    required this.authRepo,
  });

  Future<Either<Failure, Unit>> call(
      {required String email,
      required String password,
      required String firstName,
      required String lastName,
      required String phone,
      required int state}) async {
        print('in call $lastName');
    final res = await userRepo.signupUser(
      email: email,
      firstName: firstName,
      lastName: lastName,
      password: password,
      phone: phone,
      state: state,
    );
    return res.fold(
      (f) {
        return Left(f);
      },
      (userEntity) async {
        await authRepo.saveUserData(userEntity);
        await authRepo.saveToken(userEntity.accessToken!);
        return const Right(unit);
      },
    );
  }
}
