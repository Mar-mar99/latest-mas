// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:masbar/core/utils/helpers/helpers.dart';

import '../../../../../../../../core/errors/failures.dart';
import '../../../domain/use_cases/update_company_emirates_use_case.dart';

part 'update_company_emirates_event.dart';
part 'update_company_emirates_state.dart';

class UpdateCompanyEmiratesBloc
    extends Bloc<UpdateCompanyEmiratesEvent, UpdateCompanyEmiratesState> {
  final UpdateCompanyEmiratesUseCase updateCompanyEmiratesUseCase;
  UpdateCompanyEmiratesBloc({
    required this.updateCompanyEmiratesUseCase,
  }) : super(UpdateCompanyEmiratesInitial()) {
    on<UpdateEmiratesEvent>((event, emit) async {
      emit(LoadingUpdateCompanyEmirates());
      List<int> states = [];
      Helpers.modelBuilder(
        event.states,
        (index, model) {
          if (model == true) states.add(index + 1);
        },
      );
      final res1 = await updateCompanyEmiratesUseCase.call(
        states: states,
        headState: event.headState + 1,
      );
      await res1.fold((f) {
        _mapFailureToState(emit, f);
      }, (info) async {
        emit(LoadedUpdateCompanyEmirates());
      });
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(UpdateCompanyEmiratesOfflineState());
        break;

      case NetworkErrorFailure:
        emit(UpdateCompanyEmiratesErrorState(
            message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(const UpdateCompanyEmiratesErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}
