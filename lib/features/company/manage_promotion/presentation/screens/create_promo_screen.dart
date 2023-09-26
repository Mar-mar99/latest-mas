import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masbar/core/ui/widgets/app_button.dart';
import 'package:masbar/core/ui/widgets/app_text.dart';
import 'package:masbar/core/ui/widgets/app_textfield.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../core/api_service/network_service_http.dart';
import '../../../../../core/ui/widgets/error_widget.dart';
import '../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../core/ui/widgets/no_connection_widget.dart';
import '../../../../../core/utils/helpers/toast_utils.dart';
import '../../../company_services/data/data_source/company_services_data_source.dart';
import '../../../company_services/data/repositories/company_services_repo_impl.dart';
import '../../../company_services/domain/entities/company_service_entity.dart';
import '../../../company_services/domain/use_cases/get_company_services_use_case.dart';
import '../../../company_services/presentation/bloc/get_company_sevices_bloc.dart';
import '../../data/data_source/promotion_data_source.dart';
import '../../data/repositories/promotion_repo_impl.dart';
import '../../domain/use_cases/create_promotion_use_case.dart';
import '../bloc/create_promo_bloc.dart';
import '../bloc/get_promos_bloc.dart';

class CreatePromoScreen extends StatefulWidget {
  static const routeName = 'create_promo_screen';
  const CreatePromoScreen({super.key});

  @override
  State<CreatePromoScreen> createState() => _CreatePromoScreenState();
}

class _CreatePromoScreenState extends State<CreatePromoScreen> {
  DateTime selectedDate = DateTime.now();
  final TextEditingController promoController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController expireController = TextEditingController();
  List<CompanyServiceEntity> selectedServices = [];
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _getCompanyServicesBloc(),
        ),
        BlocProvider(
          create: (context) => _getCreatePromoCode(),
        ),
      ],
      child: Builder(builder: (context) {
        return BlocListener<CreatePromoBloc, CreatePromoState>(
          listener: (context, state) {
            _buildListener(state, context);
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.new_promo_code),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child:
                    BlocBuilder<GetCompanySevicesBloc, GetCompanySevicesState>(
                  builder: (context, state) {
                    if (state is LoadingGetCompanySevices) {
                      return _buildLoadingState();
                    } else if (state is GetCompanySevicesOfflineState) {
                      return _buildNoConnectionState(context);
                    } else if (state is GetCompanySevicesErrorState) {
                      return _buildNetworkErrorState(state, context);
                    } else if (state is LoadedGetCompanySevices) {
                      return _buildBodyState(context, state);
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

  void _buildListener(CreatePromoState state, BuildContext context) {
    if (state is CreatePromoOfflineState) {
      ToastUtils.showErrorToastMessage('No interent connection');
    } else if (state is CreatePromoErrorState) {
      ToastUtils.showErrorToastMessage(
          'Erro has occured,\n try again\n ${state.message}');
    } else if (state is LoadedCreatePromo) {
      ToastUtils.showSusToastMessage('Added Successfully');
      BlocProvider.of<GetPromosBloc>(context).add(LoadPromosEvent());

      Navigator.pop(context);
    }
  }

  CreatePromoBloc _getCreatePromoCode() {
    return CreatePromoBloc(
        createPromotionUseCase: CreatePromotionUseCase(
            promotionRepo: PromotionRepoImpl(
                promotionDataSource: PromotionDataSourceWithHttp(
                    client: NetworkServiceHttp()))));
  }

  Widget _buildBodyState(BuildContext context, LoadedGetCompanySevices state) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildPromo(),
              const SizedBox(
                height: 16,
              ),
              _buildDiscount(),
              const SizedBox(
                height: 16,
              ),
              _buildeExpiration(context),
              const SizedBox(
                height: 16,
              ),
              _buildCompanyServices(state)
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          _buildAddBtn(context)
        ],
      ),
    );
  }

  Widget _buildAddBtn(BuildContext context) {
    return BlocBuilder<CreatePromoBloc, CreatePromoState>(
      builder: (context, state) {
        return AppButton(
          title: (AppLocalizations.of(context)!.add),
          isLoading: state is LoadingCreatePromo,
          onTap: () {
            final isValid = formKey.currentState!.validate();

            if (isValid) {
              if (selectedServices.isEmpty) {
                ToastUtils.showErrorToastMessage(
                    AppLocalizations.of(context)!.please_select_services);
              } else {
                BlocProvider.of<CreatePromoBloc>(context).add(
                  CreateEvent(
                    promo: promoController.text,
                    discount: num.parse(discountController.text),
                    expiration: selectedDate,
                    services: selectedServices.map((e) => e.id).toList(),
                  ),
                );
              }
            }
          },
        );
      },
    );
  }

  Widget _buildPromo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText(AppLocalizations.of(context)!.promoCode),
        AppTextField(
          controller: promoController,
          hintText: AppLocalizations.of(context)!.promoCode,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value!.isEmpty) {
              return AppLocalizations.of(context)!.cannot_be_empty;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDiscount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText(AppLocalizations.of(context)!.discount),
        AppTextField(
          controller: discountController,
          hintText: AppLocalizations.of(context)!.discount,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value!.isEmpty) {
              return AppLocalizations.of(context)!.cannot_be_empty;
            } else if (double.tryParse(value) == null) {
              return AppLocalizations.of(context)!
                  .make_sure_you_entered_a_valid_number;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildeExpiration(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText(AppLocalizations.of(context)!.expiration),
        AppTextField(
            controller: expireController,
            hintText: AppLocalizations.of(context)!.expire_date,
            onTap: () async {
              DateTime? returnedDate = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100));
              if (returnedDate == null) return;
              setState(() {
                selectedDate = returnedDate;
                expireController.text =
                    '${selectedDate.year}/${selectedDate.month}/${selectedDate.day}';
              });
            },
            readOnly: true,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            suffixIcon: (Icons.calendar_month),
            validator: (value) {
              if (value!.isEmpty) {
                return AppLocalizations.of(context)!.cannot_be_empty;
              }
              return null;
            }),
      ],
    );
  }

  Widget _buildCompanyServices(LoadedGetCompanySevices state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText(AppLocalizations.of(context)!.servicesPromo),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey.withOpacity(.3),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: MultiSelectDialogField(
            searchable: false,
            isDismissible: true,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  5,
                ),
              ),
            ),
            chipDisplay: MultiSelectChipDisplay(
              onTap: null,
            ),
            listType: MultiSelectListType.LIST,
            title: Text(AppLocalizations.of(context)!.select_services),
            buttonText: Text(
              AppLocalizations.of(context)!.company_services,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            buttonIcon: Icon(Icons.location_city, color: Colors.grey[500]),
            items: state.data.map((e) => MultiSelectItem(e, e.name)).toList(),
            onSelectionChanged: (values) {},
            onConfirm: (values) {
              List<CompanyServiceEntity> selectedData = [];
              for (var i = 0; i < values.length; i++) {
                CompanyServiceEntity data = values[i] as CompanyServiceEntity;
                selectedData.add(data);
              }
              setState(() {
                selectedServices = selectedData;
              });
            },
          ),
        ),
      ],
    );
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
}
