  import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/ui/dialogs/loading_dialog.dart';
import '../../../core/utils/helpers/toast_utils.dart';
import '../../app_wrapper/app_wrapper.dart';
import '../../auth/accounts/presentation/bloc/authentication_bloc.dart';
import 'bloc/delete_account_bloc.dart';

void deleteAccountListener(DeleteAccountState state, BuildContext context) {
      if (state is LoadingDeleteAccount) {
      showLoadingDialog(context);
    } else if (state is DeleteAccountOfflineState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage('No internet connection');
    } else if (state is DeleteAccountErrorState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage(state.message);
    } else if (state is DoneDeleteAccount) {
      BlocProvider.of<AuthenticationBloc>(context).add(LogOutUserEvent());
       Navigator.pop(context);
    }
  }
