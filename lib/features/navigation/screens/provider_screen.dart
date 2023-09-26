import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:masbar/core/utils/extensions/navigation_extension.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:masbar/features/notification/presentation/screens/notification_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/api_service/network_service_http.dart';
import '../../../core/ui/widgets/error_widget.dart';
import '../../../core/ui/widgets/loading_widget.dart';
import '../../../core/ui/widgets/no_connection_widget.dart';
import '../../../core/utils/enums/enums.dart';
import '../../../core/utils/enums/navigation_enums.dart';
import '../../../core/utils/helpers/permission_location_request.dart';
import '../../provider/homepage/data/date_source/provider_data_source.dart';
import '../../provider/homepage/data/repositories/provider_repo_impl.dart';
import '../../provider/homepage/domain/use_cases/get_current_request_use_case.dart';
import '../../provider/homepage/presentation/active_request/bloc/current_request_bloc.dart';
import '../../provider/homepage/presentation/active_request/screens/active_request_screen.dart';
import '../../provider/homepage/presentation/working_state/bloc/submit_location_provider_bloc.dart';
import '../../provider/homepage/presentation/working_state/screens/homepage_provider_screen.dart';
import '../../provider/homepage/presentation/working_state/screens/provider_working_screen.dart';
import '../../provider/profile/presentation/screens/profile_provider_screen.dart';
import '../cubit/company_navigation_cubit.dart';
import '../cubit/provider_navigation_cubit.dart';

class ProviderScreen extends StatefulWidget {
  static const routeName = 'provider_screen';
  const ProviderScreen({super.key});

  @override
  State<ProviderScreen> createState() => _ProviderScreenState();
}

class _ProviderScreenState extends State<ProviderScreen> {
  GetCurrentRequestUseCase getCurrentRequestUseCase = GetCurrentRequestUseCase(
    providerRepo: ProviderRepoImpl(
      providerDataSource: ProviderDataSourceWithHttp(
        client: NetworkServiceHttp(),
      ),
    ),
  );

  int? oldRequestId;
  Stream<int?> getData() async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 2));
      final res = await getCurrentRequestUseCase();
      yield res.fold(
        (l) {
          return oldRequestId;
        },
        (data) {
          if (data == null) {
            return oldRequestId;
          } else {
            oldRequestId = data.id;
            return data.id;
          }
        },
      );
    }
  }

  late Stream<int?> dataStream;
  @override
  void initState() {
    super.initState();
    dataStream = getData();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      PermissionStatus status = await requestLocationPermission(
        context,
        TypeAuth.provider,
      );
      if (status == PermissionStatus.granted) {
        print('starting submiting location');
        BlocProvider.of<SubmitLocationProviderBloc>(context)
            .add(StartSubmittingLocation());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _getCurrentBloc(),
      child: Builder(builder: (context) {
        return StreamBuilder<int?>(
          stream: dataStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return _buildBodyWithBottomNavigation(context);
            } else if (snapshot.hasData) {
              return ActiveRequestScreen(
                requestId: snapshot.data!,
              );
            } else {
              return _buildLoading();
            }
          },
        );
      }),
    );
  }




  Widget _buildLoading() {
    return Scaffold(body: SafeArea(child: LoadingWidget()));
  }

  Scaffold _buildBodyWithBottomNavigation(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildTitle(context),
      ),
      bottomNavigationBar: _buildBottomBar(),
      body: SafeArea(child: _buildBody()),
    );
  }

  CurrentRequestBloc _getCurrentBloc() {
    return CurrentRequestBloc(
        getCurrentRequestUseCase: GetCurrentRequestUseCase(
      providerRepo: ProviderRepoImpl(
        providerDataSource: ProviderDataSourceWithHttp(
          client: NetworkServiceHttp(),
        ),
      ),
    ))
      ..add(GetCurrentRequestEvent());
  }

  Widget _buildTitle(BuildContext context) {
    return BlocBuilder<ProviderNavigationCubit, ProviderNavigationState>(
        builder: (context, state) {
      return Text(state.navigationProvider.getText(context));
    });
  }

  Widget _buildBottomBar() {
    return BlocBuilder<ProviderNavigationCubit, ProviderNavigationState>(
        builder: (context, state) {
      return BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        selectedItemColor: Theme.of(context).primaryColor,
        currentIndex: state.index,
        onTap: (value) {
          BlocProvider.of<ProviderNavigationCubit>(context)
              .getItem(NavigationProvider.values[value]);
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Boxicons.bx_home_circle),
            label: AppLocalizations.of(context)?.home ?? "",
          ),
          BottomNavigationBarItem(
            icon: const Icon(Boxicons.bx_bell),
            label: AppLocalizations.of(context)?.notifications ?? "",
          ),
          BottomNavigationBarItem(
            icon: const Icon(Boxicons.bx_user),
            label: AppLocalizations.of(context)?.account ?? "",
          ),
        ],
      );
    });
  }

  Widget _buildBody() {
    return BlocBuilder<ProviderNavigationCubit, ProviderNavigationState>(
      builder: (context, state) {
        if (state.navigationProvider == NavigationProvider.homepage) {
          return ProviderWorkingScreen();
        } else if (state.navigationProvider ==
            NavigationProvider.notification) {
          return const NotificationScreen(
            typeAuth: TypeAuth.provider,
          );
        } else if (state.navigationProvider == NavigationProvider.account) {
          return const ProfileProviderScreen();
        } else {
          return Container();
        }
      },
    );
  }
}
