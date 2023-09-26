// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';

import '../entities/wallet_entity.dart';
import '../repositories/wallet_repo.dart';

class GetWalletUseCase {
  final WalletRepo walletRepo;
  GetWalletUseCase({
    required this.walletRepo,
  });
 Future<Either<Failure,List<WalletEntity>>>  call()async{
 final res = await walletRepo.getWallet();
    return res.fold((l) => Left(l), (r) => Right(r));
 }

}
