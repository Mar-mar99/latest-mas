import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../../core/errors/failures.dart';
import '../../../domain/entities/requets_detail_entity.dart';
import '../../../domain/use_cases/get_request_details_use_case.dart';

part 'get_request_details_event.dart';
part 'get_request_details_state.dart';

class GetRequestDetailsBloc
    extends Bloc<GetRequestDetailsEvent, GetRequestDetailsState> {
  final GetRequestDetailsUseCase getRequestDetailsUseCase;
  GetRequestDetailsBloc({required this.getRequestDetailsUseCase})
      : super(GetRequestDetailsInitial()) {
    on<GetDetailsEvent>((event, emit) async {
      emit(LoadingGetRequestDetails());
      final res = await getRequestDetailsUseCase.call(id: event.id);
      res.fold(
        (failure) {
          _mapFailureToState(emit, failure);
        },
        (data) {
          emit(DoneGetRequestDetails(data: data));
        },
      );
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(GetRequestDetailsOfflineState());
        break;

      case NetworkErrorFailure:
        emit(GetRequestDetailsErrorState(
            message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(const GetRequestDetailsErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}
