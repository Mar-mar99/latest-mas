// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/errors/failures.dart';
import '../../../domain/entities/offer_category_entity.dart';
import '../../../domain/use_cases/get_promos_categories_use_case.dart';

part 'get_promos_categories_event.dart';
part 'get_promos_categories_state.dart';

class GetPromosCategoriesBloc extends Bloc<GetPromosCategoriesEvent, GetPromosCategoriesState> {
final GetPromosCategoriesUseCase getPromosCategoriesUseCase;
  GetPromosCategoriesBloc({
   required this.getPromosCategoriesUseCase,
  }
  ) : super(GetPromosCategoriesInitial()) {
    on<LoadPromosCategories>((event, emit)async {
     emit(LoadingGetPromosCategories());
      final res = await getPromosCategoriesUseCase();
      res.fold((f) {
        _mapFailureToState(emit, f);
      }, (data) {
        emit(LoadedGetPromosCategories(data: data));
      });
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(GetPromosCategoriesOfflineState());
        break;

      case NetworkErrorFailure:
        emit(GetPromosCategoriesErrorState(message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(GetPromosCategoriesErrorState(message: (f as NetworkErrorFailure).message));

        break;
    }
  }
}
