// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../domain/entities/company_provider_entity.dart';
import '../../domain/use_cases/get_providers_use_case.dart';
import '../../domain/use_cases/get_service_assigned_providers.dart';

part 'get_assigned_providers_event.dart';
part 'get_assigned_providers_state.dart';

class GetAssignedProvidersBloc
    extends Bloc<GetAssignedProvidersEvent, GetAssignedProvidersState> {
  final GetProvidersUseCase getProvidersUseCase;
  final GetServiceAssignedProviderUseCase getServiceAssignedProviderUseCase;
  GetAssignedProvidersBloc({
    required this.getProvidersUseCase,
    required this.getServiceAssignedProviderUseCase,
  }) : super(GetAssignedProvidersInitial()) {
    on<GetAssignedProvidersAndAllProviders>((event, emit) async {
      emit(LoadingGetAssignedProvidersInfoState());

      final allProviders = await getProvidersUseCase.call();
      await allProviders.fold((f) {
        _mapFailureToState(emit, f);
      }, (providers) async {
        final assignedProviders = await getServiceAssignedProviderUseCase.call(
            serviceId: event.serviceId);
        assignedProviders.fold((f) {
          _mapFailureToState(emit, f);
        }, (aasigned) {
          emit(LoadedGetAssignedProvidersInfoState(
              allProviders: providers, assignedProviders: aasigned));
        });
      });
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(GetAssignedProvidersInfoOfflineState());
        break;

      case NetworkErrorFailure:
        emit(GetAssignedProvidersNetworkErrorState(
            message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(const GetAssignedProvidersNetworkErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}
