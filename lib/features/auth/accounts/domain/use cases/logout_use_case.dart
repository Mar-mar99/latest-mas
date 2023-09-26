// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../repositories/user_repo.dart';

class LogOutUseCase {
  final UserRepo userRepo;
  LogOutUseCase({
    required this.userRepo,
  });

  Future<Either<Failure, Unit>> call({required TypeAuth typeAuth}) async {
    final res = await userRepo.logOut(typeAuth: typeAuth);
    return res.fold((l) => Left(l), (r) => right(r));
  }
}
