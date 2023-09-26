// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';


import '../../../../../core/errors/failures.dart';
import '../../domain/entities/company_provider_entity.dart';

import '../../domain/use_cases/get_providers_use_case.dart';

part 'services_providers_info_event.dart';
part 'services_providers_info_state.dart';

class ServicesProvidersInfoBloc extends Bloc<ServicesProvidersInfoEvent, ServicesProvidersInfoState> {

  final GetProvidersUseCase getProvidersUseCase;

  ServicesProvidersInfoBloc({

   required this.getProvidersUseCase,
  }
  ) : super(ServicesProvidersInfoInitial()) {
    on<LoadInfoEvent>((event, emit) async{
  emit(LoadingServicesProvidersInfoState());

        final res2 = await getProvidersUseCase.call();
       await res2.fold((f) {
          _mapFailureToState(emit, f);
        }, (providers) {
          emit(LoadedServicesProvidersInfoState(providers: providers));
        });

    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(ServicesProvidersInfoOfflineState());
        break;

      case NetworkErrorFailure:
        emit(ServicesProvidersInfoNetworkErrorState(
            message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(const ServicesProvidersInfoNetworkErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}

