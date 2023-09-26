// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../auth/accounts/domain/repositories/auth_repo.dart';
import '../../../../auth/accounts/domain/repositories/user_repo.dart';
import '../repositories/wallet_repo.dart';

class ChargeWalletUseCase {
  final WalletRepo walletRepo;
  final UserRepo userRepo;
  final AuthRepo authRepo;
  ChargeWalletUseCase({
    required this.walletRepo,
    required this.userRepo,
    required this.authRepo,
  });
  Future<Either<Failure, Unit>> call(
      {required String amount, required int cardId}) async {
    final res = await walletRepo.chargeWallet(
      amount: amount,
      cardId: cardId,
    );
    return await res.fold((l) {
      return Left(l);
    }, (r) async {
      final dataInfo = await userRepo.getUserData(typeAuth: TypeAuth.user);
      return await dataInfo.fold(
        (l) {
          return Left(l);
        },
        (userEntity) async {
          await authRepo.saveUserData(userEntity);

          return const Right(unit);
        },
      );
      ;
    });
  }
}
