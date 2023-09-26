// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../../core/ui/widgets/app_textfield.dart';
import '../../../domain/entities/category_entity.dart';
import '../screens/search_services_screen.dart';

class SearchTextField extends StatelessWidget {
  final CategoryEntity? categoryEntity;

  const SearchTextField({
    Key? key,
    this.categoryEntity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: TextEditingController(),
      suffixIcon: Icons.search_rounded,
      hintText: AppLocalizations.of(context)?.searchHint ?? "",
      readOnly: true,
      onTap: () {
        Navigator.pushNamed(
          context,
          SearchServicesScreen.routeName,
          arguments: {
            'category': categoryEntity,
          },
        );
      },
    );
  }
}
