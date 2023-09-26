// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';

import '../../../auth/accounts/domain/repositories/auth_repo.dart';
import '../repositories/documents_repo.dart';

class DeleteDocumentUsecase {
  final DocumentsRepo documentsRepo;
  final AuthRepo authRepo;
  DeleteDocumentUsecase({
    required this.documentsRepo,
    required this.authRepo,
  });

  Future<Either<Failure, Unit>> call({required int id}) async {
    final res =
        await documentsRepo.deleteDocument(token: authRepo.getToken()!, id: id);
    return res.fold(
      (f) {
        return Left(f);
      },
      (_) async {
        return const Right(unit);
      },
    );
  }
}
