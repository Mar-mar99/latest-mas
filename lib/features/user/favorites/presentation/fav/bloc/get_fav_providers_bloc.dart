// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/errors/failures.dart';
import '../../../domain/entities/favorite_provider_entity.dart';
import '../../../domain/use_cases/get_fav_list_use_case.dart';

part 'get_fav_providers_event.dart';
part 'get_fav_providers_state.dart';

class GetFavProvidersBloc extends Bloc<GetFavProvidersEvent, GetFavProvidersState> {
 final GetFavListUseCase getFavListUseCase;
  GetFavProvidersBloc({
   required this.getFavListUseCase,
  }
  ) : super(GetFavProvidersInitial()) {
    on<LoadFavProvidersEvent>((event, emit)async {
     emit(LoadingGetFavProviders());
      final res = await getFavListUseCase(serviceId: event.serviceId,);
      res.fold((f) {
        _mapFailureToState(emit, f);
      }, (data) {
        emit(LoadedGetFavProviders(data: data));
      });
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(GetFavProvidersOfflineState());
        break;

      case NetworkErrorFailure:
        emit(GetFavProvidersErrorState(message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(GetFavProvidersErrorState(message: (f as NetworkErrorFailure).message));

        break;
    }
  }
}
