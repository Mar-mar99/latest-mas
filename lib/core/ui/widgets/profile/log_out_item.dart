import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:masbar/core/ui/dialogs/loading_dialog.dart';
import 'package:masbar/core/ui/widgets/profile/profile_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masbar/core/utils/helpers/toast_utils.dart';
import 'package:masbar/features/auth/accounts/domain/repositories/auth_repo.dart';
import 'package:masbar/features/auth/accounts/presentation/bloc/log_out_bloc.dart';
import 'package:restart_app/restart_app.dart';
import '../../../../config/routes/app_router.dart';
import '../../../../features/app/my_app.dart';
import '../../../../features/app_wrapper/app_wrapper.dart';
import '../../../../features/auth/accounts/data/repositories/auth_repo_impl.dart';
import '../../../../features/auth/accounts/presentation/bloc/authentication_bloc.dart';
import '../../../utils/helpers/helpers.dart';
import '../app_dialog.dart';

class LogOutItem extends StatelessWidget {
  const LogOutItem({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogOutBloc, LogOutState>(
      listener: (context, state) {
        if (state is LoadingLogOut) {
          showLoadingDialog(context, text: 'Loging out...');
        } else if (state is LogOutOfflineState) {
          Navigator.pop(context);
          ToastUtils.showErrorToastMessage('No internet Connection');
        } else if (state is LogOutErrorState) {
          ToastUtils.showErrorToastMessage('Network error, try again');
          Navigator.pop(context);
        } else if (state is DoneLogOut) {
          Navigator.pop(context);

          BlocProvider.of<AuthenticationBloc>(context).add(LogOutUserEvent());
         Restart.restartApp(webOrigin: '');
        }
      },
      child: ProfileItem(
          icon: Boxicons.bx_log_out,
          text: AppLocalizations.of(context)?.logout ?? "",
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return DialogItem(
                  icon: Icon(
                    Boxicons.bx_log_out,
                    size: 40,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: AppLocalizations.of(context)?.logout ?? "",
                  paragraph:
                      AppLocalizations.of(context)?.doYouWantToLogout ?? "",
                  cancelButtonText: AppLocalizations.of(context)?.cancel ?? "",
                  nextButtonText: AppLocalizations.of(context)?.logout ?? "",
                  nextButtonFunction: () async {
                    BlocProvider.of<LogOutBloc>(context).add(
                      LogOut(
                        typeAuth: Helpers.getUserTypeEnum(
                          context.read<AuthRepo>().getUserData()!.type!,
                        ),
                      ),
                    );

                    Navigator.pop(context);
                  },
                  cancelButtonFunction: () {
                    Navigator.pop(context);
                  },
                );
              },
            );
          }),
    );
  }
}
