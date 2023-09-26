import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/errors/failures.dart';
import '../../../domain/entities/favorite_category_entity.dart';
import '../../../domain/use_cases/get_fav_categories_use_case.dart';

part 'get_fav_categories_event.dart';
part 'get_fav_categories_state.dart';

class GetFavCategoriesBloc extends Bloc<GetFavCategoriesEvent, GetFavCategoriesState> {
  final GetFavCategoriesUseCase getFavCategoriesUseCase;
  GetFavCategoriesBloc({
    required this.getFavCategoriesUseCase
  }) : super(GetFavCategoriesInitial()) {
    on<LoadFavCategories>((event, emit) async{
        emit(LoadingGetFavCategories());
      final res = await getFavCategoriesUseCase();
      res.fold((f) {
        _mapFailureToState(emit, f);
      }, (data) {
        emit(LoadedGetFavCategories(data: data));
      });
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(GetFavCategoriesOfflineState());
        break;

      case NetworkErrorFailure:
        emit(GetFavCategoriesErrorState(message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(GetFavCategoriesErrorState(message: (f as NetworkErrorFailure).message));

        break;
    }
  }
}
