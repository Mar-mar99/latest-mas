// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../../../../../core/ui/service_categories/service_card.dart';
import '../../../domain/entities/favorite_service_entity.dart';
import '../screens/favorite_provider_screen.dart';

class FavoritesServiceCard extends StatelessWidget {
  final FavoriteServiceEntity favoriteServiceEntity;
  const FavoritesServiceCard({
    Key? key,
    required this.favoriteServiceEntity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ServiceCard(
      title: favoriteServiceEntity.name,
      image: favoriteServiceEntity.image,
      handlerOnTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return FavoritesProviderScreen(favoriteServiceEntity: favoriteServiceEntity);
        },));
      },
    );
  }

}
