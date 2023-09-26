import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:masbar/core/api_service/network_service_http.dart';
import 'package:masbar/features/company/user_activity/data/data_source/user_activity_data_source.dart';
import 'package:masbar/features/company/user_activity/data/repositories/user_activity_repo_impl.dart';
import 'package:masbar/features/company/user_activity/domain/use_cases/get_past_past_use_case.dart';
import 'package:masbar/features/company/user_activity/presentation/service_history/bloc/past_history_bloc.dart';
import 'package:masbar/features/company/user_activity/presentation/service_history/screen/past_service_history_screen.dart';
import 'package:masbar/features/company/user_activity/presentation/service_history/screen/upcoming_service_history_screen.dart';

import '../../../../../../core/ui/widgets/app_text.dart';
import '../../../../services_settings/data/data_sources/services_remote_data_source.dart';
import '../../../../services_settings/data/repositories/services_repo_impl.dart';
import '../../../../services_settings/domain/use_cases/get_providers_use_case.dart';
import '../../../domain/use_cases/get_expert_upcoming_use_case.dart';
import '../bloc/upcoming_history_bloc.dart';

class CompanyServiceHistory extends StatelessWidget {
  static const routeName = 'companys_service_records_screen';
  const CompanyServiceHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _getPastBloc(),
        ),
        BlocProvider(
          create: (context) => _getUpcomingBloc(),
        ),
      ],
      child: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.black),
            title: AppText(
              AppLocalizations.of(context)?.serviceHistory ?? "",
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
          body: TabBarView(
            children: <Widget>[
              UpcomingServiceHistoryScreen(),
              PastServiceHistoryScreen(),
            ],
          ),
        ),
      ),
    );
  }

  PastHistoryBloc _getPastBloc() {
    return PastHistoryBloc(
      getProvidersUseCase: GetProvidersUseCase(
        servicesRepo: ServicesRepoImpl(
          servicesRemoteDataSource: ServicesRemoteDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
      getExpertPastUseCase: GetExpertPastUseCase(
        userActivityRepo: UserActivityRepoImpl(
          userActivityDataSource: UserActivityDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    )..add(LoadFirstTimePastRequestsEvent());
  }

  UpcomingHistoryBloc _getUpcomingBloc() {
    return UpcomingHistoryBloc(
      getProvidersUseCase: GetProvidersUseCase(
        servicesRepo: ServicesRepoImpl(
          servicesRemoteDataSource: ServicesRemoteDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
      getExpertUpcomingUseCase: GetExpertUpcomingUseCase(
        userActivityRepo: UserActivityRepoImpl(
          userActivityDataSource: UserActivityDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    )..add(LoadFirstTimeUpcomingRequestsEvent());
  }
}
