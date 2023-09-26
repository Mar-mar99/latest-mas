import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/wallet_entity.dart';


abstract class WalletRepo{
  Future<Either<Failure,List<WalletEntity>>> getWallet();
  Future<Either<Failure,void>> chargeWallet({required String amount, required int cardId});
}
