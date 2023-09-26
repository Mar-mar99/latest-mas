import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
import '../../../data/data_source/offers_data_source.dart';
import '../../../data/repositories/offers_repo_impl.dart';
import '../../../domain/entities/offer_provider_entity.dart';
import '../../../domain/use_cases/create_request_promo_use_case.dart';
import '../bloc/request_offer_bloc.dart';
import '../widgets/offer_step1/offer_step1.dart';
import '../widgets/offer_step2/offer_step2.dart';
import '../widgets/offer_step3/offer_step3.dart';
import '../widgets/offer_step4/offer_step4.dart';

class RequestOfferScreen extends StatefulWidget {
  final int serviceId;
  final OfferProviderEntity provider;

  static const routeName = 'request_offer_screen';
  const RequestOfferScreen(
      {Key? key, required this.serviceId, required this.provider})
      : super(key: key);

  @override
  State<RequestOfferScreen> createState() => _RequestOfferScreenState();
}

class _RequestOfferScreenState extends State<RequestOfferScreen> {
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
    print('cancel fee ${widget.provider.cancellationFee}');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.provider.cancellationFee != '0') {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) {
            return CancellationFee(
              amount: widget.provider.cancellationFee,
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
    });
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
              BlocListener<RequestOfferBloc, RequestOfferState>(
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
                            OfferStep1(
                              provider: widget.provider,
                              serviceInfoEntity: state.info,
                              changeCurrentTab: _changeCurrentTab,
                            ),
                            OfferStep2(
                              changeCurrentTab: _changeCurrentTab,
                            ),
                            OfferStep3(
                              changeCurrentTab: _changeCurrentTab,
                            ),
                            OfferStep4(),
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
    BlocProvider.of<RequestOfferBloc>(context).add(
      RefreshDataEvent(
        serviceId: widget.serviceId,
        servicePaymentType: state.info.paymentStatus!,
        stateId: context.read<AuthRepo>().getUserData()!.stateId!,
      ),
    );
  }

  RequestOfferBloc _getCreateRequestBloc() {
    return RequestOfferBloc(
        createRequestPromoUseCase: CreateRequestPromoUseCase(
      offersRepo: OffersRepoImpl(
        offersDataSource: OffersDataSourceWithHttp(
          client: NetworkServiceHttp(),
        ),
      ),
    ))
      ..add(
        ProviderIdChangedEvent(
          id: widget.provider.id,
        ),
      )
      ..add(
        PromoCodeChangedEvent(
          promoCode: widget.provider.promoCodeId,
        ),
      );
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
