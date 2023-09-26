// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:masbar/core/utils/enums/enums.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/delete_account_repo.dart';

class DeleteAccountUseCase {
  final DeleteAccountRepo deleteAccountRepo;
  DeleteAccountUseCase({
    required this.deleteAccountRepo,
  });
  Future<Either<Failure, Unit>> call({required TypeAuth type}) async {
    final res = await deleteAccountRepo.deleteAccount(typeAuth: type);
    return res.fold((l) => Left(l), (_) => const Right(unit));
  }
}
