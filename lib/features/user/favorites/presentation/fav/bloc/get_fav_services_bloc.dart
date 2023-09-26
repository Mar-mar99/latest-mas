// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/errors/failures.dart';
import '../../../domain/entities/favorite_service_entity.dart';
import '../../../domain/use_cases/get_fav_services_use_case.dart';

part 'get_fav_services_event.dart';
part 'get_fav_services_state.dart';

class GetFavServicesBloc extends Bloc<GetFavServicesEvent, GetFavServicesState> {
 final GetFavServicesUseCase getFavServicesUseCase;
  GetFavServicesBloc({
   required this.getFavServicesUseCase,
  }
  ) : super(GetFavServicesInitial()) {
    on<LoadFavServices>((event, emit) async{
        emit(LoadingGetFavServices());
      final res = await getFavServicesUseCase(id: event.id);
      res.fold((f) {
        _mapFailureToState(emit, f);
      }, (data) {
        emit(LoadedGetFavServices(data: data));
      });
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(GetFavServicesOfflineState());
        break;

      case NetworkErrorFailure:
        emit(GetFavServicesErrorState(message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(GetFavServicesErrorState(message: (f as NetworkErrorFailure).message));

        break;
    }
  }
}
