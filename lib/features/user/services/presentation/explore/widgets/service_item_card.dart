// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/managers/languages_manager.dart';
import '../../../../../../core/ui/service_categories/service_card.dart';
import '../../../../../../core/ui/widgets/app_text.dart';
import '../../../../../../core/utils/helpers/custome_page_route.dart';
import '../../../../../../core/utils/helpers/helpers.dart';
import '../../../../../localization/cubit/lacalization_cubit.dart';
import '../../../domain/entities/service_entity.dart';
import '../../request_service/masbar_choosen/screens/masbar_request_service_screen.dart';
import '../dialogs/request_dialog.dart';

class ServiceItemCard extends StatelessWidget {
  final ServiceEntity serviceEntity;
  const ServiceItemCard({
    Key? key,
    required this.serviceEntity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ServiceCard(
        title: serviceEntity.name ?? '',
        image: serviceEntity.image ?? '',
        handlerOnTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return RequestDialog(serviceEntity: serviceEntity);
              });
        });
  }
}
