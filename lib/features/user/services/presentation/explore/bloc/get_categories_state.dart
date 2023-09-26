part of 'get_categories_bloc.dart';

abstract class GetCategoriesState extends Equatable {
  const GetCategoriesState();

  @override
  List<Object> get props => [];
}

class GetCategoriesInitial extends GetCategoriesState {}

class LoadingGetCategories extends GetCategoriesState{}
class LoadedGetCategories extends GetCategoriesState {
  final List<CategoryEntity> categories;
  LoadedGetCategories({
    required this.categories,
  });

  @override

  List<Object> get props => [categories];
}


class GetCategoriesOfflineState extends GetCategoriesState{}

class GetCategoriesErrorState extends GetCategoriesState {
  final String message;
  const GetCategoriesErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

