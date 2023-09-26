import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:masbar/core/utils/services/location_service.dart';
import 'package:masbar/features/user/services/domain/use_cases/get_service_providers_use_case.dart';

import '../../../../../../../core/errors/failures.dart';
import '../../../../../../../core/utils/enums/enums.dart';
import '../../../../domain/entities/service_provider_entity.dart';

part 'search_providers_event.dart';
part 'search_providers_state.dart';

class SearchProvidersBloc
    extends Bloc<SearchProvidersEvent, SearchProvidersState> {
  final GetServiceProvidersUseCase getServiceProvidersUseCase;
  SearchProvidersBloc({required this.getServiceProvidersUseCase})
      : super(SearchProvidersInitial()) {
    on<GetProvidersEvent>((event, emit) async {
      emit(LoadingSearchProviders());
      // GeoLoc? location = await LocationService.getLocationCoords();
      // String address = '';
      // if (location != null) {
      //   address = await LocationService.fetchAddress(location);
      // } else {
      //   emit(const SearchProvidersErrorState(
      //     message: 'Error fetching location',
      //   ));
      //   return;
      // }

      final res = await getServiceProvidersUseCase.call(
        state: event.state,
        lat: event.lat,
        lng: event.lng,
        address: event.address,
        serviceType: event.serviceType,
        paymentStatus: event.paymentStatus,
        paymentMethod: event.paymentMethod,
        distance: event.distance,
        notes: event.notes,
        promoCode: event.promoCode,
        scheduleDate: event.scheduleDate,
        scheduleTime: event.scheduleTime,
        images: event.images,
        selectedAttributes: event.selectedAttributes
      );
      res.fold((failure) {
        _mapFailureToState(emit, failure);
      },
          (data) => emit(
                LoadedSearchProviders(
                  online: data.value1,
                  offline: data.value2,
                  busy: data.value3,
                  requestId: data.value4,
                ),
              ));
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(SearchProvidersOfflineState());
        break;

      case NetworkErrorFailure:
        emit(SearchProvidersErrorState(
            message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(const SearchProvidersErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}
