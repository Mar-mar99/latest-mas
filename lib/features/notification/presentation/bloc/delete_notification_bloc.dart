// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../domain/use_case/delete_notification_use_case.dart';

part 'delete_notification_event.dart';
part 'delete_notification_state.dart';

class DeleteNotificationBloc
    extends Bloc<DeleteNotificationEvent, DeleteNotificationState> {
  final DeleteNotificationUseCase deleteNotificationUseCase;

  DeleteNotificationBloc({
    required this.deleteNotificationUseCase,
  }) : super(DeleteNotificationInitial()) {
    on<DeleteEvent>((event, emit) async {
    emit(LoadingDeleteNotificationn());
      final res = await deleteNotificationUseCase.call(
        typeAuth: event.typeAuth,
        id: event.id,
      );
      res.fold((failure) {
        _mapFailureToState(emit, failure);
      },
          (notis) => emit(
                DoneDeleteNotification(),
              ));
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(DeleteNotificationOfflineState());
        break;

      case NetworkErrorFailure:
        emit(DeleteNotificationErrorState(
            message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(const DeleteNotificationErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}
