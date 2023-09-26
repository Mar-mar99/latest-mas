import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/errors/failures.dart';
import '../../../../../../core/utils/enums/enums.dart';
import '../../../../../../core/utils/helpers/form_submission_state.dart';
import '../../../domain/use_cases/create_request_promo_use_case.dart';

part 'request_offer_event.dart';
part 'request_offer_state.dart';

class RequestOfferBloc extends Bloc<RequestOfferEvent, RequestOfferState> {
 final CreateRequestPromoUseCase createRequestPromoUseCase;
  RequestOfferBloc({
    required this.createRequestPromoUseCase
  }) : super(RequestOfferState.empty()) {
     on<PaymentTypeChangedEvent>((event, emit) {
      emit(
        state.copyWith(
          paymentMethod: event.paymentMethod,
          formSubmissionState: const InitialFormState(),
        ),
      );
      print('the state is ${state.toString()}');
    });
    on<PromoCodeChangedEvent>((event, emit) {
      emit(
        state.copyWith(
          promoCode: event.promoCode,
          formSubmissionState: const InitialFormState(),
        ),
      );
      print('the state is ${state.toString()}');
    });
    on<DistanceChangedEvent>((event, emit) {
      emit(
        state.copyWith(
          distance: event.distance,
          formSubmissionState: const InitialFormState(),
        ),
      );
      print('the state is ${state.toString()}');
    });

    on<StateChangedEvent>((event, emit) {
      emit(
        state.copyWith(
          stateId: event.state,
          formSubmissionState: const InitialFormState(),
        ),
      );
      print('the state is ${state.toString()}');
    });

    on<RefreshDataEvent>((event, emit) {
      emit(
        state.copyWith(
            paymentStatus: event.servicePaymentType,
            serviceType: event.serviceId,
            paymentMethod: null,
            promoCode: null,
            stateId: state.stateId == 0 ? event.stateId : state.stateId),
      );
      print('the state is ${state.toString()}');
    });

    on<AddImageChanged>((event, emit) {
      emit(
        state.copyWith(
          images: List.of(state.images)..add(event.image),
          formSubmissionState: const InitialFormState(),
        ),
      );
      print('the state is ${state.toString()}');
    });

    on<RemoveImageChanged>((event, emit) {
      emit(
        state.copyWith(
          images: List.of(state.images)..remove(event.image),
          formSubmissionState: const InitialFormState(),
        ),
      );
      print('the state is ${state.toString()}');
    });

    on<IsScheduleChangedEvent>((event, emit) {
      emit(
        state.copyWith(
          isSchedule: !state.isSchedule,
          formSubmissionState: const InitialFormState(),
        ),
      );
      print('the state is ${state.toString()}');
    });

    on<DateChangedEvent>((event, emit) {
      emit(
        state.copyWith(
          scheduleDate: event.date,
          scheduleTime: event.date,
          formSubmissionState: const InitialFormState(),
        ),
      );
      print('the state is ${state.toString()}');
    });

    on<CoordsChangedEvent>((event, emit) {
      emit(
        state.copyWith(
          latitude: event.lat,
          longitude: event.lng,
          formSubmissionState: const InitialFormState(),
        ),
      );
      print('the state is ${state.toString()}');
    });
    on<AddressChangedEvent>((event, emit) {
      emit(
        state.copyWith(
          address: event.address,
          formSubmissionState: const InitialFormState(),
        ),
      );
      print('the state is ${state.toString()}');
    });
    on<NoteChangedEvent>((event, emit) {
      emit(
        state.copyWith(
          note: event.note,
          formSubmissionState: const InitialFormState(),
        ),
      );
      print('the state is ${state.toString()}');
    });
    on<ProviderIdChangedEvent>((event, emit) {
      emit(
        state.copyWith(
          providerId: event.id,
          formSubmissionState: const InitialFormState(),
        ),
      );
      print('the state is ${state.toString()}');
    });
    on<SubmitRequestEvent>((event, emit) async {
      emit(state.copyWith(
        formSubmissionState: FormSubmittingState(),
      ));

      final res = await createRequestPromoUseCase.call(
        lat: state.latitude,
        lng: state.longitude,
        address: state.address,
        serviceType: state.serviceType,
        distance: state.distance.round(),
        paymentStatus: state.paymentStatus,
        paymentMethod: state.paymentStatus == ServicePaymentType.free
            ? null
            : state.paymentMethod!,
        promoCode:state.promoCode,
        scheduleTime: state.isSchedule ? state.scheduleTime : null,
        scheduleDate: state.isSchedule ? state.scheduleDate : null,
        state: state.stateId,
        notes: state.note,
        images: state.images.isNotEmpty ? state.images : null,
        providerId: state.providerId,
      );
      print('the state is ${state.toString()}');
      res.fold(
        (failure) {
          _mapFailureToState(emit, failure);
        },
        (data) => emit(
          state.copyWith(
            formSubmissionState: FormSuccesfulState(),
            requestId: data,
          ),
        ),
      );
    });
  }
  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(state.copyWith(formSubmissionState: FormNoInternetState()));
        break;

      case NetworkErrorFailure:
        emit(state.copyWith(
            formSubmissionState: FormNetworkErrorState(
                message: (f as NetworkErrorFailure).message)));
        break;

      default:
        emit(state.copyWith(
            formSubmissionState:
                const FormNetworkErrorState(message: 'error')));

        break;
    }
  }
}

