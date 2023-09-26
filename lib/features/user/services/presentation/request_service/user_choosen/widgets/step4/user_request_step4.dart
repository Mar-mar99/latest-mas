// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../core/utils/enums/enums.dart';
import '../../bloc/user_create_request_bloc.dart';
import 'busy_step4.dart';
import 'offline_step4.dart';
import 'online_step4.dart';

class UserRequestStep4 extends StatelessWidget {
  final Function changeCurrentTab;
  const UserRequestStep4({
    Key? key,
    required this.changeCurrentTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCreateRequestBloc, UserCreateRequestState>(
      builder: (context, state) {
        switch(state.providerStatus){

          case ProviderStatus.online:
              return OnlineStep4(changeCurrentTab: changeCurrentTab,);
          case ProviderStatus.busy:
              return BusyStep4(changeCurrentTab: changeCurrentTab);
          case ProviderStatus.offline:
            return OfflineStep4(changeCurrentTab: changeCurrentTab);
        }

      },
    );
  }
}
