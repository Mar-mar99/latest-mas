import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:masbar/features/provider/homepage/data/date_source/provider_data_source.dart';
import 'package:masbar/features/provider/homepage/data/repositories/provider_repo_impl.dart';

import '../auth/accounts/data/data%20sources/user_remote_data_source.dart';
import '../auth/accounts/data/repositories/user_repo_impl.dart';

import '../../config/routes/app_router.dart';
import '../../core/api_service/network_service_http.dart';
import '../../core/managers/theme_manager.dart';
import '../../core/network/check_internet.dart';
import '../auth/accounts/domain/repositories/auth_repo.dart';
import '../auth/accounts/domain/use cases/get_user_data_usecase.dart';
import '../auth/accounts/domain/use cases/logout_use_case.dart';
import '../auth/accounts/presentation/bloc/authentication_bloc.dart';
import '../auth/accounts/presentation/bloc/log_out_bloc.dart';
import '../delete_account/data/data_source/delete_account_data_source.dart';
import '../delete_account/data/repositories/delete_account_repo_impl.dart';
import '../delete_account/domain/use_cases/delete_account_use_case.dart';
import '../delete_account/presentation/bloc/delete_account_bloc.dart';

import '../localization/cubit/lacalization_cubit.dart';
import '../localization/localize_app_impl.dart';
import '../navigation/cubit/company_navigation_cubit.dart';
import '../navigation/cubit/provider_navigation_cubit.dart';
import '../navigation/cubit/user_navigation_cubit.dart';
import '../notification/data/data_source/notification_data_source.dart';
import '../notification/data/repositories/notification_repo_impl.dart';
import '../notification/domain/use_case/get_notification_use_case.dart';
import '../notification/presentation/bloc/notification_bloc.dart';
import '../provider/homepage/domain/use_cases/submit_provider_location_use_case.dart';
import '../provider/homepage/presentation/working_state/bloc/submit_location_provider_bloc.dart';
import '../splash_screen/splash_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  final AppRouter appRouter;
  final AuthRepo authRepo;
  const MyApp({
    Key? key,
    required this.appRouter,
    required this.authRepo,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LacalizationCubit(
            LocalizeAppImpl(),
          )..getSavedLanguage(),
        ),
        RepositoryProvider(
          create: (context) => widget.authRepo,
        ),
        BlocProvider(
          create: (context) => UserNavigationCubit(),
        ),
        BlocProvider(
          create: (context) => ProviderNavigationCubit(),
        ),
        BlocProvider(
          create: (context) => CompanyNavigationCubit(),
        ),
        BlocProvider(
          create: (context) => _getAuthenticationBloc(),
        ),
        BlocProvider(
          create: (context) => _getLogOutBloc(),
        ),
        BlocProvider(
          create: (context) => _getDeleteAccountBloc(),
        ),
        BlocProvider(
          create: (context) => _getNotificationBloc(),
        ),
        BlocProvider(
          create: (context) => _getSubmitProviderLocationBloc(),
        )
      ],
      child: BlocBuilder<LacalizationCubit, LacalizationState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Masbar',
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: state.locale,
            darkTheme: darkTheme,
            theme: lightTheme,
            initialRoute: SplashScreen.routeName,
            onGenerateRoute: widget.appRouter.onGenerateRoute,
          );
        },
      ),
    );
  }

  AuthenticationBloc _getAuthenticationBloc() {
    return AuthenticationBloc(
        authRepository: widget.authRepo,
        submitProviderLocationUseCase: SubmitProviderLocationUseCaase(
          providerRepo: ProviderRepoImpl(
            providerDataSource: ProviderDataSourceWithHttp(
              client: NetworkServiceHttp(),
            ),
          ),
        ),
        getUserDataUseCase: GetUserDataUseCase(
          userRepo: UserRepoImpl(
            userRemoteDataSource:
                UserRemoteDataSourceWithHttp(client: NetworkServiceHttp()),
          ),
        ));
  }

  DeleteAccountBloc _getDeleteAccountBloc() {
    return DeleteAccountBloc(
        deleteAccountUseCase: DeleteAccountUseCase(
      deleteAccountRepo: DeleteAccountRepoImpl(
        deleteAccountDataSource:
            DeleteAccountDataSourceWithHttp(client: NetworkServiceHttp()),
        networkInfo: NetworkInfoImpl(
          internetConnectionChecker: InternetConnectionChecker(),
        ),
      ),
    ));
  }

  NotificationBloc _getNotificationBloc() {
    return NotificationBloc(
      getNotificationUseCase: GetNotificationUseCase(
        notificationRepo: NotificationRepoImpl(
          notificationDataSource: NotificationDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    );
  }

  SubmitLocationProviderBloc _getSubmitProviderLocationBloc() {
    return SubmitLocationProviderBloc(
      submitProviderLocation: SubmitProviderLocationUseCaase(
        providerRepo: ProviderRepoImpl(
          providerDataSource: ProviderDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    );
  }

  LogOutBloc _getLogOutBloc() {
    return LogOutBloc(
      logOutUseCase: LogOutUseCase(
        userRepo: UserRepoImpl(
          userRemoteDataSource: UserRemoteDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    );
  }
}
