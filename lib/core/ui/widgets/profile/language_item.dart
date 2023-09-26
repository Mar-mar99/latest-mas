import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:masbar/core/ui/widgets/profile/profile_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:masbar/core/constants/api_constants.dart';
import 'package:masbar/core/ui/widgets/profile/profile_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masbar/features/localization/cubit/lacalization_cubit.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../features/auth/accounts/presentation/bloc/authentication_bloc.dart';
import '../../../managers/languages_manager.dart';
import '../app_dialog.dart';

class LanguageItem extends StatelessWidget {
  const LanguageItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileItem(
      icon: FontAwesomeIcons.language,
      text: AppLocalizations.of(context)?.changeLanguage ?? "",
      onTap: () {
        showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            builder: (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 3,
                        width: 35,
                        color: Colors.grey,
                        alignment: Alignment.center,
                      ),
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ...LanguagesManager.appLanguages.map((element) {
                            return ListTile(
                              onTap: () {
                                BlocProvider.of<LacalizationCubit>(context)
                                    .changeLanguage(element);
                              },
                              leading: Icon(
                                FontAwesomeIcons.language,
                                color: Theme.of(context).primaryColor,
                              ),
                              title: Text(
                                LanguagesManager.getLanguageTextFromCode(
                                  element,
                                ),
                              ),
                            );
                          }).toList()
                        ]),
                  ],
                ));
      },
    );
  }
}
