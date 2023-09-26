// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:masbar/features/company/manage_providers/domain/use_cases/get_pending_provider_use_case.dart';
import 'package:masbar/features/company/manage_providers/domain/use_cases/get_provider_info_use_case.dart';

import '../../../../../core/errors/failures.dart';
import '../../domain/entities/provider_entity.dart';
import '../../domain/entities/provider_info_entity.dart';

part 'provider_info_event.dart';
part 'provider_info_state.dart';

class ProviderInfoBloc extends Bloc<ProviderInfoEvent, ProviderInfoState> {
  final GetPendingProviderUseCase getPendingProviderUseCase;
  final GetProviderInfoUseCase getProviderInfoUseCase;
  ProviderInfoBloc({
    required this.getPendingProviderUseCase,
    required this.getProviderInfoUseCase,
  }) : super(ProviderInfoInitial()) {
    on<GetProviderInfoAndPending>((event, emit) async {
      emit(LoadingProviderInfo());
      final res1 = await getProviderInfoUseCase.call();
     await res1.fold((f) {
        _mapFailureToState(emit, f);
      }, (info) async {
        final res2 = await getPendingProviderUseCase.call();
       await res2.fold((f) {
          _mapFailureToState(emit, f);
        }, (pendingInfo) {
          emit(LoadedProviderInfo(info: info, pending: pendingInfo));
        });
      });
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(ProviderInfoOfflineState());
        break;

      case NetworkErrorFailure:
        emit(ProviderInfoNetworkErrorState(
            message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(const ProviderInfoNetworkErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}
