import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/helpers/form_submission_state.dart';
import '../../domain/use_cases/update_company_profile_use_case.dart';

part 'edit_company_info_event.dart';
part 'edit_company_info_state.dart';

class EditCompanyInfoBloc
    extends Bloc<EditCompanyInfoEvent, EditCompanyInfoState> {
  final UpdateCompanyProfileUseCase updateCompanyProfileUseCase;

  EditCompanyInfoBloc({required this.updateCompanyProfileUseCase})
      : super(InitEditCompany()) {
    on<EditCompanyEvent>((event, emit) async {
      emit(LoadingEditCompany());
      final res = await updateCompanyProfileUseCase.call(
        firstName: event.companyName,
        address: event.address,
        local: event.isCitizen,
        state: event.state,
      );
      res.fold((failure) {
        _mapFailureToState(emit, failure);
      },
          (states) => emit(
                DoneEditCompany(),
              ));
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(EditCompanyOfflineState());
        break;

      case NetworkErrorFailure:
        emit(
            EditCompanyErrorState(message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(EditCompanyErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}
