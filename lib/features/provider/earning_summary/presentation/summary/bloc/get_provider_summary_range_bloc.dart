import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:masbar/features/provider/earning_summary/domain/use_cases/get_range_summary_provider_use_case.dart';

import '../../../../../../core/errors/failures.dart';
import '../../../domain/entities/summary_earnings_provider.dart';

part 'get_provider_summary_range_event.dart';
part 'get_provider_summary_range_state.dart';

class GetProviderSummaryRangeBloc
    extends Bloc<GetProviderSummaryRangeEvent, GetProviderSummaryRangeState> {
  final GetRangeSummaryProviderUseCase getRangeSummaryProviderUseCase;
  GetProviderSummaryRangeBloc({required this.getRangeSummaryProviderUseCase})
      : super(GetProviderSummaryRangeInitial()) {
    on<GetProviderSummaryRange>((event, emit) async {
      emit(LoadingGetProviderSummaryRange());
      final res = await getRangeSummaryProviderUseCase(
          start: event.start, end: event.end);
      res.fold((f) {
        _mapFailureToState(emit, f);
      }, (data) {
        emit(LoadedGetProviderSummaryRange(data: data));
      });
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(GetProviderSummaryRangeOfflineState());
        break;

      case NetworkErrorFailure:
        emit(GetProviderSummaryRangeErrorState(
            message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(GetProviderSummaryRangeErrorState(
            message: (f as NetworkErrorFailure).message));

        break;
    }
  }
}
