
import 'package:flutter/material.dart';

import '../../../../../../core/ui/service_categories/category_card.dart';

import '../../../domain/entities/favorite_category_entity.dart';
import '../screens/favorites_services_screen.dart';

class FavoritesCategoryCard extends StatelessWidget {
  final FavoriteCategoryEntity category;
  const FavoritesCategoryCard({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return CategoryCard(
        title: category.name,
        image: category.image,
        handlerOnTap: () {
          Navigator.pushNamed(context, FavoritesServicesScreen.routeName,
         arguments: {'category':category} );
        });

  }
}
