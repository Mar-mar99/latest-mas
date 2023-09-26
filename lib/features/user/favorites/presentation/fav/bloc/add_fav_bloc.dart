// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/errors/failures.dart';
import '../../../domain/use_cases/save_fav_use_case.dart';

part 'add_fav_event.dart';
part 'add_fav_state.dart';

class AddFavBloc extends Bloc<AddFavEvent, AddFavState> {
  final SaveFavServicesUseCase saveFavServicesUseCase;
  AddFavBloc({
   required this.saveFavServicesUseCase,
  }
  ) : super(AddFavInitial()) {
   on<AddFavProvider>((event, emit) async{
        emit(LoadingAddFav());
      final res = await saveFavServicesUseCase.call(providerId: event.providerId);
      res.fold((f) {
        _mapFailureToState(emit, f);
      }, (data) {
        emit(LoadedAddFav());
      });
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(AddFavOfflineState());
        break;

      case NetworkErrorFailure:
        emit(AddFavErrorState(message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(AddFavErrorState(message: (f as NetworkErrorFailure).message));

        break;
    }
  }
}
