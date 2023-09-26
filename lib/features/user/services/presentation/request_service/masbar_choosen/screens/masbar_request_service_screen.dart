// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:masbar/core/network/check_internet.dart';
import 'package:masbar/core/ui/widgets/error_widget.dart';
import 'package:masbar/features/auth/accounts/domain/repositories/auth_repo.dart';
import '../../../../../../../core/api_service/network_service_http.dart';
import '../../../../../../../core/ui/widgets/app_button.dart';
import '../../../../../../../core/ui/widgets/app_text.dart';
import '../../../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../../../core/ui/widgets/no_connection_widget.dart';
import '../../../../../../../core/utils/enums/enums.dart';
import '../../../../../../user_emirate/bloc/uae_states_bloc.dart';
import '../../../../../../user_emirate/data/data sources/uae_states_remote_data_source.dart';
import '../../../../../../user_emirate/data/repositories/uae_state_repo_impl.dart';
import '../../../../../../user_emirate/domain/use cases/fetch_uae_states_usecase.dart';
import '../../../../../my_locations/data/data_source/my_locations_data_source.dart';
import '../../../../../my_locations/data/repositories/my_locations_repo_impl.dart';
import '../../../../../my_locations/domain/use_cases/get_saved_locations_use_case.dart';
import '../../../../../my_locations/domain/use_cases/save_location_use_case.dart';
import '../../../../../my_locations/presentation/bloc/get_saved_location_bloc.dart';
import '../../../../../my_locations/presentation/bloc/save_location_bloc.dart';
import '../../../../data/data_source/explore_services_data_source.dart';
import '../../../../data/repositories/explore_services_repo_impl.dart';
import '../../../../domain/entities/service_entity.dart';
import '../../../../domain/use_cases/get_service_info_use_case.dart';
import '../../../../domain/use_cases/submit_request_use_case.dart';
import '../bloc/create_request_bloc.dart';
import '../bloc/service_details_bloc.dart';
import '../widgets/step1/step1.dart';
import '../widgets/step2/step2.dart';
import '../widgets/step3/step3.dart';
import '../widgets/step4/step4.dart';

class MasbarRequestServiceScreen extends StatefulWidget {
  final ServiceEntity serviceEntity;
  static const routeName = 'request_service_screen';
  const MasbarRequestServiceScreen({
    Key? key,
    required this.serviceEntity,
  }) : super(key: key);

  @override
  State<MasbarRequestServiceScreen> createState() => _MasbarRequestServiceScreenState();
}

class _MasbarRequestServiceScreenState extends State<MasbarRequestServiceScreen> {
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
  }

  @override
  Widget build(BuildContext context) {
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
          return BlocListener<ServiceDetailsBloc, ServiceDetailsState>(
            listener: (context, state) {
              if (state is LoadedServiceDetails) {
                _refreshData(context, state);
              }
            },
            child: Scaffold(
              appBar: _buildAppBar(context),
              body: BlocBuilder<ServiceDetailsBloc, ServiceDetailsState>(
                builder: (context, state) {
                  if (state is LoadingServiceDetails) {
                    return const LoadingWidget();
                  } else if (state is ServiceDetailsOfflineState) {
                    return NoConnectionWidget(
                      onPressed: () {
                        BlocProvider.of<ServiceDetailsBloc>(context).add(
                          FetchInfoEvent(
                            serviceId: widget.serviceEntity.id!,
                            stateId: context
                                .read<AuthRepo>()
                                .getUserData()!
                                .stateId!,
                          ),
                        );
                      },
                    );
                  } else if (state is ServiceDetailsErrorState) {
                    return NetworkErrorWidget(
                      message: state.message,
                      onPressed: () {
                      BlocProvider.of<ServiceDetailsBloc>(context).add(
                          FetchInfoEvent(
                          serviceId: widget.serviceEntity.id!,
                          stateId:
                              context.read<AuthRepo>().getUserData()!.stateId!,
                        ));
                      },
                    );
                  } else if (state is LoadedServiceDetails) {
                    return Column(children: <Widget>[
                      _buildIndicator(context),
                      Expanded(
                        child: PageView(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: pageController,
                          children: [
                            Step1(
                              serviceInfoEntity: state.info,
                              changeCurrentTab: _changeCurrentTab,
                            ),
                            Step2(
                              changeCurrentTab: _changeCurrentTab,
                            ),
                            Step3(
                              changeCurrentTab: _changeCurrentTab,
                            ),
                            const Step4(),
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

  void _refreshData(BuildContext context, LoadedServiceDetails state) {
    BlocProvider.of<CreateRequestBloc>(context).add(
      RefreshDataEvent(
          serviceId: widget.serviceEntity.id!,
          servicePaymentType: state.info.paymentStatus!,
          stateId: context.read<AuthRepo>().getUserData()!.stateId!),
    );
  }

  CreateRequestBloc _getCreateRequestBloc() {
    return CreateRequestBloc(
        submitRequestUseCase: SubmitRequestUseCase(
      exploreServicesRepo: ExploreServicesRepoImpl(
        exploreServicesDataSource: ExploreServicesDataSourceWithHttp(
          client: NetworkServiceHttp(),
        ),
      ),
    ));
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

 SaveLocationBloc  _getSaveNewLocation() {
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
          serviceId: widget.serviceEntity.id!,
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
