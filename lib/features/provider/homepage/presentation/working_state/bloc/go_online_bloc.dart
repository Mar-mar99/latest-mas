// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../../domain/use_cases/get_working_status_use_casel.dart';
import '../../../domain/use_cases/go_online_use_case.dart';

import '../../../../../../core/errors/failures.dart';
part 'go_online_event.dart';
part 'go_online_state.dart';

class GoOnlineBloc extends Bloc<GoOnlineEvent, GoOnlineState> {
  final GoOnlineUseCase goOnlineUseCase;
  final GetWorkingStatusUseCase getWorkingStatusUseCase;
  GoOnlineBloc(
      {required this.goOnlineUseCase, required this.getWorkingStatusUseCase})
      : super(GoOnlineState.empty()) {
    on<GetWorkingStatusEvent>((event, emit) async {
      emit(state.copyWith(providerOnlineState: ProviderOnlineState.loading));

      bool status = getWorkingStatusUseCase.call();
      emit(
        state.copyWith(
          providerOnlineState: ProviderOnlineState.successful,
          isOnline: status,
        ),
      );
    });

    on<ChangeOnlineEvent>((event, emit) async {
      emit(state.copyWith(providerOnlineState: ProviderOnlineState.loading));

      final res = await goOnlineUseCase.call(goOnline: !state.isOnline);
      res.fold((failure) {
        _mapFailureToState(emit, failure);
      },
          (data) => emit(state.copyWith(
                providerOnlineState: ProviderOnlineState.successful,
                isOnline: !state.isOnline,
              )));
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(state.copyWith(providerOnlineState: ProviderOnlineState.init));
        break;

      case NetworkErrorFailure:
        emit(state.copyWith(providerOnlineState: ProviderOnlineState.error));
        break;

      default:
        emit(state.copyWith(providerOnlineState: ProviderOnlineState.error));
        break;
    }
  }
}
