// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';

import '../../../auth/accounts/domain/repositories/auth_repo.dart';
import '../entities/document_entity.dart';
import '../repositories/documents_repo.dart';

class GetDocumentsUsecase {
  final DocumentsRepo documentsRepo;
  final AuthRepo authRepo;
  GetDocumentsUsecase({
    required this.documentsRepo,
    required this.authRepo,
  });

  Future<Either<Failure, List<DocumentEntity>>> call() async {
    final res = await documentsRepo.getDocuments(
      token: authRepo.getToken()!,
    );
   return res.fold(
      (f) {
        return Left(f);
      },
      (documents) async {
        return Right(documents);
      },
    );
  }
}
