part of 'get_fav_categories_bloc.dart';

abstract class GetFavCategoriesEvent extends Equatable {
  const GetFavCategoriesEvent();

  @override
  List<Object> get props => [];
}
class LoadFavCategories extends GetFavCategoriesEvent{
  
}
