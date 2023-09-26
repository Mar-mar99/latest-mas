// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:masbar/features/company/services_settings/domain/use_cases/get_attributes_use_case.dart';

import '../../../../../core/errors/failures.dart';
import '../../../company_services/domain/entities/company_service_entity.dart';
import '../../domain/entities/company_provider_entity.dart';

import '../../domain/entities/service_attribute_entity.dart';

part 'get_attributes_event.dart';
part 'get_attributes_state.dart';

class GetAttributesBloc extends Bloc<GetAttributesEvent, GetAttributesState> {
  final GetAttributesUseCase getAttributesUseCase;
  GetAttributesBloc({
    required this.getAttributesUseCase,

  }) : super((GetAttributesState.empty())) {
    // on<ServiceIdChangedEvent>(((event, emit) async {
    //   emit(state.copyWith(service: event.service));

    //   await _getAttributes(emit);
    // }));

    on<ProviderIdChangedEvent>(((event, emit) async {
      emit(state.copyWith(provider: event.provider,service: event.service,));

      await _getAttributes(emit);
    }));
  }

  Future<void> _getAttributes(Emitter<GetAttributesState> emit) async {
    emit(state.copyWith(attributesStates: AttributesStates.loading));
    if (state.service == CompanyServiceEntity.empty() || state.provider == CompanyProviderEntity.empty() ) {
      emit(
        state.copyWith(
          attributesStates: AttributesStates.init,
        ),
      );
    }
    else {
      final res1 = await getAttributesUseCase.call(
        providerId: state.provider.id,
        serviceId: state.service.id,
      );
      await res1.fold((f) {
        _mapFailureToState(emit, f);
      }, (attributes) async {
        emit(
          state.copyWith(
            attributes: attributes,
            attributesStates: AttributesStates.loaded,
          ),
        );
      });
    }
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(state.copyWith(
          attributesStates: AttributesStates.offline,
        ));
        break;

      case NetworkErrorFailure:
        emit(state.copyWith(
          attributesStates: AttributesStates.error,
        ));
        break;

      default:
        emit(state.copyWith(
          attributesStates: AttributesStates.error,
        ));
        break;
    }
  }
}
