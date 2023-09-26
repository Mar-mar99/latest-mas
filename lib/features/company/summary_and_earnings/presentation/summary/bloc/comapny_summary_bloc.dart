import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/errors/failures.dart';
import '../../../../services_settings/domain/entities/company_provider_entity.dart';
import '../../../../services_settings/domain/use_cases/get_providers_use_case.dart';
import '../../../domain/entities/summary_earnings_company.dart';
import '../../../domain/use_cases/get_range_summary_company_use_case.dart';

part 'comapny_summary_event.dart';
part 'comapny_summary_state.dart';

class ComapnySummaryBloc
    extends Bloc<ComapnySummaryEvent, ComapnySummaryState> {
  final GetRangeSummaryCompanyUseCase getRangeSummaryCompanyUseCase;
  final GetProvidersUseCase getProvidersUseCase;
  ComapnySummaryBloc({
    required this.getRangeSummaryCompanyUseCase,
    required this.getProvidersUseCase,
  }) : super(ComapnySummaryState.empty()) {
    
    on<GetCompanySummaryDataWithProviders>((event, emit) async {
      emit(
        state.copyWith(
          status: ComapnySummaryStatus.loadingProviders,
        ),
      );
      final providers = await getProvidersUseCase();
      await providers.fold((f) {
        _mapFailureToState(emit, f);
      }, (providers) async {
        final res = await getRangeSummaryCompanyUseCase.call(
          start: event.start,
          end: event.end,
        );
        await res.fold((f) {
          _mapFailureToState(emit, f);
        }, (data) {
          emit(state.copyWith(
              status: ComapnySummaryStatus.successful,
              data: data,
              providers: providers));
        });
      });
    });

    on<GetCompanySummaryDataWithoutProviders>((event, emit) async {
      emit(
        state.copyWith(
          status: ComapnySummaryStatus.loadingData,
        ),
      );
      final res = await getRangeSummaryCompanyUseCase.call(
        start: event.start,
        end: event.end,
        providerId: event.providerId,
      );
      await res.fold((f) {
        _mapFailureToState(emit, f);
      }, (data) {
        emit(state.copyWith(
          status: ComapnySummaryStatus.successful,
          data: data,
        ));
      });
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(state.copyWith(
          status: ComapnySummaryStatus.offline,
        ));
        break;

      case NetworkErrorFailure:
        emit(state.copyWith(
          status: ComapnySummaryStatus.error,
          errorMessage: (f as NetworkErrorFailure).message
        ));
        break;

      default:
        emit(state.copyWith(
          status: ComapnySummaryStatus.error,
          errorMessage: 'ERROR'
        ));

        break;
    }
  }
}
