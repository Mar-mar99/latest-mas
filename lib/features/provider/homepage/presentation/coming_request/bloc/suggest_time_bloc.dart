import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/errors/failures.dart';
import '../../../domain/use_cases/suggest_time_use_case.dart';

part 'suggest_time_event.dart';
part 'suggest_time_state.dart';

class SuggestTimeBloc extends Bloc<SuggestTimeEvent, SuggestTimeState> {
  final SuggestTimeUseCase suggestTimeUseCase;
  SuggestTimeBloc({required this.suggestTimeUseCase}) : super(SuggestTimeInitial()) {
    on<SuggestAnotherTimeEvent>((event, emit)async {
    emit(LoadingSuggestTime());
      final res = await suggestTimeUseCase.call(requestId: event.requestId,date:event.date,time:event.time,);
      res.fold(
        (failure) {
          _mapFailureToState(emit, failure);
        },
        (r) => emit(
          LoadedSuggestTime(),
        ),
      );
    });


  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(SuggestTimeOfflineState());
        break;

      case NetworkErrorFailure:
        emit(SuggestTimeErrorState(
            message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(const SuggestTimeErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}
