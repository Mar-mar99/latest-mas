import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../data/model/service_attribute_model.dart';

import '../repositories/services_repo.dart';

class SaveAttributesUseCase {
  final ServicesRepo servicesRepo;
  SaveAttributesUseCase({
    required this.servicesRepo,
  });

  Future<Either<Failure, Unit>> call(
      {required  List<Map<String, dynamic>> attributes}) async {
       
    final data = await servicesRepo.saveAttributes(attributes: attributes);
    return data.fold((f) => Left(f), (_) => const Right(unit));
  }
}
