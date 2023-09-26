// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:masbar/core/errors/failures.dart';

import 'package:masbar/features/user/promo_code/domain/use_cases/get_promos_use_case.dart';
import 'package:masbar/features/user/promo_code/presentation/bloc/get_promos_event.dart';

import '../../domain/entities/promo_code_entity.dart';

part 'get_promos_state.dart';

class GetPromosBloc extends Bloc<GetPromosEvent, GetPromosState> {
  final GetPromosUseCase getPromosUseCase;
  GetPromosBloc({
    required this.getPromosUseCase,
  }) : super(GetPromosInitial()) {
    on<GetPromosDataEvent>((event, emit) async {
      emit(LoadingGetPromos());
      final res = await getPromosUseCase();
      res.fold((f) {
        _mapFailureToState(emit, f);
      }, (data) {
        emit(LoadedGetPromos(promos: data));
      });
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(GetPromosOfflineState());
        break;

      case NetworkErrorFailure:
        emit(GetPromosErrorState(message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(GetPromosErrorState(message: (f as NetworkErrorFailure).message));

        break;
    }
  }
}
