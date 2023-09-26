import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:masbar/features/user/services/domain/use_cases/request_busy_provider_use_case.dart';
import 'package:masbar/features/user/services/domain/use_cases/request_offline_provider_use_case.dart';
import 'package:masbar/features/user/services/domain/use_cases/request_online_provider_use_case.dart';

import '../../../../../../../core/errors/failures.dart';
import '../../../../../../../core/utils/enums/enums.dart';
import '../../../../../../../core/utils/helpers/form_submission_state.dart';
import '../../../../../promo_code/domain/entities/promo_code_entity.dart';
import '../../../../domain/entities/created_request_result_entity.dart';

part 'user_create_request_event.dart';
part 'user_create_request_state.dart';

class UserCreateRequestBloc
    extends Bloc<UserCreateRequestEvent, UserCreateRequestState> {
  final RequestBusyProviderUseCase reuquestBusyProviderUseCase;
  final RequestOnlineProviderUseCase reuquestOnlineProviderUseCase;
  final RequestOfflineProviderUseCase requestOfflineProviderUseCase;
  UserCreateRequestBloc(
      {required this.reuquestBusyProviderUseCase,
      required this.reuquestOnlineProviderUseCase,
      required this.requestOfflineProviderUseCase})
      : super(UserCreateRequestState.empty()) {
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
          withPromo: event.withPromo,
          formSubmissionState: const InitialFormState(),
        ),
      );
      print('the state is ${state.toString()}');
    });

    on<StateChangedEvent>((event, emit) {
      emit(
        state.copyWith(
          stateId: event.state,
          stateName: event.stateName,
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
            stateId: state.stateId == 0 ? event.stateId : state.stateId,
            stateName: state.stateId == 0 ? event.stateName : state.stateName),
      );
      print('the state is ${state.toString()}');
    });
    on<ProviderTypeChangedEvent>((event, emit) {
      emit(
        state.copyWith(
            providerStatus: event.providerStatus,
            isSchedule: (event.providerStatus == ProviderStatus.offline ||
                event.providerStatus == ProviderStatus.busy)),
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

    on<ProviderIdChangedEvent>((event, emit) {
      emit(
        state.copyWith(
          selectedProviderId: event.id,
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
    on<RequestIdChangedEvent>((event, emit) {
      emit(
        state.copyWith(
          requestId: event.id,
          formSubmissionState: const InitialFormState(),
        ),
      );
      print('the state is ${state.toString()}');
    });
    on<RequestOnlineProviderEvent>((event, emit) async {
      emit(
        state.copyWith(
          formSubmissionState: FormSubmittingState(),
        ),
      );
      final res = await reuquestOnlineProviderUseCase.call(
        providerId: state.selectedProviderId,
        requestId: state.requestId,
        scheduleDate: state.scheduleDate,
        scheduleTime: state.scheduleTime,
        images: state.images,
        notes: state.note,
      );
      print('the state is ${state.toString()}');
      res.fold(
        (failure) {
          _mapFailureToState(emit, failure);
        },
        (data) => emit(
          state.copyWith(
            formSubmissionState: FormSuccesfulState(),
          ),
        ),
      );
    });
    on<RequestOfflineProviderEvent>((event, emit) async {
      emit(
        state.copyWith(
          formSubmissionState: FormSubmittingState(),
        ),
      );
      final res = await requestOfflineProviderUseCase.call(
        providerId: state.selectedProviderId,
        requestId: state.requestId,
        scheduleDate: state.scheduleDate!,
        scheduleTime: state.scheduleTime!,
        images: state.images,
        notes: state.note,
      );
      print('the state is ${state.toString()}');
      res.fold(
        (failure) {
          _mapFailureToState(emit, failure);
        },
        (data) => emit(
          state.copyWith(
            formSubmissionState: FormSuccesfulState(),
          ),
        ),
      );
    });
    on<RequestBusyProviderEvent>((event, emit) async {
      emit(
        state.copyWith(
          formSubmissionState: FormSubmittingState(),
        ),
      );
      final res = await reuquestBusyProviderUseCase.call(
        providerId: state.selectedProviderId,
        requestId: state.requestId,
        scheduleDate: state.scheduleDate!,
        scheduleTime: state.scheduleTime!,
        images: state.images,
        notes: state.note,
      );
      print('the state is ${state.toString()}');
      res.fold(
        (failure) {
          _mapFailureToState(emit, failure);
        },
        (data) => emit(
          state.copyWith(
            formSubmissionState: FormSuccesfulState(),
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
