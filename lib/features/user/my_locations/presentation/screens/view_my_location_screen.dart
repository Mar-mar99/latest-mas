// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:masbar/core/ui/widgets/custom_map.dart';
import '../../domain/entities/my_location_entity.dart';

class ViewMyLocationScreen extends StatelessWidget {
  static const routeName = 'view_my_location_screen';
  final MyLocationsEntity myLocationsEntity;
  const ViewMyLocationScreen({
    Key? key,
    required this.myLocationsEntity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          myLocationsEntity.name,
        ),
      ),
      body: SingleChildScrollView(
        child: CustomMap(
          lat: myLocationsEntity.lat,
          lng: myLocationsEntity.lng,
          isThirdScreen: false,
        ),
      ),
    );
  }
}
