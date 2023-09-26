// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';

import '../../domain/entities/services_prices_entity.dart';

import '../../domain/use_cases/get_prices_use_case.dart';
import '../../../company_services/domain/use_cases/get_company_services_use_case.dart';

import '../../../company_services/domain/entities/company_service_entity.dart';
part 'get_prices_event.dart';
part 'get_prices_state.dart';

class GetPricesBloc extends Bloc<GetPricesEvent, GetPricesState> {
  final GetCompanyServicesUseCase getCompanyServicesUseCase;
  final GetPricesUseCase getPricesUseCase;
  GetPricesBloc({
    required this.getCompanyServicesUseCase,
    required this.getPricesUseCase,
  }) : super(GetPricesState.empty()) {
    on<GetServicesAndPricesPricesEvent>((event, emit) async {
      emit(state.copyWith(status: GetPricesStatus.loadingForServices));
      final services = await getCompanyServicesUseCase.call();
      await services.fold((f) {
        _mapFailureToState(emit, f);
      }, (servicesData) async {
        final prices = await getPricesUseCase.call(id: servicesData.first.id);
        prices.fold(
          (f) {
            _mapFailureToState(emit, f);
          },
          (pricesData) => emit(
            state.copyWith(
              services: servicesData,
              prices: pricesData,
              selectedService: servicesData.first,
              status: GetPricesStatus.loaded,
            ),
          ),
        );
      });
    });
    on<LoadPricesEvent>((event, emit) async {
      emit(state.copyWith(status: GetPricesStatus.loadingForPrices));

      final prices =
          await getPricesUseCase.call(id: event.companyServiceEntity==null?state.services[0].id:event.companyServiceEntity!.id);
      prices.fold(
        (f) {
          _mapFailureToState(emit, f);
        },
        (pricesData) => emit(
          state.copyWith(
            selectedService: event.companyServiceEntity,
            prices: pricesData,
            status: GetPricesStatus.loaded,
          ),
        ),
      );
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(state.copyWith(status: GetPricesStatus.offline));
        break;

      case NetworkErrorFailure:
        emit(state.copyWith(
            status: GetPricesStatus.error,
            errorMessage: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(state.copyWith(
            status: GetPricesStatus.error, errorMessage: 'error'));
        break;
    }
  }
}
