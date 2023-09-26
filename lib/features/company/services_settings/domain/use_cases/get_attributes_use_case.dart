// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:masbar/features/company/services_settings/data/model/company_provider_model.dart';
import 'package:masbar/features/company/services_settings/domain/entities/service_attribute_entity.dart';
import 'package:masbar/features/company/services_settings/domain/repositories/services_repo.dart';

import '../../../../../core/errors/failures.dart';


class GetAttributesUseCase {
  final ServicesRepo servicesRepo;
  GetAttributesUseCase({
    required this.servicesRepo,
  });

  Future<Either<Failure, List<ServiceAttributeEntity>>> call({
     required int providerId,
     required int serviceId,
   }) async {
    final data = await servicesRepo.getAttributes(providerId: providerId,serviceId: serviceId);
    return data.fold((f) => Left(f), (attributes) => Right(attributes));
  }
}
