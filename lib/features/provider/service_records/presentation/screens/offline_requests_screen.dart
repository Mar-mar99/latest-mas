import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../core/api_service/network_service_http.dart';
import '../../../../../core/ui/widgets/error_widget.dart';
import '../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../core/ui/widgets/no_connection_widget.dart';
import '../../../homepage/data/date_source/provider_data_source.dart';
import '../../../homepage/data/repositories/provider_repo_impl.dart';
import '../../../homepage/domain/use_cases/fetch_offline_requests_use_case.dart';
import '../../../homepage/presentation/offline_requests/screens/offline_requests_provider.dart';
import '../../../homepage/presentation/working_state/bloc/fetch_offline_requests_bloc.dart';

class OfflineRequestsScreen extends StatelessWidget {
  const OfflineRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _getOfflineRequestBloc(),
      child:  const Padding(
        padding:EdgeInsets.all(16),
        child: OfflineRequestProvider(isServiceRecord: true),
      ),
    );
  }

  FetchOfflineRequestsBloc _getOfflineRequestBloc() {
    return FetchOfflineRequestsBloc(
        fetchOfflineRequestUseCase: FetchOfflineRequestUseCase(
      providerRepo: ProviderRepoImpl(
        providerDataSource: ProviderDataSourceWithHttp(
          client: NetworkServiceHttp(),
        ),
      ),
    ))
      ..add(GetOfflineRequestsEvent());
  }
}
