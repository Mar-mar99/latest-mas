// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../../../core/errors/failures.dart';
import '../../../domain/use_cases/update_address_use_case.dart';

part 'update_address_event.dart';
part 'update_address_state.dart';

class UpdateAddressBloc extends Bloc<UpdateAddressEvent, UpdateAddressState> {
  final UpdateAddressUseCase updateAddressUseCase;
  UpdateAddressBloc({
    required this.updateAddressUseCase,
  }) : super(UpdateAddressInitial()) {
    on<UpdateAddress>((event, emit) async {
      emit(LoadingUpdateAddress());

      final res1 = await updateAddressUseCase.call(address: event.address);
      await res1.fold((f) {
        _mapFailureToState(emit, f);
      }, (info) async {
        emit(LoadedUpdateAddress());
      });
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(UpdateAddressOfflineState());
        break;

      case NetworkErrorFailure:
        emit(UpdateAddressErrorState(
            message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(const UpdateAddressErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}
