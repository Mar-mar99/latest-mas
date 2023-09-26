// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/errors/failures.dart';

import '../../../domain/entities/service_entity.dart';
import '../../../domain/use_cases/get_services_use_case.dart';

part 'get_services_event.dart';
part 'get_services_state.dart';

class GetServicesBloc extends Bloc<GetServicesEvent, GetServicesState> {
  final GetServicesUseCase getServicesUseCase;
  GetServicesBloc({
    required this.getServicesUseCase,
  }) : super(GetServicesInitial()) {
    on<LoadServicesEvent>((event, emit) async {
      emit(LoadingGetService());
      final res = await getServicesUseCase(id: event.id);
      res.fold((failure) {
        _mapFailureToState(emit, failure);
      },
          (data) => emit(
                LoadedGetService(services: data),
              ));
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(GetServiceOfflineState());
        break;

      case NetworkErrorFailure:
        emit(GetServiceErrorState(message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(const GetServiceErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}
