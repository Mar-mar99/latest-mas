import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/company_service_entity.dart';


abstract class CompanyServicesRepo{
  Future<Either<Failure, List<CompanyServiceEntity>>> getCompanyServices();

}
