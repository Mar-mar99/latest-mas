import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/use_cases/check_for_active_request_use_case.dart';

part 'check_for_service_event.dart';
part 'check_for_service_state.dart';

class CheckForServiceBloc
    extends Bloc<CheckForServiceEvent, CheckForServiceState> {
  final CheckForActiveRequestUseCase checkForActiveRequestUseCase;

  CheckForServiceBloc({required this.checkForActiveRequestUseCase})
      : super(CheckForServiceInitial()) {
    on<CheckEvent>((event, emit) async {
      emit(LoadingCheckServiceState());
      final res = await checkForActiveRequestUseCase();
      res.fold((l) {
        emit(NoActiveServiceState());
      }, (requestId) {
        if (requestId == null) {
          emit(NoActiveServiceState());
        } else {
          emit(ActiveServiceState(id: requestId));
        }
      });
    });
  }
}
