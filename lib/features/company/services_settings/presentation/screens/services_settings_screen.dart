import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:masbar/features/company/services_settings/presentation/screens/attributes_service_settings.dart';
import 'package:masbar/features/company/services_settings/presentation/screens/providers_settings_screen.dart';
import '../../../../../core/api_service/network_service_http.dart';
import '../../../../../core/ui/widgets/custom_animated_list.dart';
import '../../../../../core/ui/widgets/error_widget.dart';
import '../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../core/ui/widgets/no_connection_widget.dart';
import '../../../company_services/data/data_source/company_services_data_source.dart';
import '../../../company_services/data/repositories/company_services_repo_impl.dart';
import '../../../company_services/domain/entities/company_service_entity.dart';
import '../../../company_services/domain/use_cases/get_company_services_use_case.dart';
import '../../../company_services/presentation/bloc/get_company_sevices_bloc.dart';
import 'cancellation_settings.dart';

class ServicesSettingsScreen extends StatelessWidget {
  static const routeName = 'services_settings_screen';
  ServicesSettingsScreen({super.key});
  final GlobalKey<AnimatedListState> _keyList = GlobalKey<AnimatedListState>();
   List<Widget> _animatedItems = [];
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _getCompanyServicesBloc(),
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.servicesSettingsLabel,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: BlocBuilder<GetCompanySevicesBloc, GetCompanySevicesState>(
              builder: (context, state) {
                if (state is LoadingGetCompanySevices) {
                  return _buildLoadingState();
                } else if (state is GetCompanySevicesOfflineState) {
                  return _buildNoConnectionState(context);
                } else if (state is GetCompanySevicesErrorState) {
                  return _buildNetworkErrorState(state, context);
                } else if (state is LoadedGetCompanySevices) {
                  return _buildBodyState(state);
                } else {
                  return Container();
                }
              },
            ),
          )),
    );
  }

  GetCompanySevicesBloc _getCompanyServicesBloc() {
    return GetCompanySevicesBloc(
      getCompanyServicesUseCase: GetCompanyServicesUseCase(
        companyServicesRepo: CompanyServicesRepoImpl(
          companyServicesDataSource: CompanyServicesDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    )..add(GetCompanyServices());
  }

  Widget _buildBodyState(LoadedGetCompanySevices state) {
    return ListView.separated(
      itemCount: state.data.length,
      separatorBuilder: (context, index) {
        return const Divider(
          height: 16,
        );
      },
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (dialogContext) {
                return Dialog(
                    child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Text(AppLocalizations.of(context)!.service_name_label(state.data[index].name)),
                      Text(
                        '${ AppLocalizations.of(context)!.choose_what_you_want_to_do}:',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      _buildAnimatedList(context, state.data[index]),
                    ],
                  ),
                ));
              },
            );
          },
          child: ListTile(
            title: Text('${state.data[index].name}'),
            trailing:const Icon(
              Icons.arrow_forward_ios,
              color: Colors.blue,
            ),
          ),
        );
      },
    );
  }

  ElevatedButton _buildAttributesBtn(
      BuildContext context, CompanyServiceEntity company) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
        Navigator.pushNamed(
          context,
          AttributesServiceSettings.routeName,
          arguments: {
            'companyService': company,
          },
        );
      },
      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
      child: Text(
      AppLocalizations.of(context)!.attributes,
        maxLines: 1,
        style:const TextStyle(
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  ElevatedButton _buildProvidersBtn(
      BuildContext context, CompanyServiceEntity company) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
        Navigator.pushNamed(
          context,
          AssignProviderToServiceScreen.routeName,
          arguments: {
            'companyService': company,
          },
        );
      },
      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
      child: Text(AppLocalizations.of(context)!.providers,
          maxLines: 1, style: const TextStyle(overflow: TextOverflow.ellipsis)),
    );
  }

  ElevatedButton _buildCancelSettingsBtn(BuildContext context,CompanyServiceEntity company) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, CancelationSettings.routeName,
         arguments: {
            'companyService': company,
          },);
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor),
      child: Text(AppLocalizations.of(context)!.cancelation_settings,
          maxLines: 1, style:const TextStyle(overflow: TextOverflow.ellipsis)),
    );
  }

  Widget _buildAnimatedList(
      BuildContext context, CompanyServiceEntity company) {
    List<Widget> buttons = [
      _buildAttributesBtn(context, company),
      _buildProvidersBtn(context, company),
      _buildCancelSettingsBtn(context,company),
    ];

    _addAnimatedBtns(buttons);
    return CustomAnimatedList(
      itemsWidgets: _animatedItems,
      keyList: _keyList,
      offset: Tween(
        begin: const Offset(1, 0),
        end: const Offset(0, 0),
      ),
    );
  }

  void _addAnimatedBtns(List<Widget> items) {
    _animatedItems=[];
    Future ft = Future((() {}));
    for (int i = 0; i < items.length; i++) {
      ft = ft.then((_) {
        return Future.delayed(
          const Duration(milliseconds: 300),
          () {
            _animatedItems.add(items[i]);
            _keyList.currentState!.insertItem(_animatedItems.length - 1);
          },
        );
      });
    }
  }

  NetworkErrorWidget _buildNetworkErrorState(
      GetCompanySevicesErrorState state, BuildContext context) {
    return NetworkErrorWidget(
      message: state.message,
      onPressed: () {
        BlocProvider.of<GetCompanySevicesBloc>(context)
            .add(GetCompanyServices());
      },
    );
  }

  NoConnectionWidget _buildNoConnectionState(BuildContext context) {
    return NoConnectionWidget(
      onPressed: () {
        BlocProvider.of<GetCompanySevicesBloc>(context)
            .add(GetCompanyServices());
      },
    );
  }

  LoadingWidget _buildLoadingState() {
    return const LoadingWidget();
  }
}
