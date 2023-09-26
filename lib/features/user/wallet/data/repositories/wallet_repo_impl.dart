
import 'package:masbar/core/errors/failures.dart';

import 'package:dartz/dartz.dart';

import '../../../../../core/api_service/base_repo.dart';
import '../../domain/entities/wallet_entity.dart';
import '../../domain/repositories/wallet_repo.dart';
import '../data_source/wallet_data_source.dart';

class WalletRepoImpl implements WalletRepo {
  final WalletDataSource walletDataSource;
  WalletRepoImpl({
    required this.walletDataSource,
  });

  @override
  Future<Either<Failure, void>> chargeWallet({
    required String amount,
    required int cardId,
  }) async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await walletDataSource.chargeWallet(amount: amount, cardId: cardId);
      },
    );
    return data.fold((f) => Left(f), (data) =>const Right(unit));
  }

  @override
  Future<Either<Failure, List<WalletEntity>>> getWallet() async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await walletDataSource.getWallet();
      },
    );
    return data.fold((f) => Left(f), (data) => Right(data));
  }
}
