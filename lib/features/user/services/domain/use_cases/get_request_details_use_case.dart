// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/request_details_entity.dart';
import '../repositories/explore_services_repo.dart';

class GetRequestDetailsUseCase {
 final ExploreServicesRepo exploreServicesRepo;
  GetRequestDetailsUseCase({
    required this.exploreServicesRepo,
  });

   Future<Either<Failure,RequestDetailsEntity>> call({required  int id}) async {
    final res = await exploreServicesRepo.getRequestDetails(id: id);
    return res.fold((l) => Left(l), (r) => Right(r));
  }
}
