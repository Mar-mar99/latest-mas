import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/errors/failures.dart';
import '../../../domain/entities/summary_earnings_provider.dart';
import '../../../domain/use_cases/get_today_provider_summary_use_case.dart';

part 'get_provider_summary_today_event.dart';
part 'get_provider_summary_today_state.dart';

class GetProviderSummaryTodayBloc
    extends Bloc<GetProviderSummaryTodayEvent, GetProviderSummaryTodayState> {
  final GetTodayProviderUseCase getTodayProviderUseCase;
  GetProviderSummaryTodayBloc({required this.getTodayProviderUseCase})
      : super(GetProviderSummaryTodayInitial()) {
    on<GetProviderTodaySummary>((event, emit) async {
      emit(LoadingGetProviderSummaryToady());
      final res = await getTodayProviderUseCase();
      res.fold((f) {
        _mapFailureToState(emit, f);
      }, (data) {
        emit(LoadedGetProviderSummaryToady(data: data));
      });
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(GetProviderSummaryToadyOfflineState());
        break;

      case NetworkErrorFailure:
        emit(GetProviderSummaryToadyErrorState(
            message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(GetProviderSummaryToadyErrorState(
            message: (f as NetworkErrorFailure).message));

        break;
    }
  }
}
