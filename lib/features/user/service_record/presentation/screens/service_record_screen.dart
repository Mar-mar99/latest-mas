import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masbar/core/api_service/network_service_http.dart';
import 'package:masbar/features/user/service_record/data/repositories/user_service_record_repo_impl.dart';
import 'package:masbar/features/user/service_record/presentation/screens/past_requests_screen.dart';
import 'package:masbar/features/user/service_record/presentation/screens/upcoming_requests_screen.dart';

import '../../../../../core/ui/widgets/app_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../data/data_source/user_service_record_data_source.dart';
import '../../domain/use_cases/get_user_history_records_use_case.dart';
import '../../domain/use_cases/get_user_upcoming_records_use_case.dart';
import '../bloc/user_history_requests_bloc.dart';
import '../bloc/user_upcoming_requests_bloc.dart';

class ServiceRecordScreen extends StatelessWidget {
  static const routeName = 'service_record_screen';
  const ServiceRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _getUserHistoryRecordsBloc(),
        ),
        BlocProvider(
          create: (context) => _getUserUpcomingRecordsBloc(),
        ),
      ],
      child: Builder(builder: (context) {
        return DefaultTabController(
          initialIndex: 0,
          length: 2,
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: Colors.white,
            iconTheme:const IconThemeData(color: Colors.black),
              title: AppText(
                AppLocalizations.of(context)?.servicesRecord ?? "",
                fontWeight: FontWeight.bold,
              ),
              elevation: 0,
              bottom: TabBar(
                indicatorPadding: const EdgeInsets.symmetric(horizontal: 10),
                indicatorWeight: 1,
                indicatorColor: Theme.of(context).primaryColor,
                tabs: <Widget>[
                  Tab(
                    child: AppText(
                      AppLocalizations.of(context)!.upcoming,
                    ),
                  ),
                  Tab(
                    child: AppText(
                      AppLocalizations.of(context)!.past,
                    ),
                  ),
                ],
              ),
            ),
            body: const TabBarView(
              children: <Widget>[
                UpcomingRequestsScreen(),
                PastRequestsScreen()
              ],
            ),
          ),
        );
      }),
    );
  }

  UserHistoryRequestsBloc _getUserHistoryRecordsBloc() {
    return UserHistoryRequestsBloc(
      getUserHistoryRecordsUseCase: GetUserHistoryRecordsUseCase(
        userServiceRecordRepo: UserServiceRecordRepoImpl(
          userServiceRecordsSource: UserServiceRecordeDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    )..add(GetUserPastRequestsEvent());
  }

    UserUpcomingRequestsBloc _getUserUpcomingRecordsBloc() {
    return UserUpcomingRequestsBloc(
      getUserUpcomingRecordsUseCase:  GetUserUpcomingRecordsUseCase(
        userServiceRecordRepo: UserServiceRecordRepoImpl(
          userServiceRecordsSource: UserServiceRecordeDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    )..add(GetUserUpcomingtRequestsEvent());
  }
}
