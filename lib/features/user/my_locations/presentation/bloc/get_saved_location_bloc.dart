
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/failures.dart';
import '../../domain/entities/my_location_entity.dart';
import '../../domain/use_cases/get_saved_locations_use_case.dart';

part 'get_saved_location_event.dart';
part 'get_saved_location_state.dart';

class GetSavedLocationBloc extends Bloc<GetSavedLocationEvent, GetSavedLocationState> {
  final GetSavedLocationsUseCase getSavedLocationsUseCase;
  GetSavedLocationBloc({
   required this.getSavedLocationsUseCase,
  }
  ) : super(GetSavedLocationInitial()) {
    on<GetLocations>((event, emit) async{
     emit(LoadingGetSavedLocation());
      final res = await getSavedLocationsUseCase();
      res.fold((f) {
        _mapFailureToState(emit, f);
      }, (data) {
        emit(LoadedGetSavedLocation(data: data));
      });
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(GetSavedLocationOfflineState());
        break;

      case NetworkErrorFailure:
        emit(GetSavedLocationErrorState(message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(GetSavedLocationErrorState(message: (f as NetworkErrorFailure).message));

        break;
    }
  }
}
