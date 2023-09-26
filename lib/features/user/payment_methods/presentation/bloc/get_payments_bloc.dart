// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:masbar/core/errors/failures.dart';

import '../../domain/entities/payment_method_entity.dart';
import '../../domain/use_cases/get_payments_use_case.dart';

part 'get_payments_event.dart';
part 'get_payments_state.dart';

class GetPaymentsBloc extends Bloc<GetPaymentsEvent, GetPaymentsState> {
  final GetPaymentMethodsUseCase getPaymentMethodsUseCase;
  GetPaymentsBloc({
    required this.getPaymentMethodsUseCase,
  }) : super(GetPaymentsInitial()) {
    on<GetPaymentsMethodsEvent>((event, emit) async {
      emit(LoadingGetPayments());
      final res = await getPaymentMethodsUseCase();
      res.fold((f) {
        _mapFailureToState(emit, f);
      }, (data) {
        emit(LoadedGetPayments(payments: data));
      });
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(GetPaymentsOfflineState());
        break;

      case NetworkErrorFailure:
        emit(
            GetPaymentsErrorState(message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(
            GetPaymentsErrorState(message: (f as NetworkErrorFailure).message));

        break;
    }
  }
}
