// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/errors/failures.dart';
import '../../../../services_settings/domain/entities/company_provider_entity.dart';
import '../../../../services_settings/domain/use_cases/get_providers_use_case.dart';
import '../../../domain/entities/service_history_entity.dart';
import '../../../domain/use_cases/get_past_past_use_case.dart';

part 'past_history_event.dart';
part 'past_history_state.dart';

class PastHistoryBloc extends Bloc<PastHistoryEvent, PastHistoryState> {
  final GetExpertPastUseCase getExpertPastUseCase;
  final GetProvidersUseCase getProvidersUseCase;
  PastHistoryBloc(
      {required this.getExpertPastUseCase, required this.getProvidersUseCase})
      : super(PastHistoryState(from: DateTime.now(), to: DateTime.now())) {
    on<LoadFirstTimePastRequestsEvent>((event, emit) async {
      final providers = await getProvidersUseCase();
      await providers.fold((failure) {
        _mapFailureToState(failure, emit);
        return;
      }, (providers) async {
        final data = await getExpertPastUseCase(
          page: state.pageNumber,
          fromDate: state.from,
          toDate: state.to,
          providerId: state.providerId,
        );
        await data.fold(
          (failure) {
            _mapFailureToState(failure, emit);
            return;
          },
          (data) {
            data.isEmpty
                ? emit(
                    state.copyWith(
                      status: PastRequestsStatus.success,
                      providers: providers,
                      hasReachedMax: true,
                    ),
                  )
                : emit(
                    state.copyWith(
                      status: PastRequestsStatus.success,
                      data: data,
                      pageNumber: state.pageNumber + 1,
                      providers: providers,
                      hasReachedMax: false,
                    ),
                  );
          },
        );
      });
    }, transformer: droppable());

    on<DateOrProviderChangedEvent>((event, emit) async {
      emit(
        PastHistoryState(from: event.from, to: event.to, data: []).copyWith(
          providerId: event.providerId,
          providers: state.providers,
        ),
      );
      final data = await getExpertPastUseCase(
        page: state.pageNumber,
        fromDate: event.from,
        toDate: event.to,
        providerId: event.providerId,
      );
      await data.fold(
        (failure) {
          _mapFailureToState(failure, emit);
          return;
        },
        (data) {
          data.isEmpty
              ? emit(
                  state.copyWith(
                      status: PastRequestsStatus.success,
                      hasReachedMax: true,
                      from: event.from,
                      to: event.to,
                      providerId: event.providerId),
                )
              : emit(
                  state.copyWith(
                    status: PastRequestsStatus.success,
                    data: data,
                    from: event.from,
                    to: event.to,
                    providerId: event.providerId,
                    pageNumber: state.pageNumber + 1,
                    hasReachedMax: false,
                  ),
                );
        },
      );
    }, transformer: droppable());

    on<LoadMorePastRequestsEvent>((event, emit) async {
      if (state.hasReachedMax) return;
      final data = await getExpertPastUseCase(
        page: state.pageNumber,
        fromDate: state.from,
        toDate: state.to,
        providerId: state.providerId,
      );
      data.fold((failure) {
        _mapFailureToState(failure, emit);
      }, (data) {
        data.isEmpty
            ? emit(state.copyWith(hasReachedMax: true))
            : emit(state.copyWith(
                status: PastRequestsStatus.success,
                data: List.of(state.data)..addAll(data),
                pageNumber: state.pageNumber + 1,
                hasReachedMax: false));
      });
    }, transformer: droppable());
  }

  _mapFailureToState(Failure f, Emitter emit) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(state.copyWith(status: PastRequestsStatus.offline));
        return;

      case NetworkErrorFailure:
        emit(
          state.copyWith(
            status: PastRequestsStatus.error,
            errorMessage: (f as NetworkErrorFailure).message,
          ),
        );
        return;
    }
  }
}
