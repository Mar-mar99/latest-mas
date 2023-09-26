// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/errors/failures.dart';
import '../../../../../provider/earning_summary/domain/entities/summary_earnings_provider.dart';
import '../../../../services_settings/domain/entities/company_provider_entity.dart';
import '../../../../services_settings/domain/use_cases/get_providers_use_case.dart';
import '../../../domain/entities/summary_earnings_company.dart';
import '../../../domain/use_cases/get_today_company_summary_use_case.dart';

part 'company_earnings_event.dart';
part 'company_earnings_state.dart';

class CompanyEarningsBloc
    extends Bloc<CompanyEarningsEvent, CompanyEarningsState> {
  final GetTodayCompanyUseCase getTodayCompanyUseCase;
  final GetProvidersUseCase getProvidersUseCase;
  CompanyEarningsBloc({
    required this.getTodayCompanyUseCase,
    required this.getProvidersUseCase,
  }) : super(CompanyEarningsState.empty()) {
    on<GetEarningsDataWithProviders>((event, emit) async {
      emit(
        state.copyWith(
          status: CompanyEarningsStatus.loadingProviders,
        ),
      );
      final providers = await getProvidersUseCase();
      await providers.fold((f) {
        _mapFailureToState(emit, f);
      }, (providers) async {
        final res = await getTodayCompanyUseCase.call(providerId: null);
        await res.fold((f) {
          _mapFailureToState(emit, f);
        }, (data) {
          emit(state.copyWith(
              status: CompanyEarningsStatus.successful,
              data: data,
              providers: providers));
        });
      });
    });

    on<GetEarningsDataWithoutProviders>((event, emit) async {
      emit(
        state.copyWith(
          status: CompanyEarningsStatus.loadingData,
        ),
      );
      final res = await getTodayCompanyUseCase.call(
        providerId: event.providerId,
      );
      await res.fold((f) {
        _mapFailureToState(emit, f);
      }, (data) {
        emit(state.copyWith(
          status: CompanyEarningsStatus.successful,
          data: data,
        ));
      });
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(state.copyWith(
          status: CompanyEarningsStatus.offline,
        ));
        break;

      case NetworkErrorFailure:
        emit(state.copyWith(
            status: CompanyEarningsStatus.error,
            errorMessage: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(state.copyWith(
            status: CompanyEarningsStatus.error, errorMessage: 'ERROR'));

        break;
    }
  }
}
