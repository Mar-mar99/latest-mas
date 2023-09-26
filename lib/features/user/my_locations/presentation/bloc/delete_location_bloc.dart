// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:masbar/features/user/my_locations/domain/use_cases/delete_location_use_case.dart';

import '../../../../../core/errors/failures.dart';

part 'delete_location_event.dart';
part 'delete_location_state.dart';

class DeleteLocationBloc extends Bloc<DeleteLocationEvent, DeleteLocationState> {
  final DeleteLocationsUseCase deleteLocationsUseCase;
  DeleteLocationBloc({
   required this.deleteLocationsUseCase,
  }
  ) : super(DeleteLocationInitial()) {
    on<DeleteEvent>((event, emit)async {
      emit(LoadingDeleteLocation());
      final res = await deleteLocationsUseCase.call(id: event.id);
      res.fold((f) {
        _mapFailureToState(emit, f);
      }, (data) {
        emit(LoadedDeleteLocation());
      });
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(DeleteLocationOfflineState());
        break;

      case NetworkErrorFailure:
        emit(DeleteLocationErrorState(message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(DeleteLocationErrorState(message: (f as NetworkErrorFailure).message));

        break;
    }
  }
}
