import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../domain/entities/company_service_entity.dart';
import '../../domain/use_cases/get_company_services_use_case.dart';

part 'get_company_sevices_event.dart';
part 'get_company_sevices_state.dart';

class GetCompanySevicesBloc extends Bloc<GetCompanySevicesEvent, GetCompanySevicesState> {
final GetCompanyServicesUseCase getCompanyServicesUseCase;
  GetCompanySevicesBloc({required this.getCompanyServicesUseCase}) : super(GetCompanySevicesInitial()) {
    on<GetCompanyServices>((event, emit)async {
      emit(LoadingGetCompanySevices());
      final res = await getCompanyServicesUseCase();
      res.fold((failure) {
        _mapFailureToState(emit, failure);
      },
          (data) => emit(
                LoadedGetCompanySevices(data: data),
              ));
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(GetCompanySevicesOfflineState());
        break;

      case NetworkErrorFailure:
        emit(GetCompanySevicesErrorState(message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(const GetCompanySevicesErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}
