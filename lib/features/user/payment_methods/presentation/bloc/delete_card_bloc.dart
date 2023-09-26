import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../domain/use_cases/delete_card_use_case.dart';

part 'delete_card_event.dart';
part 'delete_card_state.dart';

class DeleteCardBloc extends Bloc<DeleteCardEvent, DeleteCardState> {
  final DeleteCardUseCase deleteCardUseCase;
  DeleteCardBloc({
    required this.deleteCardUseCase
  }) : super(DeleteCardInitial()) {
    on<DeleteEvent>((event, emit)async {
    emit(LoadingDeleteCard());
      final res = await deleteCardUseCase(id:event.id);
      res.fold((f) {
        _mapFailureToState(emit, f);
      }, (data) {
        emit(DoneDeleteCard());
      });
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(DeleteCardOfflineState());
        break;

      case NetworkErrorFailure:
        emit(
            DeleteCardErrorState(message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(
            DeleteCardErrorState(message: (f as NetworkErrorFailure).message));

        break;
    }
  }
}
