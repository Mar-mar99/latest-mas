// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:masbar/features/user/favorites/domain/use_cases/create_fav_request_use_case.dart';
import 'package:masbar/features/user/favorites/presentation/request_fav/widgets/fav_step1/fav_step1.dart';

import '../../../../../../core/api_service/network_service_http.dart';
import '../../../../../../core/network/check_internet.dart';
import '../../../../../../core/ui/dialogs/cancellation_fee_dialog.dart';
import '../../../../../../core/ui/widgets/error_widget.dart';
import '../../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../../core/ui/widgets/no_connection_widget.dart';
import '../../../../../auth/accounts/domain/repositories/auth_repo.dart';
import '../../../../../user_emirate/bloc/uae_states_bloc.dart';
import '../../../../../user_emirate/data/data sources/uae_states_remote_data_source.dart';
import '../../../../../user_emirate/data/repositories/uae_state_repo_impl.dart';
import '../../../../../user_emirate/domain/use cases/fetch_uae_states_usecase.dart';
import '../../../../my_locations/data/data_source/my_locations_data_source.dart';
import '../../../../my_locations/data/repositories/my_locations_repo_impl.dart';
import '../../../../my_locations/domain/use_cases/get_saved_locations_use_case.dart';
import '../../../../my_locations/domain/use_cases/save_location_use_case.dart';
import '../../../../my_locations/presentation/bloc/get_saved_location_bloc.dart';
import '../../../../my_locations/presentation/bloc/save_location_bloc.dart';
import '../../../../services/data/data_source/explore_services_data_source.dart';
import '../../../../services/data/repositories/explore_services_repo_impl.dart';
import '../../../../services/domain/use_cases/get_service_info_use_case.dart';
import '../../../../services/presentation/request_service/masbar_choosen/bloc/service_details_bloc.dart';
import '../../../data/data_source/favorite_data_source.dart';
import '../../../data/repositories/favorites_repo_impl.dart';
import '../bloc/request_fav_provider_bloc.dart';
import '../widgets/fav_step2/fav_step2.dart';
import '../widgets/fav_step3/fav_step3.dart';
import '../widgets/fav_step4/fav_step4.dart';

class RequestFavProviderScreen extends StatefulWidget {
  final int serviceId;
  final int providerId;
  final dynamic cancellationFee;
  static const routeName = 'request_fav_provider_screen';
  const RequestFavProviderScreen({
    Key? key,
    required this.serviceId,
    required this.providerId,
    required this.cancellationFee,
  }) : super(key: key);

  @override
  State<RequestFavProviderScreen> createState() =>
      _RequestFavProviderScreenState();
}

class _RequestFavProviderScreenState extends State<RequestFavProviderScreen> {
  var currentIndex = 0;
  late PageController pageController;

