import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/errors/failures.dart';
import '../../../domain/entities/category_entity.dart';
import '../../../domain/use_cases/get_categories_use_case.dart';

part 'get_categories_event.dart';
part 'get_categories_state.dart';

class GetCategoriesBloc extends Bloc<GetCategoriesEvent, GetCategoriesState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  GetCategoriesBloc({required this.getCategoriesUseCase})
      : super(GetCategoriesInitial()) {
    on<LoadCategories>((event, emit) async {
      emit(LoadingGetCategories());
      final res = await getCategoriesUseCase();
      res.fold((failure) {
        _mapFailureToState(emit, failure);
      },
          (data) => emit(
                LoadedGetCategories(categories: data),
              ));
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(GetCategoriesOfflineState());
        break;

      case NetworkErrorFailure:
        emit(GetCategoriesErrorState(
            message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(const GetCategoriesErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}
