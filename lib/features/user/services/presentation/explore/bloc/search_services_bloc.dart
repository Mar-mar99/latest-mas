// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:masbar/features/user/services/domain/use_cases/search_services_use_case.dart';

import '../../../../../../core/errors/failures.dart';
import '../../../../../../core/utils/helpers/form_submission_state.dart';
import '../../../domain/entities/service_entity.dart';

part 'search_services_event.dart';
part 'search_services_state.dart';

class SearchServicesBloc
    extends Bloc<SearchServicesEvent, SearchServicesState> {
  final SerachServicesUseCase serachServicesUseCase;

  SearchServicesBloc({
    required this.serachServicesUseCase,
  }) : super(SearchServicesState.empty()) {
    on<TypeChangedEvent>((event, emit) {
      print('type: ${event.type}');
      emit(
        state.copyWith(
          type: event.type,
          formSubmissionState: InitialFormState(),
        ),
      );
    });

    on<DistanceChangedEvent>((event, emit) {
      emit(state.copyWith(
          distance: event.distance, formSubmissionState: InitialFormState()));
    });

    on<KeywordChangedEvent>((event, emit) {
      emit(state.copyWith(
          keyword: event.keyword, formSubmissionState: InitialFormState()));
    });

    on<FilterEvent>((event, emit) async {
      emit(state.copyWith(formSubmissionState: FormSubmittingState()));
   
      final res = await serachServicesUseCase(
        categoryId: event.categoryId,
        text: state.keyword,
        distance: state.distance,
        type: state.type,
      );
      await res.fold((f) {
        emit(state.copyWith(formSubmissionState: _mapFailureToState(f)));
      }, (r) {
        emit(
            state.copyWith(data: r, formSubmissionState: FormSuccesfulState()));
      });
    });
  }

  FormSubmissionState _mapFailureToState(Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        return FormNoInternetState();

      case NetworkErrorFailure:
        return FormNetworkErrorState(
          message: (f as NetworkErrorFailure).message,
        );

      default:
        return const FormNetworkErrorState(
          message: 'Error',
        );
    }
  }
}
