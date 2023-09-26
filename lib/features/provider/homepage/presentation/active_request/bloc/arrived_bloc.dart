import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/gestures.dart';

import '../../../../../../core/errors/failures.dart';
import '../../../domain/use_cases/arrived_use_case.dart';

part 'arrived_event.dart';
part 'arrived_state.dart';

class ArrivedBloc extends Bloc<ArrivedEvent, ArrivedState> {
  final ArrivedUseCase arrivedUseCase;
  ArrivedBloc({required this.arrivedUseCase}) : super(ArrivedInitial()) {
    on<ArrivedToLocationEvent>((event, emit) async {
      emit(LoadingArrived());

      final res = await arrivedUseCase.call(id: event.id);
      res.fold(
        (failure) {
          _mapFailureToState(emit, failure);
        },
        (data) {
          emit(DoneArrived());
        },
      );
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(ArrivedOfflineState());
        break;

      case NetworkErrorFailure:
        emit(ArrivedErrorState(message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(const ArrivedErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}
