import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/errors/failures.dart';
import '../../../domain/entities/request_provider_entity.dart';
import '../../../domain/use_cases/get_incoming_request_details_use_case.dart';

part 'get_incoming_request_details_event.dart';
part 'get_incoming_request_details_state.dart';

class GetIncomingRequestDetailsBloc extends Bloc<GetRequestDetailsEvent, GetIncomingRequestDetailsState> {
  final GetIncomingRequestDetailsUseCase getRequestDetailsUseCase;
  GetIncomingRequestDetailsBloc({required this.getRequestDetailsUseCase}) : super(GetRequestDetailsInitial()) {
    on<GetDetailsEvent>((event, emit) async{
      emit(LoadingGetRequestDetails());
      final res = await getRequestDetailsUseCase.call(requestId: event.id);
      res.fold((failure) {
        _mapFailureToState(emit, failure);
      },
          (data) => emit(
                LoadedGetRequestDetails(data: data),
              ));
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(GetRequestDetailsOfflineState());
        break;

      case NetworkErrorFailure:
        emit(GetRequestDetailsErrorState(message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(const GetRequestDetailsErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}

