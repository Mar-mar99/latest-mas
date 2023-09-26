// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dartz/dartz.dart';

import 'package:masbar/core/errors/failures.dart';
import 'package:masbar/core/network/check_internet.dart';
import 'package:masbar/core/utils/enums/enums.dart';
import 'package:masbar/features/user/promo_code/data/data_source/promo_code_data_source.dart';
import 'package:masbar/features/user/promo_code/domain/entities/promo_code_entity.dart';
import 'package:masbar/features/user/promo_code/domain/repositories/promo_code_repo.dart';
import 'package:masbar/core/api_service/base_repo.dart';

class PromoCodeRepoImpl extends PromoCodeRepo {
  final PromoCodeDataSource promoCodeDataSource;

  PromoCodeRepoImpl({
    required this.promoCodeDataSource,
  });
  @override
  Future<Either<Failure, Unit>> addPromoCode(
      {required String promoCode}) async {
    final data = await BaseRepo.repoRequest(request: () async {
      return await promoCodeDataSource.addPromoCode(promoCode: promoCode);
    });
    return data.fold((f) => Left(f), (_) => const Right(unit));
  }

  @override
  Future<Either<Failure, List<PromoCodeEntity>>> getPromoCode() async {
    final data = await BaseRepo.repoRequest(request: () async {
      return await promoCodeDataSource.getPromoCode();
    });
    return data.fold((f) => Left(f), (r) => Right(r));
  }

}
