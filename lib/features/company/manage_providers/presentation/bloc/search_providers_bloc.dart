// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../domain/entities/provider_entity.dart';
import '../../domain/use_cases/search_active_provider_use_case.dart';

part 'search_providers_event.dart';
part 'search_providers_state.dart';

class SearchProvidersBloc extends Bloc<SearchProvidersEvent, SearchProvidersState> {
  final SearchActiveProviderUseCase searchActiveProviderUseCase;
  SearchProvidersBloc({
   required this.searchActiveProviderUseCase,
  }
  ) : super(SearchProvidersInitial()) {
    on<SearchEvent>((event, emit) async{
         emit(LoadingSearchProviders());
      final res1 = await searchActiveProviderUseCase.call(key: event.key);
      await res1.fold((f) {
        _mapFailureToState(emit, f);
      }, (data) async {
emit(LoadedSearchProviders(data:data ));
      });
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(SearchProvidersOfflineState());
        break;

      case NetworkErrorFailure:
        emit(SearchProvidersNetworkErrorState(
            message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(const SearchProvidersNetworkErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}
