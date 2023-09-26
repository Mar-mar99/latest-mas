import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masbar/features/user/services/presentation/request_service/masbar_choosen/bloc/create_request_bloc.dart';

import '../../../../../../../../core/ui/widgets/app_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../../../../core/ui/widgets/app_text.dart';
import '../../../../../../../navigation/screens/user_screen.dart';
import '../../../../service_details.dart/screen/service_details_screen.dart';

class Step4 extends StatelessWidget {
  const Step4({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
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
                      final id = context
                          .read<CreateRequestBloc>()
                          .state
                          .createdRequestResultEntity!
                          .requestId;
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                            return ServiceDetailsScreen(
                              requestId: id,
                            );
                          },));
                      // Navigator.pushNamedAndRemoveUntil(
                      //     context, UserScreen.routName, (route) => false,
                      //     arguments: {
                      //       'showExploreScreen': null,
                      //       'requestId': null
                      //     });
                    },
                    child:
                        Text(AppLocalizations.of(context)!.go_to_service_details),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
