// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/service_entity.dart';
import '../repositories/explore_services_repo.dart';

class GetServicesUseCase {
  final ExploreServicesRepo exploreServicesRepo;
  GetServicesUseCase({
    required this.exploreServicesRepo,
  });

  Future<Either<Failure, List<ServiceEntity>>> call({required int id}) async {
    final res = await exploreServicesRepo.getAllServices(id: id);
    return res.fold((l) => Left(l), (r) => Right(r));
  }
}
