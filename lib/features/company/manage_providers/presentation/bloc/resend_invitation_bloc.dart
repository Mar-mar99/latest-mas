// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:masbar/core/errors/failures.dart';

import 'package:masbar/features/company/manage_providers/domain/use_cases/resend_invitation_use_case.dart';

part 'resend_invitation_event.dart';
part 'resend_invitation_state.dart';

class ResendInvitationBloc
    extends Bloc<ResendInvitationEvent, ResendInvitationState> {
  final ResendInvitationUseCase resendInvitationUseCase;
  ResendInvitationBloc({
    required this.resendInvitationUseCase,
  }) : super(ResendInvitationInitial()) {
    on<ResendEvent>((event, emit) async {
      emit(LoadingResendInvitationState());
      final res = await resendInvitationUseCase(id: event.id);
      res.fold((f) {
        _mapFailureToState(emit, f);
      }, (_) async {
        emit(DoneResendInvitationState());
      });
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(ResendInvitationOfflineState());
        break;

      case NetworkErrorFailure:
        emit(ResendInvitationStateErrorState(
            message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(const ResendInvitationStateErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}
