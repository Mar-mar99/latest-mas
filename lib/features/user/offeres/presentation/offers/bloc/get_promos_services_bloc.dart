// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/errors/failures.dart';
import '../../../domain/entities/offer_service_entity.dart';
import '../../../domain/use_cases/get_promos_services_use_case.dart';

part 'get_promos_services_event.dart';
part 'get_promos_services_state.dart';

class GetPromosServicesBloc extends Bloc<GetPromosServicesEvent, GetPromosServicesState> {

  final GetPromosServicesUseCase getPromosServicesUseCase;
  GetPromosServicesBloc({
   required this.getPromosServicesUseCase,
  }
  ) : super(GetPromosServicesInitial()) {
    on<GetServiceEvent>((event, emit)async {
     emit(LoadingGetPromosServices());
      final res = await getPromosServicesUseCase(id: event.id);
      res.fold((f) {
        _mapFailureToState(emit, f);
      }, (data) {
        emit(LoadedGetPromosServices(data: data));
      });
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(GetPromosServicesOfflineState());
        break;

      case NetworkErrorFailure:
        emit(GetPromosServicesErrorState(message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(GetPromosServicesErrorState(message: (f as NetworkErrorFailure).message));

        break;
    }
  }
}
