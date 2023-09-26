import 'package:dartz/dartz.dart';

import '../../../../../../../core/errors/failures.dart';
import '../entities/company_emirates_entity.dart';

abstract class CompanyProfileRepo{
   Future<Either<Failure,List<CompanyEmiratesEntity>>> getCompanyEmirates();
 Future<Either<Failure,Unit>> updateCompanyEmirates(
      {required List<int> states, required int headState});
      Future<Either<Failure,Unit>> updateAddress({required String address});

}
