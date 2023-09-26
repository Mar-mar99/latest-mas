part of 'get_promos_categories_bloc.dart';

abstract class GetPromosCategoriesState extends Equatable {
  const GetPromosCategoriesState();

  @override
  List<Object> get props => [];
}

class GetPromosCategoriesInitial extends GetPromosCategoriesState {}

class LoadingGetPromosCategories extends GetPromosCategoriesState {}

class LoadedGetPromosCategories extends GetPromosCategoriesState {
  final List<OfferCategoryEntity> data;
  LoadedGetPromosCategories({
    required this.data,
  });

  @override
  List<Object> get props => [data];
}

class GetPromosCategoriesOfflineState extends GetPromosCategoriesState {}

class GetPromosCategoriesErrorState extends GetPromosCategoriesState {
  final String message;
  const GetPromosCategoriesErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
