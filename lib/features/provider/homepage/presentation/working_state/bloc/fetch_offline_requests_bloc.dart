// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:masbar/features/provider/homepage/domain/entities/offline_request_entity.dart';

import '../../../../../../core/errors/failures.dart';
import '../../../domain/use_cases/fetch_offline_requests_use_case.dart';

part 'fetch_offline_requests_event.dart';
part 'fetch_offline_requests_state.dart';

class FetchOfflineRequestsBloc
    extends Bloc<FetchOfflineRequestsEvent, FetchOfflineRequestsState> {
  final FetchOfflineRequestUseCase fetchOfflineRequestUseCase;
  FetchOfflineRequestsBloc({
    required this.fetchOfflineRequestUseCase,
  }) : super(FetchOfflineRequestsInitial()) {
    on<GetOfflineRequestsEvent>((event, emit) async {
      emit(LoadingFetchOfflineRequests());

      final data = await fetchOfflineRequestUseCase.call();
      data.fold(
        (l) {
           _mapFailureToState(emit, l);
        },
        (r) => emit(
          LoadedFetchOfflineRequests(
            data: r,
          ),
        ),
      );
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(FetchOfflineRequestsOfflineState());
        break;

      case NetworkErrorFailure:
        emit(FetchOfflineRequestsErrorState(
            message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(FetchOfflineRequestsErrorState(message: 'Error'));
        break;
    }
  }
}
