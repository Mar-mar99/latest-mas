import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/errors/failures.dart';
import '../../../../../../core/utils/helpers/form_submission_state.dart';
import '../../../domain/entities/invoice_entity.dart';
import '../../../domain/use_cases/finish_working_use_case.dart';

part 'end_event.dart';
part 'end_state.dart';

class EndBloc extends Bloc<EndEvent, EndState> {
  final FinishWorkingUseCase finishWorkingUseCase;
  EndBloc({required this.finishWorkingUseCase}) : super(EndState.empty()) {
    on<CommentChangedEvent>((event, emit) {
      print('adding comment');
      emit(state.copyWith(comment: event.comment));
    });

    on<AddImageEndServiceEvent>((event, emit) {
      emit(state.copyWith(
        images: List.of(state.images)..add(event.image),
      ));
    });

    on<RemoveImageEndServiceEvent>((event, emit) {
      emit(state.copyWith(
        images: List.of(state.images)..remove(event.image),
      ));
    });

    on<EndServiceEvent>((event, emit) async {
      emit(
        state.copyWith(formSubmissionState: FormSubmittingState()),
      );
      print('ending bloc ${state.comment}');
      final res = await finishWorkingUseCase.call(
        requestId: event.id,
        comment: state.comment,
        images: state.images,
      );
      res.fold(
        (failure) {
          emit(
            state.copyWith(
              formSubmissionState: _mapFailureToState(emit, failure),
            ),
          );
        },
        (data) {
          emit(
            state.copyWith(
              formSubmissionState: FormSuccesfulState(),
              invoiceEntity: data,
            ),
          );
        },
      );
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        return FormNoInternetState();

      case NetworkErrorFailure:
        return FormNetworkErrorState(
            message: (f as NetworkErrorFailure).message);

      default:
        return const FormNetworkErrorState(message: 'error');
    }
  }
}
