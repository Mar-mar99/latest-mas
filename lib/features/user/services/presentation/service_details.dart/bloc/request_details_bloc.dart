import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/errors/failures.dart';
import '../../../domain/entities/request_details_entity.dart';
import '../../../domain/use_cases/get_request_details_use_case.dart';

part 'request_details_event.dart';
part 'request_details_state.dart';

class RequestDetailsBloc extends Bloc<RequestDetailsEvent, RequestDetailsState> {
 final GetRequestDetailsUseCase getRequestDetailsUseCase;
  RequestDetailsBloc({required this.getRequestDetailsUseCase}) : super(RequestDetailsInitial()) {
    on<LoadRequestDetails>((event, emit)async {
       emit(LoadingRequestDetails());

      final res = await getRequestDetailsUseCase.call(id: event.id
    );
      res.fold(
        (failure) {
          _mapFailureToState(emit, failure);
        },
        (data) {
          print('done');
          emit(LoadedRequestDetails(data: data));
        },
      );
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(RequestDetailsOfflineState());
        break;

      case NetworkErrorFailure:
        emit(RequestDetailsErrorState(message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(const RequestDetailsErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}

