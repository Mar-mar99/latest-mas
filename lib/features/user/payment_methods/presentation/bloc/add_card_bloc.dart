import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:masbar/core/utils/services/stripe_service.dart';
import 'package:masbar/features/user/payment_methods/domain/use_cases/add_card_use_case.dart';

import 'package:stripe_api_2/stripe_api.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/utils/helpers/form_submission_state.dart';

part 'add_card_event.dart';
part 'add_card_state.dart';

class AddCardBloc extends Bloc<AddCardEvent, AddCardState> {
  final AddCardUseCase addCardUseCase;
  AddCardBloc({required this.addCardUseCase}) : super(AddCardState.empty()) {
    on<AddEvent>((event, emit) async {

      emit(
        state.copyWith(
          formSubmissionState: FormSubmittingState(),

        ),
      );
      final id  =await StripeService.getStripeToken(event.stripeCard);
      final res= await addCardUseCase.call(cardToken: id);
     res.fold((f) {
        _mapFailureToState(emit, f);
      }, (data) {
        emit(state.copyWith(formSubmissionState: FormSuccesfulState()));
      });
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(state.copyWith(formSubmissionState: FormNoInternetState()));
        break;

      case NetworkErrorFailure:
       emit(state.copyWith(formSubmissionState: FormNetworkErrorState(message: (f as NetworkErrorFailure).message)));

        break;

      default:
        emit(state.copyWith(formSubmissionState: FormNetworkErrorState(message: (f as NetworkErrorFailure).message)));

        break;
    }
  }
}

