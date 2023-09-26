// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../domain/use_cases/delete_invitation_use_case.dart';

part 'delete_invitation_event.dart';
part 'delete_invitation_state.dart';

class DeleteInvitationBloc
    extends Bloc<DeleteInvitationEvent, DeleteInvitationState> {
  final DeleteInvitationUseCase deleteInvitationUseCase;
  DeleteInvitationBloc({
    required this.deleteInvitationUseCase,
  }) : super(DeleteInvitationInitial()) {
    on<DeleteEvent>((event, emit) async {
      emit(LoadingDeleteInvitationState());
      final res = await deleteInvitationUseCase(id: event.id);
      res.fold((f) {
        _mapFailureToState(emit, f);
      }, (info) async {
        emit(DoneDeleteInvitationState());
      });
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(DeleteInvitationOfflineState());
        break;

      case NetworkErrorFailure:
        emit(DeleteInvitationStateErrorState(
            message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(const DeleteInvitationStateErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}
