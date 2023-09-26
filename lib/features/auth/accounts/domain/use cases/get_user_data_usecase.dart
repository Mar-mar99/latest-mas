// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:masbar/core/utils/enums/enums.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repo.dart';

class GetUserDataUseCase {
  final UserRepo userRepo;
  GetUserDataUseCase({
    required this.userRepo,
  });

  Future<Either<Failure, UserEntity>> call({required TypeAuth typeAuth}) async {
    final res = await userRepo.getUserData(typeAuth: typeAuth);

    return await res.fold((l) => Left(l), (userData) => Right(userData));
  }
}
