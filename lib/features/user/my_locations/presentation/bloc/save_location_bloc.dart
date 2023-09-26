// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../data/model/my_locations_model.dart';
import '../../domain/use_cases/save_location_use_case.dart';

part 'save_location_event.dart';
part 'save_location_state.dart';

class SaveLocationBloc extends Bloc<SaveLocationEvent, SaveLocationState> {
  final SaveLocationUseCase saveLocationUseCase;
  SaveLocationBloc({
   required this.saveLocationUseCase,
  }
  ) : super(SaveLocationInitial()) {
    on<SaveLocation>((event, emit)async {
     emit(LoadingSaveLocation());
      final res = await saveLocationUseCase.call(newLocation: event.myLocationsModel);
      res.fold((f) {
        _mapFailureToState(emit, f);
      }, (data) {
        emit(LoadedSaveLocation());
      });
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(SaveLocationOfflineState());
        break;

      case NetworkErrorFailure:
        emit(SaveLocationErrorState(message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(SaveLocationErrorState(message: (f as NetworkErrorFailure).message));

        break;
    }
  }
}
