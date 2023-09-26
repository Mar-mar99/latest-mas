import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/document_entity.dart';

abstract class DocumentsRepo {
  Future<Either<Failure,List< DocumentEntity>>> getDocuments({required String token});
  Future<Either<Failure, Unit>> uploadDocument({required File file,required String token});
  Future<Either<Failure, Unit>> editDocument(
      {required File file, required int id,required String token});
  Future<Either<Failure, Unit>> deleteDocument({required int id,required String token});
}
