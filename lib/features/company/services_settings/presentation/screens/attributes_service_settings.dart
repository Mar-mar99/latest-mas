// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:masbar/core/api_service/network_service_http.dart';
import 'package:masbar/core/utils/helpers/toast_utils.dart';
import 'package:masbar/features/company/services_settings/data/data_sources/services_remote_data_source.dart';
import 'package:masbar/features/company/services_settings/data/repositories/services_repo_impl.dart';
import 'package:masbar/features/company/services_settings/domain/entities/company_provider_entity.dart';
import 'package:masbar/features/company/services_settings/domain/use_cases/get_providers_use_case.dart';

import '../../../../../core/ui/widgets/app_button.dart';
import '../../../../../core/ui/widgets/app_drop_down.dart';
import '../../../../../core/ui/widgets/error_widget.dart';
import '../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../core/ui/widgets/no_connection_widget.dart';

import '../../../company_services/domain/entities/company_service_entity.dart';
import '../../domain/entities/service_attribute_entity.dart';
import '../../domain/use_cases/get_attributes_use_case.dart';
import '../../domain/use_cases/save_attributes_use_case.dart';
import '../bloc/get_attributes_bloc.dart';
import '../bloc/save_attributes_bloc.dart';
import '../bloc/services_providers_info_bloc.dart';

