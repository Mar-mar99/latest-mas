// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../../../../../core/ui/service_categories/category_card.dart';
import '../../../domain/entities/offer_category_entity.dart';
import '../screen/user_offer_services_screen.dart';

class UserPromoCategoryCard extends StatelessWidget {
  final OfferCategoryEntity category;
  const UserPromoCategoryCard({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CategoryCard(
        title: category.name,
        image: category.image,
        handlerOnTap: () {
          Navigator.pushNamed(context, UserOfferServicesScreen.routeName,
         arguments: {'category':category} );
        });
  }
}
