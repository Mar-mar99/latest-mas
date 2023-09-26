import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:masbar/features/user/services/domain/use_cases/submit_request_use_case.dart';

import '../../../../../../../core/errors/failures.dart';
import '../../../../../../../core/utils/enums/enums.dart';
import '../../../../../../../core/utils/helpers/form_submission_state.dart';
import '../../../../../promo_code/domain/entities/promo_code_entity.dart';
import '../../../../domain/entities/created_request_result_entity.dart';
import '../../../../domain/entities/request_service_entity.dart';

part 'create_request_event.dart';
part 'create_request_state.dart';

class CreateRequestBloc extends Bloc<CreateRequestEvent, CreateRequestState> {
  final SubmitRequestUseCase submitRequestUseCase;
  CreateRequestBloc({required this.submitRequestUseCase})
      : super(CreateRequestState.empty()) {
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
          withPromo: true,
          formSubmissionState: const InitialFormState(),
        ),
      );
      print('the state is ${state.toString()}');
    });
 on<WithPromoChangedEvent>((event, emit) {
      emit(
        state.copyWith(
          withPromo: false,
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
            selectedAttributes: {},
            stateId: state.stateId == 0 ? event.stateId : state.stateId),
      );
      print('the state is ${state.toString()}');
    });

    on<AddAtributeChanged>((event, emit) {
      var attributes = state.selectedAttributes;
      attributes[event.id] = event.value;
      emit(
        state.copyWith(
          selectedAttributes: attributes,
          formSubmissionState: const InitialFormState(),
        ),
      );
      print('the state is ${state.toString()}');
    });

    on<RemoveAtributeChanged>((event, emit) {
      var attributes = state.selectedAttributes;
      attributes.remove(event.id);

      emit(
        state.copyWith(
          selectedAttributes: attributes,
          formSubmissionState: const InitialFormState(),
        ),
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
    on<DistanceChangedEvent>((event, emit) {
      emit(
        state.copyWith(
          distance: event.distance,
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
    on<SubmitRequestEvent>((event, emit) async {
      emit(state.copyWith(
        formSubmissionState: FormSubmittingState(),
      ));
      List<SelectedAttributeEntity> attributes = [];
      for (var key in state.selectedAttributes.keys) {
        attributes.add(
          SelectedAttributeEntity(
            attributeId: key,
            attributeValue: state.selectedAttributes[key],
          ),
        );
      }

      RequestServiceEntity requestServiceEntity = RequestServiceEntity(
        latitude: state.latitude,
        longitude: state.longitude,
        address: state.address,
        serviceType: state.serviceType,
        paymentStatus: state.paymentStatus,
        paymentMethod: state.paymentMethod,
        promoCode: state.promoCode,
        distance: state.distance.round(),
        scheduleTime: state.isSchedule ? state.scheduleTime : null,
        scheduleDate: state.isSchedule ? state.scheduleDate : null,
        stateId: state.stateId,
        note: state.note,
        selectedAttributes: attributes,
      );
      final res = await submitRequestUseCase.call(
        requestService: requestServiceEntity,
        images: state.images.isNotEmpty ? state.images : null,
      );
      print('the state is ${state.toString()}');
      res.fold(
        (failure) {
          _mapFailureToState(emit, failure);
        },
        (data) => emit(
          state.copyWith(
            formSubmissionState: FormSuccesfulState(),
            createdRequestResultEntity: data,
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
