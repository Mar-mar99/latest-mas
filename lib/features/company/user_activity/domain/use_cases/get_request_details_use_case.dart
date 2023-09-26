// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/requets_detail_entity.dart';
import '../repositories/user_activity_repo.dart';

class GetRequestDetailsUseCase {
  final UserActivityRepo userActivityRepo;
  GetRequestDetailsUseCase({
    required this.userActivityRepo,
  });
   Future<Either<Failure,RequestDetailEntity>> call({required String id})async{
  final res = await userActivityRepo.getRequestDetails(id: id);
    return res.fold((l) => Left(l), (r) => Right(r));
   }

}
