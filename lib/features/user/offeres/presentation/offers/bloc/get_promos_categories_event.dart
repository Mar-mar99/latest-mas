part of 'get_promos_categories_bloc.dart';

abstract class GetPromosCategoriesEvent extends Equatable {
  const GetPromosCategoriesEvent();

  @override
  List<Object> get props => [];
}
class LoadPromosCategories extends GetPromosCategoriesEvent{}
