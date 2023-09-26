// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../../../core/errors/failures.dart';
import '../../../domain/entities/company_emirates_entity.dart';
import '../../../domain/use_cases/get_company_emirates_use_case.dart';

part 'get_company_emirates_event.dart';
part 'get_company_emirates_state.dart';

class GetCompanyEmiratesBloc
    extends Bloc<GetCompanyEmiratesEvent, GetCompanyEmiratesState> {
  final GetCompanyEmiratesUseCase getCompanyEmiratesUseCase;
  GetCompanyEmiratesBloc({
    required this.getCompanyEmiratesUseCase,
  }) : super(GetCompanyEmiratesInitial()) {
    on<GetEmiratesEvent>((event, emit) async {
      emit(LoadingGetCompanyEmirates());
      final res1 = await getCompanyEmiratesUseCase.call();
      await res1.fold((f) {
        _mapFailureToState(emit, f);
      }, (info) async {
        emit(LoadedGetCompanyEmirates(data: info));
      });
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(GetCompanyEmiratesOfflineState());
        break;

      case NetworkErrorFailure:
        emit(GetCompanyEmiratesErrorState(
            message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(const GetCompanyEmiratesErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}
