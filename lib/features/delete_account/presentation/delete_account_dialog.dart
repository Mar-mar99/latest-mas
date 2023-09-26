import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:masbar/core/utils/helpers/helpers.dart';
import 'package:masbar/features/auth/accounts/domain/repositories/auth_repo.dart';
import 'package:masbar/features/delete_account/presentation/bloc/delete_account_bloc.dart';

import '../../../core/ui/widgets/app_dialog.dart';

showDeleteAccountDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogItem(
          icon: Icon(
            Boxicons.bx_log_out,
            size: 40,
            color: Theme.of(context).primaryColor,
          ),
          title: AppLocalizations.of(context)?.deleteAccount ?? "",
          paragraph:
              AppLocalizations.of(context)?.doYouWantToDeleteAccount ?? "",
          cancelButtonText: AppLocalizations.of(context)?.cancel ?? "",
          nextButtonText: AppLocalizations.of(context)?.delete ?? "",
          nextButtonFunction: () async {
            BlocProvider.of<DeleteAccountBloc>(context).add(
              DeleteAccount(
                typeAuth: Helpers.getUserTypeEnum(
                  context.read<AuthRepo>().getUserData()!.type!,
                ),
              ),
            );
          },
          cancelButtonFunction: () {
            Navigator.pop(context);
          },
        );
      });
}
