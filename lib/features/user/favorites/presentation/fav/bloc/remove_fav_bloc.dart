// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/errors/failures.dart';
import '../../../domain/use_cases/delete_fav_use_case.dart';

part 'remove_fav_event.dart';
part 'remove_fav_state.dart';

class RemoveFavBloc extends Bloc<RemoveFavEvent, RemoveFavState> {
  final DeleteFavServicesUseCase deleteFavServicesUseCase;
  RemoveFavBloc({
   required this.deleteFavServicesUseCase,
  }
  ) : super(RemoveFavInitial()) {
    on<RemoveFavProvider>((event, emit)async {
      emit(LoadingRemoveFav());
      final res = await deleteFavServicesUseCase.call(providerId: event.providerId);
      res.fold((f) {
        _mapFailureToState(emit, f);
      }, (data) {
        emit(LoadedRemoveFav());
      });
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(RemoveFavOfflineState());
        break;

      case NetworkErrorFailure:
        emit(RemoveFavErrorState(message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(RemoveFavErrorState(message: (f as NetworkErrorFailure).message));

        break;
    }
  }
}
