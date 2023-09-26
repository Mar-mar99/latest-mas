// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/category_entity.dart';
import '../repositories/explore_services_repo.dart';

class GetCategoriesUseCase {
  final ExploreServicesRepo exploreServicesRepo;
  GetCategoriesUseCase({
    required this.exploreServicesRepo,
  });
  Future<Either<Failure, List<CategoryEntity>>> call() async {
    final res = await exploreServicesRepo.getCategories();
    return res.fold((l) => Left(l), (r) => Right(r));
  }
}
