import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../../core/errors/failures.dart';
import '../../../../domain/entities/service_info_entity.dart';
import '../../../../domain/use_cases/get_service_info_use_case.dart';

part 'service_details_event.dart';
part 'service_details_state.dart';

class ServiceDetailsBloc
    extends Bloc<ServiceDetailsEvent, ServiceDetailsState> {
  final GetServiceInfoUseCase getServiceInfoUseCase;
  ServiceDetailsBloc({required this.getServiceInfoUseCase})
      : super(ServiceDetailsInitial()) {

    on<FetchInfoEvent>((event, emit) async {
      emit(LoadingServiceDetails());
      final res = await getServiceInfoUseCase.call(
          serviceId: event.serviceId, stateId: event.stateId);
        res.fold((failure) {
        _mapFailureToState(emit, failure);
      },
          (data) => emit(
                LoadedServiceDetails(info: data),
              ));
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(ServiceDetailsOfflineState());
        break;

      case NetworkErrorFailure:
        emit(ServiceDetailsErrorState(message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(const ServiceDetailsErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}
