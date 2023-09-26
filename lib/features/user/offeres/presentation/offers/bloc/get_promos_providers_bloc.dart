// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/errors/failures.dart';
import '../../../domain/entities/offer_provider_entity.dart';
import '../../../domain/use_cases/get_promos_providers_use_case.dart';

part 'get_promos_providers_event.dart';
part 'get_promos_providers_state.dart';

class GetPromosProvidersBloc extends Bloc<GetPromosProvidersEvent, GetPromosProvidersState> {
  final GetPromosProvidersUseCase getPromosProvidersUseCase;
  GetPromosProvidersBloc({
   required this.getPromosProvidersUseCase,
  }
  ) : super(GetPromosProvidersInitial()) {
    on<LoadProvidersEvent>((event, emit) async{
        emit(LoadingGetPromosProviders());
      final res = await getPromosProvidersUseCase.call(serviceId: event.serviceId,keyword: event.keyword);
      res.fold((f) {
        _mapFailureToState(emit, f);
      }, (data) {
        emit(LoadedGetPromosProviders(data: data));
      });
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(GetPromosProvidersOfflineState());
        break;

      case NetworkErrorFailure:
        emit(GetPromosProvidersErrorState(message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(GetPromosProvidersErrorState(message: (f as NetworkErrorFailure).message));

        break;
    }
  }
}
