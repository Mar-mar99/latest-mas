import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:masbar/core/errors/failures.dart';

import '../../../../../core/utils/enums/enums.dart';
import '../../data/model/promo_code_model.dart';
import '../entities/promo_code_entity.dart';

abstract class PromoCodeRepo {
  Future<Either<Failure,List<PromoCodeEntity>>> getPromoCode();
  Future<Either<Failure,Unit>> addPromoCode({required String promoCode});
 
}
