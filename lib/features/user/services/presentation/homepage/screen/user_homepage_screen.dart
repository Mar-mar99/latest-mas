import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masbar/core/api_service/network_service_http.dart';
import 'package:masbar/core/ui/widgets/loading_widget.dart';
import 'package:masbar/features/user/services/data/data_source/explore_services_data_source.dart';
import 'package:masbar/features/user/services/data/repositories/explore_services_repo_impl.dart';
import 'package:masbar/features/user/services/presentation/explore/screens/explore_services_screen.dart';
import 'package:masbar/features/user/services/presentation/service_details.dart/screen/service_details_screen.dart';

import '../../../domain/use_cases/check_for_active_request_use_case.dart';
import '../../explore/screens/explore_categories_screen.dart';
import '../bloc/check_for_service_bloc.dart';

class UserHomepageScreen extends StatelessWidget {
  final bool? showExplorePage;

  const UserHomepageScreen({
    super.key,
    this.showExplorePage,
  });

  @override
  Widget build(BuildContext context) {
    return showExplorePage != null
        ? const ExploreCategoriesScreen()
        : BlocProvider(
            create: (context) => _getCheckBloc(),
            child: Builder(builder: (context) {
              return BlocBuilder<CheckForServiceBloc, CheckForServiceState>(
                builder: (context, state) {
                  if (state is LoadingCheckServiceState) {
                    return const LoadingWidget();
                  } else if (state is ActiveServiceState) {
                    return ServiceDetailsScreen(requestId: state.id);
                  } else if (state is NoActiveServiceState) {
                    // return const ExploreServicesScreen();
                    return ExploreCategoriesScreen();
                  } else {
                    return Container();
                  }
                },
              );
            }),
          );
  }

  CheckForServiceBloc _getCheckBloc() {
    return CheckForServiceBloc(
      checkForActiveRequestUseCase: CheckForActiveRequestUseCase(
        exploreServicesRepo: ExploreServicesRepoImpl(
          exploreServicesDataSource: ExploreServicesDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    )..add(CheckEvent());
  }
}
