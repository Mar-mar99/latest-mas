// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/enums/enums.dart';
import '../repositories/edit_password_repo.dart';

class EditPasswordUseCase {
  final EditPasswordRepo editPasswordRepo;
  EditPasswordUseCase({
    required this.editPasswordRepo,
  });

  Future<Either<Failure, Unit>> call({
    required String oldPassword,
    required String password,
    required String passwordConfirmation,
    required TypeAuth typeAuth,
  }) async {
    final res = await editPasswordRepo.updatePassword(
      oldPassword: oldPassword,
      password: password,
      passwordConfirmation: passwordConfirmation,
      typeAuth: typeAuth,
    );
    return res.fold((l) => Left(l), (_) => const Right(unit));
  }
}
