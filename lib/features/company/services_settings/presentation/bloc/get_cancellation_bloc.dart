// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../domain/entities/cancellation_entity.dart';
import '../../domain/use_cases/get_cancellation_use_case.dart';

part 'get_cancellation_event.dart';
part 'get_cancellation_state.dart';

class GetCancellationBloc
    extends Bloc<GetCancellationEvent, GetCancellationState> {
  final GetCancellationUseCase getCancellationUseCase;
  GetCancellationBloc({
    required this.getCancellationUseCase,
  }) : super(GetCancellationInitial()) {
    on<GetCancellationSettings>((event, emit) async {
      emit(LoadingGetCancellation());

      final res1 =
          await getCancellationUseCase.call(serviceId: event.serviceId);
      await res1.fold((f) {
        _mapFailureToState(emit, f);
      }, (data) async {
        emit(LoadedGetCancellation(data: data));
      });
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(GetCancellationOfflineState());
        break;

      case NetworkErrorFailure:
        emit(GetCancellationNetworkErrorState(
            message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(const GetCancellationNetworkErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}
