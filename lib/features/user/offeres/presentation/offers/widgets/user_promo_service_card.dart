// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:masbar/core/ui/service_categories/service_card.dart';

import '../../../domain/entities/offer_service_entity.dart';
import '../screen/user_offer_providers_screen.dart';

class UserPromoServiceCard extends StatelessWidget {
  final OfferServiceEntity service;
  const UserPromoServiceCard({
    Key? key,
    required this.service,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ServiceCard(
      title: service.name,
      image: service.image,
      handlerOnTap: () {
          Navigator.pushNamed(context, UserOfferProvidersScreen.routeName,
         arguments: {'service':service} );
      },
    );
  }
}
