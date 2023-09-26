import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:masbar/core/api_service/network_service_http.dart';
import 'package:masbar/core/ui/widgets/app_textfield.dart';
import 'package:masbar/core/ui/dialogs/loading_dialog.dart';
import 'package:masbar/core/ui/widgets/loading_widget.dart';
import 'package:masbar/core/ui/widgets/no_connection_widget.dart';
import 'package:masbar/features/user/promo_code/data/data_source/promo_code_data_source.dart';

import '../../../../../core/ui/widgets/app_dialog.dart';
import '../../../../../core/ui/widgets/app_text.dart';
import '../../../../../core/ui/widgets/error_widget.dart';
import '../../../../../core/utils/helpers/toast_utils.dart';
import '../../data/repositories/promo_code_repo_impl.dart';
import '../../domain/use_cases/add_promo_use_case.dart';
import '../../domain/use_cases/get_promos_use_case.dart';
import '../bloc/add_promo_bloc.dart';
import '../bloc/get_promos_bloc.dart';
import '../bloc/get_promos_event.dart';
import '../widgets/promo_code_item.dart';

class PromoCodeScreen extends StatelessWidget {
    static const routeName ='promo_code_screen';
  PromoCodeScreen({super.key});
  FocusNode promoCodeFocus = FocusNode();
  TextEditingController promoCodeController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _getBloc(),
        ),
        BlocProvider(
          create: (context) => _getAddPromoBloc(),
        ),
      ],
      child: Builder(builder: (context) {
        return BlocListener<AddPromoBloc, AddPromoState>(
          listener: (context, state) {
            if (state is LoadingAddPromo) {
              showLoadingDialog(context);
            } else if (state is AddPromoOfflineState) {
              Navigator.pop(context);
              ToastUtils.showErrorToastMessage('No internet connection');
            } else if (state is AddPromoErrorState) {
              Navigator.pop(context);
              ToastUtils.showErrorToastMessage(state.message);
            } else if (state is DoneAddPromo) {
              Navigator.pop(context);
              ToastUtils.showSusToastMessage(
                  'The promo code has been added sucessfully');
              BlocProvider.of<GetPromosBloc>(context).add(GetPromosDataEvent());
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                AppLocalizations.of(context)!.promoCodeLabel,
              ),
            ),
            body: SafeArea(
              child: BlocBuilder<GetPromosBloc, GetPromosState>(
                builder: (context, state) {
                  if (state is LoadingGetPromos) {
                    return const LoadingWidget();
                  } else if (state is GetPromosOfflineState) {
                    return NoConnectionWidget(onPressed: () {
                      BlocProvider.of<GetPromosBloc>(context)
                          .add(GetPromosDataEvent());
                    });
                  } else if (state is GetPromosErrorState) {
                    return NetworkErrorWidget(
                        message: state.message,
                        onPressed: () {
                          BlocProvider.of<GetPromosBloc>(context)
                              .add(GetPromosDataEvent());
                        });
                  } else if (state is LoadedGetPromos) {
                    return SingleChildScrollView(
                      child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Form(
                                key: formKey,
                                child: _buildField(context),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              if (state.promos.isNotEmpty) _buildList(state),
                              if (state.promos.isEmpty) _buildEmpty(context),
                              const SizedBox(
                                height: 80,
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
        );
      }),
    );
  }

  AppText _buildEmpty(BuildContext context) {
    return AppText(AppLocalizations.of(context)?.noPromocodeAppliedYet ?? "");
  }

  ListView _buildList(LoadedGetPromos state) {
    return ListView.separated(
       shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return PromoCodeItem(promoCodeEntity: state.promos[index]);
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 16);
        },
        itemCount: state.promos.length);
  }

  AppTextField _buildField(BuildContext c) {
    return AppTextField(
      textInputAction: TextInputAction.go,
      focusNode: promoCodeFocus,
      controller: promoCodeController,
      labelText: AppLocalizations.of(c)?.promoCodeLabel ?? "",
      hintText: AppLocalizations.of(c)?.promoCodeLabel ?? "",
      validator: (val) {
        if (val.toString().isEmpty) {
          return AppLocalizations.of(c)?.pleaseEnterPromoCode ?? "";
        }
        return null;
      },
      suffixIcon: Icons.add,
      suffixIconColor: Theme.of(c).primaryColor,
      onSuffixTap: () {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          showDialog(
            context: c,
            builder: (BuildContext context) {
              return StatefulBuilder(builder: (context, setState) {
                return DialogItem(
                  title: AppLocalizations.of(context)?.saveThePromoCode ?? "",
                  paragraph:
                      AppLocalizations.of(context)?.saveThePromoCodeQus ?? "",
                  cancelButtonText: AppLocalizations.of(context)?.cancel ?? "",
                  nextButtonText: AppLocalizations.of(context)?.save ?? "",
                  nextButtonFunction: () async {
                    BlocProvider.of<AddPromoBloc>(c).add(AddNewPromoEvent(
                        promo: promoCodeController.text.trim()));
                    Navigator.pop(context);
                  },
                  cancelButtonFunction: () {
                    Navigator.pop(context);
                  },
                );
              });
            },
          );
        }
      },
    );
  }

  AddPromoBloc _getAddPromoBloc() {
    return AddPromoBloc(
      addPromoUseCase: AddPromoUseCase(
        getPromoCode: PromoCodeRepoImpl(
          promoCodeDataSource: PromoCodeDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    );
  }

  GetPromosBloc _getBloc() {
    return GetPromosBloc(
      getPromosUseCase: GetPromosUseCase(
        getPromoCode: PromoCodeRepoImpl(
          promoCodeDataSource: PromoCodeDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    )..add(GetPromosDataEvent());
  }
}
