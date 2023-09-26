// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:masbar/core/utils/helpers/helpers.dart';

import '../../../../../../core/ui/service_categories/category_card.dart';
import '../../../domain/entities/category_entity.dart';
import '../screens/explore_services_screen.dart';

class ExploreCategoryCard extends StatelessWidget {
  final CategoryEntity category;
  const ExploreCategoryCard({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CategoryCard(
      title: category.title,
      image: category.image,
      handlerOnTap: () {
        Navigator.pushNamed(context, ExploreServicesScreen.routeName,
            arguments: {
              'category': category,
            });
      },
    );
  }
}
