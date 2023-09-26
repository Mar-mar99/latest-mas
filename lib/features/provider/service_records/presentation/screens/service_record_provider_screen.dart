import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:masbar/core/api_service/network_service_http.dart';
import 'package:masbar/core/ui/widgets/app_text.dart';
import 'package:masbar/features/provider/service_records/presentation/screens/past_request_provider_screen.dart';
import 'package:masbar/features/provider/service_records/presentation/screens/upcoming_request_provider_screen.dart';

import '../../data/data_source/service_record_provider_data_source.dart';
import '../../data/repositories/service_record_provider_repo_impl.dart';
import '../../domain/use_cases/get_provider_history_use_case.dart';
import '../../domain/use_cases/get_provider_upcoming_use_case.dart';
import '../bloc/get_history_record_provider_bloc.dart';
import '../bloc/get_upcoming_record_provider_bloc.dart';
import 'offline_requests_screen.dart';

class ServiceRecordProviderScreen extends StatelessWidget {
  static const routeName = 'service_record_provider_screen';
  const ServiceRecordProviderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('marrrry');
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _getHistoryBloc(),
        ),
        BlocProvider(
          create: (context) => _getUpcomingBloc(),
        ),
      ],
      child: Builder(builder: (context) {
        return DefaultTabController(
          initialIndex: 0,
          length: 3,
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: Colors.white,
              iconTheme: const IconThemeData(color: Colors.black),
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
                  Tab(
                    child: AppText(
                      'Offline',
                    ),
                  ),
                ],
              ),
            ),
            body: const TabBarView(
              children: <Widget>[
                UpcomingRequestProviderScreen(),
                PastRequestProviderScreen(),
                OfflineRequestsScreen()
              ],
            ),
          ),
        );
      }),
    );
  }

  GetUpcomingRecordProviderBloc _getUpcomingBloc() {
    return GetUpcomingRecordProviderBloc(
            getProviderUpcomingUseCase: GetProviderUpcomingUseCase(
          serviceRecordProviderRepo: ServiceRecordProviderRepoImpl(
            serviceRecordeProviderDataSource:
                ServiceRecordeProviderDataSourceWithHttp(
              client: NetworkServiceHttp(),
            ),
          ),
        ))
          ..add(GetProviderUpcomingtRequestsEvent());
  }

  GetHistoryRecordProviderBloc _getHistoryBloc() {
    return GetHistoryRecordProviderBloc(
          getProviderHistoryUseCase: GetProviderHistoryUseCase(
            serviceRecordProviderRepo: ServiceRecordProviderRepoImpl(
              serviceRecordeProviderDataSource:
                  ServiceRecordeProviderDataSourceWithHttp(
                client: NetworkServiceHttp(),
              ),
            ),
          ),
        )..add(GetProviderPastRequestsEvent());
  }
}
