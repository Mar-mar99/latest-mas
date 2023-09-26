part of 'get_fav_categories_bloc.dart';

abstract class GetFavCategoriesState extends Equatable {
  const GetFavCategoriesState();

  @override
  List<Object> get props => [];
}

class GetFavCategoriesInitial extends GetFavCategoriesState {}

class LoadingGetFavCategories extends GetFavCategoriesState {}

class LoadedGetFavCategories extends GetFavCategoriesState {
  final List<FavoriteCategoryEntity> data;
  LoadedGetFavCategories({
    required this.data,
  });

  @override
  List<Object> get props => [data];
}

class GetFavCategoriesOfflineState extends GetFavCategoriesState {}

class GetFavCategoriesErrorState extends GetFavCategoriesState {
  final String message;
  const GetFavCategoriesErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
