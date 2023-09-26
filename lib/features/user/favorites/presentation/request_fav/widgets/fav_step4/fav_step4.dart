import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/ui/widgets/app_text.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../../navigation/screens/user_screen.dart';
import '../../bloc/request_fav_provider_bloc.dart';

class FavStep4 extends StatelessWidget {
  const FavStep4({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            EvaIcons.checkmarkCircle,
            size: 130.0,
            color: Theme.of(context).primaryColor,
          ),
          AppText(
            AppLocalizations.of(context)!.serviceCreatedMessage,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(
            height: 100,
          ),
          SizedBox(
              width: 180,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor),
                onPressed: () {
                  final id =
                      context.read<RequestFavProviderBloc>().state.requestId;
                  Navigator.pushNamedAndRemoveUntil(
                      context, UserScreen.routName, (route) => false,
                      arguments: {
                        'showExploreScreen': null,
                        'requestId': null
                      });
                },
                child:
                    Text(AppLocalizations.of(context)!.go_to_service_details),
              )),
        ],
      ),
    );
  }
}
