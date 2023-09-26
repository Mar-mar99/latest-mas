// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:masbar/core/errors/failures.dart';
import 'package:masbar/features/user_emirate/domain/entities/uae_state_entity.dart';
import 'package:masbar/features/user_emirate/domain/repositories/uae_state_repo.dart';

class FetchUaeStatesUseCase {
  final UaeStateRepo uaeStatesRepo;
  FetchUaeStatesUseCase({
    required this.uaeStatesRepo,
  });
  Future<Either<Failure, List<UAEStateEntity>>> call() async {
    final res = await uaeStatesRepo.fetchStates();
    return res.fold(
      (f) {
        return Left(f);
      },
      (states) async {
        return Right(states);
      },
    );
  }
}
