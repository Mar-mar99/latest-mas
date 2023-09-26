import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masbar/core/api_service/network_service_http.dart';
import 'package:masbar/core/ui/dialogs/loading_dialog.dart';
import 'package:masbar/core/ui/widgets/app_drop_down.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:masbar/core/ui/widgets/loading_widget.dart';
import 'package:masbar/core/ui/widgets/no_connection_widget.dart';
import 'package:masbar/core/utils/helpers/toast_utils.dart';
import 'package:masbar/features/company/company_services/data/data_source/company_services_data_source.dart';
import 'package:masbar/features/company/services_prices/domain/use_cases/get_prices_use_case.dart';
import 'package:masbar/features/company/services_prices/domain/use_cases/update_price_use_case.dart';
import '../../../../../core/ui/widgets/error_widget.dart';
import '../../../company_services/data/repositories/company_services_repo_impl.dart';
import '../../../company_services/domain/entities/company_service_entity.dart';
import '../../../company_services/domain/use_cases/get_company_services_use_case.dart';
import '../../data/data_source/service_prices_data_source.dart';
import '../../data/repositories/services_prices_repo_impl.dart';

import '../../domain/entities/services_prices_entity.dart';
import '../widgets/prices_table.dart';
import '../bloc/get_prices_bloc.dart';
import '../bloc/update_prices_bloc.dart';

class ServicesPricesScreen extends StatefulWidget {
  static const routeName = 'services_prices_screen';
  const ServicesPricesScreen({super.key});

  @override
  State<ServicesPricesScreen> createState() => _ServicesPricesScreenState();
}

class _ServicesPricesScreenState extends State<ServicesPricesScreen> {
  CompanyServiceEntity? selectedService;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _getPricesBloc(),
        ),
        BlocProvider(
          create: (context) => _getUpdateBloc(),
        ),
      ],
      child: Builder(builder: (context) {
        return BlocListener<UpdatePricesBloc, UpdatePricesState>(
          listener: (context, state) {
            _buildListener(state, context);
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.servicesPricesLabel),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: BlocBuilder<GetPricesBloc, GetPricesState>(
                  builder: (context, state) {
                    if (state.status == GetPricesStatus.loadingForServices) {
                      return LoadingWidget();
                    } else if (state.status == GetPricesStatus.offline) {
                      return NoConnectionWidget(onPressed: () {
                        BlocProvider.of<GetPricesBloc>(context)
                            .add(GetServicesAndPricesPricesEvent());
                      });
                    } else if (state.status == GetPricesStatus.error) {
                      return NetworkErrorWidget(
                          message: state.errorMessage,
                          onPressed: () {
                            BlocProvider.of<GetPricesBloc>(context)
                                .add(GetServicesAndPricesPricesEvent());
                          });
                    } else if (state.status ==
                        GetPricesStatus.loadingForPrices) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildSelectService(context),
                          const SizedBox(
                            height: 4,
                          ),
                          _buildDropDown(state.services, context),
                          const SizedBox(
                            height: 16,
                          ),
                          const LoadingWidget()
                        ],
                      );
                    } else if (state.status == GetPricesStatus.loaded) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildSelectService(context),
                          const SizedBox(
                            height: 4,
                          ),
                          _buildDropDown(state.services, context),
                          const SizedBox(
                            height: 16,
                          ),
                          _buildTable(state.prices, state.selectedService)
                        ],
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  void _buildListener(UpdatePricesState state, BuildContext context) {
    if (state is LoadingUpdatePrices) {
      showLoadingDialog(context, text: 'Updating...');
    } else if (state is UpdatePricesOfflineState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage('No internet connection');
    } else if (state is UpdatePricesErrorState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage(
          'An error has happened, ${state.message} try again');
    } else if (state is LoadedUpdatePrices) {
      Navigator.pop(context);
      ToastUtils.showSusToastMessage('Updated Successfully');
      BlocProvider.of<GetPricesBloc>(context).add(
        LoadPricesEvent(companyServiceEntity: selectedService),
      );
    }
  }

  GetPricesBloc _getPricesBloc() {
    return GetPricesBloc(
      getCompanyServicesUseCase: GetCompanyServicesUseCase(
        companyServicesRepo: CompanyServicesRepoImpl(
          companyServicesDataSource: CompanyServicesDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
      getPricesUseCase: GetPricesUseCase(
        servicesPricesRepo: ServicesPricesRepoImpl(
          servicePricesDataSource: ServicePricesDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    )..add(GetServicesAndPricesPricesEvent());
  }

  UpdatePricesBloc _getUpdateBloc() {
    return UpdatePricesBloc(
        updatePriceUseCase: UpdatePriceUseCase(
      servicesPricesRepo: ServicesPricesRepoImpl(
        servicePricesDataSource: ServicePricesDataSourceWithHttp(
          client: NetworkServiceHttp(),
        ),
      ),
    ));
  }

  Text _buildSelectService(BuildContext context) {
    return Text(
      AppLocalizations.of(context)!.select_service,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  SingleChildScrollView _buildTable(
      List<ServicePriceEntity> prices, CompanyServiceEntity selected) {
    final tableWidget = PricesTable(
      prices: prices,
      serviceEntity: selected,
    );
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: tableWidget,
    );
  }

  AppDropDown<CompanyServiceEntity> _buildDropDown(
      List<CompanyServiceEntity> services, BuildContext context) {
    return AppDropDown<CompanyServiceEntity>(
        hintText: '',
        items: services
            .map((e) => _buildServicesDropMenuItem(context, e))
            .toList(),
        initSelectedValue: services[0],
        onChanged: (value) {
          setState(() {
            selectedService = value;
          });

          BlocProvider.of<GetPricesBloc>(context).add(
            LoadPricesEvent(companyServiceEntity: value),
          );
        });
  }

  DropdownMenuItem<CompanyServiceEntity> _buildServicesDropMenuItem(
      BuildContext context, CompanyServiceEntity e) {
    return DropdownMenuItem<CompanyServiceEntity>(
      value: e,
      child: Text(
        e.name,
      ),
    );
  }
}
