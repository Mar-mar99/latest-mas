// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/errors/failures.dart';
import '../../../domain/use_cases/start_working_use_case.dart';

part 'start_event.dart';
part 'start_state.dart';

class StartBloc extends Bloc<StartEvent, StartState> {
  final StartWorkingUseCase startWorkingUseCase;
  StartBloc({
    required this.startWorkingUseCase,
  }) : super(StartInitial()) {
    on<StartRequestEvent>((event, emit) async {
      emit(LoadingStart());

      final res = await startWorkingUseCase.call(id: event.id);
      res.fold(
        (failure) {
          _mapFailureToState(emit, failure);
        },
        (data) {
          emit(DoneStart());
        },
      );
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(StartOfflineState());
        break;

      case NetworkErrorFailure:
        emit(StartErrorState(message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(const StartErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}