class AttributesServiceSettings extends StatelessWidget {
  final CompanyServiceEntity companyServiceEntity;
  static const routeName = 'attributes_service_settings';
  const AttributesServiceSettings({
    Key? key,
    required this.companyServiceEntity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        _getProviderBloc(),
        _getAttributesBloc(),
        _getSaveAttributesBloc()
      ],
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.servicesSettingsLabel,
            ),
          ),
          body: BlocListener<SaveAttributesBloc, SaveAttributesState>(
            listener: (context, state) {
              _buildSavedListener(state);
            },
            child: BlocBuilder<ServicesProvidersInfoBloc,
                ServicesProvidersInfoState>(
              builder: (context, state) {
                if (state is LoadingServicesProvidersInfoState) {
                  return _buildLoadingState();
                } else if (state is ServicesProvidersInfoOfflineState) {
                  return _buildNoConnectionState(context);
                } else if (state is ServicesProvidersInfoNetworkErrorState) {
                  return _buildNetworkErrorState(state, context);
                } else if (state is LoadedServicesProvidersInfoState) {
                  return _buildBodyState(state);
                } else {
                  return Container();
                }
              },
            ),
          ),
        );
      }),
    );
  }

  BlocProvider<SaveAttributesBloc> _getSaveAttributesBloc() {
    return BlocProvider(
      create: (context) => SaveAttributesBloc(
        saveAttributesUseCase: SaveAttributesUseCase(
          servicesRepo: ServicesRepoImpl(
            servicesRemoteDataSource:
                ServicesRemoteDataSourceWithHttp(client: NetworkServiceHttp()),
          ),
        ),
      ),
    );
  }

  BlocProvider<GetAttributesBloc> _getAttributesBloc() {
    return BlocProvider(
      create: (context) => GetAttributesBloc(
        getAttributesUseCase: GetAttributesUseCase(
          servicesRepo: ServicesRepoImpl(
            servicesRemoteDataSource:
                ServicesRemoteDataSourceWithHttp(client: NetworkServiceHttp()),
          ),
        ),
      ),
    );
  }

  BlocProvider<ServicesProvidersInfoBloc> _getProviderBloc() {
    return BlocProvider(
      create: (context) => ServicesProvidersInfoBloc(
        getProvidersUseCase: GetProvidersUseCase(
          servicesRepo: ServicesRepoImpl(
            servicesRemoteDataSource:
                ServicesRemoteDataSourceWithHttp(client: NetworkServiceHttp()),
          ),
        ),
      )..add(LoadInfoEvent()),
    );
  }

  void _buildSavedListener(SaveAttributesState state) {
    if (state.saveAttribute == SaveAttributeStatus.offline) {
      ToastUtils.showErrorToastMessage('No internet Connection!');
    } else if (state.saveAttribute == SaveAttributeStatus.error) {
      ToastUtils.showErrorToastMessage('An error has occured, try again.');
    } else if (state.saveAttribute == SaveAttributeStatus.emptyValue) {
      ToastUtils.showErrorToastMessage(
          'You need to enter all the the information');
    } else if (state.saveAttribute == SaveAttributeStatus.done) {
      ToastUtils.showSusToastMessage('Saved Successfully');
    }
  }

  BlocBuilder<GetAttributesBloc, GetAttributesState> _buildBodyState(
      LoadedServicesProvidersInfoState state) {
    return BlocBuilder<GetAttributesBloc, GetAttributesState>(
      builder: (context, attributesState) {
        if (attributesState.attributesStates == AttributesStates.loading) {
          return const LoadingWidget();
        }
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.providersLabel),
                _buildProvidersList(
                  context,
                  state.providers,
                  attributesState.provider,
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(AppLocalizations.of(context)!.servicesLabel),
                _buildServicesList(
                  context,
                ),
                const SizedBox(
                  height: 16,
                ),
                attributesState.attributes.isNotEmpty
                    ? Column(
                        children: [
                          _buildAttributes(context, attributesState.attributes),
                          _buildSubmitBtn(attributesState)
                        ],
                      )
                    : Container()
              ],
            ),
          ),
        );
      },
    );
  }

  NetworkErrorWidget _buildNetworkErrorState(
      ServicesProvidersInfoNetworkErrorState state, BuildContext context) {
    return NetworkErrorWidget(
      message: state.message,
      onPressed: () {
        BlocProvider.of<ServicesProvidersInfoBloc>(context)
            .add(LoadInfoEvent());
      },
    );
  }

  NoConnectionWidget _buildNoConnectionState(BuildContext context) {
    return NoConnectionWidget(
      onPressed: () {
        BlocProvider.of<ServicesProvidersInfoBloc>(context)
            .add(LoadInfoEvent());
      },
    );
  }

  LoadingWidget _buildLoadingState() {
    return const LoadingWidget();
  }

  BlocBuilder<SaveAttributesBloc, SaveAttributesState> _buildSubmitBtn(
      GetAttributesState attributesState) {
    return BlocBuilder<SaveAttributesBloc, SaveAttributesState>(
      builder: (context, state) {
        print('in submit data is Empty ${state.data.isEmpty}');
        var loading = false;
        if (state.saveAttribute == SaveAttributeStatus.loading) {
          loading = true;
        }
        return AppButton(
          title: AppLocalizations.of(context)?.save ?? "",
          isLoading: loading,
          //isDisabled: state.data.isEmpty,
          onTap: () async {
            Map<int, String> initValues = {};
            for (var e in attributesState.attributes) {
              initValues[e.id] = e.value;
            }
            BlocProvider.of<SaveAttributesBloc>(context).add(
              SubmitAttributesEvent(
                  providerId: attributesState.provider.id, initValues: initValues),
            );
          },
        );
      },
    );
  }

  Widget _buildAttributes(
      BuildContext c, List<ServiceAttributeEntity> attributes) {
    List<Widget> listWidgets = [];
    for (var e in attributes) {
      listWidgets.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(e.name),
            const SizedBox(
              height: 4,
            ),
            Autocomplete<String>(
                initialValue: TextEditingValue(
                  text: e.value,
                ),
                fieldViewBuilder: (context, textEditingController, focusNode,
                    onFieldSubmitted) {
                  return TextFormField(
                    onChanged: (value) {
                      BlocProvider.of<SaveAttributesBloc>(c).add(
                        AddValueAttributeEvent(
                          key: e.id,
                          value: value,
                        ),
                      );
                    },
                    cursorColor: const Color.fromARGB(255, 45, 40, 40),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(8),
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: Colors.grey.withOpacity(.3),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: Colors.grey.withOpacity(.3),
                        ),
                      ),
                    ),
                    controller: textEditingController,
                    focusNode: focusNode,
                  );
                },
                optionsBuilder: (textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<String>.empty();
                  }
                  return e.autoComplete.where(
                    (element) => element.toLowerCase().contains(
                          textEditingValue.text.toLowerCase(),
                        ),
                  );
                },
                onSelected: (option) {
                  BlocProvider.of<SaveAttributesBloc>(c).add(
                    AddValueAttributeEvent(
                      key: e.id,
                      value: option,
                    ),
                  );
                }),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      );
    }

    return Column(
      children: listWidgets,
    );
  }

  Widget _buildProvidersList(
    BuildContext context,
    List<CompanyProviderEntity> data,
    CompanyProviderEntity selectedProvider,
  ) {
    return AppDropDown<CompanyProviderEntity>(
      hintText: AppLocalizations.of(context)!.providersLabel,
      initSelectedValue: selectedProvider.id == -1 ? null : selectedProvider,
      items: data.map((e) => _buildDropMenuItemProvider(context, e)).toList(),
      onChanged: (value) {
        BlocProvider.of<GetAttributesBloc>(context).add(ProviderIdChangedEvent(
            provider: value, service: companyServiceEntity));
        BlocProvider.of<SaveAttributesBloc>(context).add(
          ClearAttributesEvent(),
        );
      },
    );
  }

  Widget _buildServicesList(
    BuildContext context,
  ) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.withOpacity(.3),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        companyServiceEntity.name,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
      ),
    );
  }

  DropdownMenuItem<CompanyProviderEntity> _buildDropMenuItemProvider(
      BuildContext context, CompanyProviderEntity e) {
    return DropdownMenuItem<CompanyProviderEntity>(
      value: e,
      child: Text(
        e.name,
      ),
    );
  }
}
