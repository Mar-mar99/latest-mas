import 'package:dartz/dartz.dart';

import 'package:masbar/features/user_emirate/domain/entities/uae_state_entity.dart';

import '../../../../../core/errors/failures.dart';

abstract class UaeStateRepo {
  Future<Either<Failure, List<UAEStateEntity>>> fetchStates();
}