  _changeCurrentTab(int tab) async {
    setState(() {
      currentIndex = tab;
    });

    pageController.animateToPage(
      tab,
      duration: const Duration(seconds: 1),
      curve: Curves.easeIn,
    );
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    print('cancel fee ${widget.cancellationFee}');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.cancellationFee != '0') {
        _showFeeDialog();
      }
    });
  }

  void _showFeeDialog() {
     showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return CancellationFee(
          amount: widget.cancellationFee,
          cancelHandler: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          okHandler: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('the width ${MediaQuery.of(context).size.width}');
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _getServiceInfoBloc(context),
        ),
        BlocProvider(
          create: (context) => _getUAEStatesBloc(),
        ),
        BlocProvider(
          create: (context) => _getCreateRequestBloc(),
        ),
        BlocProvider(
          create: (context) => _getSavedLocation(),
        ),
        BlocProvider(
          create: (context) => _getSaveNewLocation(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return MultiBlocListener(
            listeners: [
              BlocListener<ServiceDetailsBloc, ServiceDetailsState>(
                listener: (context, state) {
                  if (state is LoadedServiceDetails) {
                    _refreshData(context, state);
                  }
                },
              ),
              BlocListener<RequestFavProviderBloc, RequestFavProviderState>(
                listener: (context, state) {},
              ),
            ],
            child: Scaffold(
              appBar: _buildAppBar(context),
              body: BlocBuilder<ServiceDetailsBloc, ServiceDetailsState>(
                builder: (context, state) {
                  if (state is LoadingServiceDetails) {
                    return _buildLoading();
                  } else if (state is ServiceDetailsOfflineState) {
                    return _buildNoConnection(context);
                  } else if (state is ServiceDetailsErrorState) {
                    return _buildNetworkError(state, context);
                  } else if (state is LoadedServiceDetails) {
                    return Column(children: <Widget>[
                      _buildIndicator(context),
                      Expanded(
                        child: PageView(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: pageController,
                          children: [
                            FavStep1(
                              serviceInfoEntity: state.info,
                              changeCurrentTab: _changeCurrentTab,
                            ),
                            FavStep2(
                              changeCurrentTab: _changeCurrentTab,
                            ),
                            FavStep3(
                              changeCurrentTab: _changeCurrentTab,
                            ),
                            FavStep4(),
                          ],
                        ),
                      )
                    ]);
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }

  NetworkErrorWidget _buildNetworkError(
      ServiceDetailsErrorState state, BuildContext context) {
    return NetworkErrorWidget(
      message: state.message,
      onPressed: () {
        BlocProvider.of<ServiceDetailsBloc>(context).add(FetchInfoEvent(
          serviceId: widget.serviceId,
          stateId: context.read<AuthRepo>().getUserData()!.stateId!,
        ));
      },
    );
  }

  NoConnectionWidget _buildNoConnection(BuildContext context) {
    return NoConnectionWidget(
      onPressed: () {
        BlocProvider.of<ServiceDetailsBloc>(context).add(
          FetchInfoEvent(
            serviceId: widget.serviceId,
            stateId: context.read<AuthRepo>().getUserData()!.stateId!,
          ),
        );
      },
    );
  }

  LoadingWidget _buildLoading() {
    return const LoadingWidget();
  }

  void _refreshData(BuildContext context, LoadedServiceDetails state) {
    BlocProvider.of<RequestFavProviderBloc>(context).add(
      RefreshDataEvent(
        serviceId: widget.serviceId,
        servicePaymentType: state.info.paymentStatus!,
        stateId: context.read<AuthRepo>().getUserData()!.stateId!,
      ),
    );
  }

  RequestFavProviderBloc _getCreateRequestBloc() {
    return RequestFavProviderBloc(
        createFavRequestUseCase: CreateFavRequestUseCase(
      favoritesRepo: FavoritesRepoImpl(
        favoritesDataSource: FavoritesDataSourceWithHttp(
          client: NetworkServiceHttp(),
        ),
      ),
    ))
      ..add(ProviderIdChangedEvent(id: widget.providerId));
  }

  GetSavedLocationBloc _getSavedLocation() {
    return GetSavedLocationBloc(
      getSavedLocationsUseCase: GetSavedLocationsUseCase(
        myLocationsRepo: MyLocationsRepoImpl(
          myLocationDataSource: MyLocationsDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    )..add(GetLocations());
  }

  SaveLocationBloc _getSaveNewLocation() {
    return SaveLocationBloc(
      saveLocationUseCase: SaveLocationUseCase(
        myLocationsRepo: MyLocationsRepoImpl(
          myLocationDataSource: MyLocationsDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    );
  }

  UaeStatesBloc _getUAEStatesBloc() {
    return UaeStatesBloc(
      fetchUaeStatesUseCase: FetchUaeStatesUseCase(
        uaeStatesRepo: UAEStatesRepoImpl(
          uaeStatesRemoteDataSource:
              UAEStatesDataSourceWithHttp(client: Client()),
          networkInfo: NetworkInfoImpl(
            internetConnectionChecker: InternetConnectionChecker(),
          ),
        ),
      ),
    )..add(FetchUaeStatesEvent());
  }

  ServiceDetailsBloc _getServiceInfoBloc(BuildContext context) {
    return ServiceDetailsBloc(
      getServiceInfoUseCase: GetServiceInfoUseCase(
        exploreServicesRepo: ExploreServicesRepoImpl(
          exploreServicesDataSource: ExploreServicesDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    )..add(
        FetchInfoEvent(
          serviceId: widget.serviceId,
          stateId: context.read<AuthRepo>().getUserData()!.stateId!,
        ),
      );
  }

  Container _buildIndicator(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 5.0,
      child: Row(
        children: List.generate(
          4,
          (int index) {
            return Expanded(
              child: AnimatedContainer(
                height: 18.0,
                duration: const Duration(milliseconds: 100),
                decoration: BoxDecoration(
                    border: Border(
                        right: BorderSide(
                      color: Colors.grey[200]!,
                      width: 2.0,
                    )),
                    color: index <= currentIndex
                        ? Theme.of(context).primaryColor
                        : Colors.white),
              ),
            );
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        AppLocalizations.of(context)!.requestAServiceLabel,
        style: const TextStyle(color: Colors.black),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black),
      leading: IconButton(
        onPressed: () {
          if (currentIndex == 0) {
            Navigator.pop(context);
          } else {
            _changeCurrentTab(currentIndex - 1);
          }
        },
        icon: Icon(
          (currentIndex == 0) ? EvaIcons.close : EvaIcons.arrowBack,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
