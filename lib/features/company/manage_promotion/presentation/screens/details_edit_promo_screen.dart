// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masbar/core/ui/dialogs/loading_dialog.dart';
import 'package:masbar/core/ui/widgets/app_dialog.dart';
import 'package:masbar/features/company/manage_promotion/domain/use_cases/update_promotion_use_case.dart';
import 'package:masbar/features/company/manage_promotion/presentation/bloc/delete_promo_bloc.dart';
import 'package:masbar/features/company/manage_promotion/presentation/widgets/edit_promo_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../core/api_service/network_service_http.dart';
import '../../../../../core/ui/widgets/app_text.dart';
import '../../../../../core/ui/widgets/error_widget.dart';
import '../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../core/ui/widgets/no_connection_widget.dart';
import '../../../../../core/utils/helpers/toast_utils.dart';
import '../../data/data_source/promotion_data_source.dart';
import '../../data/repositories/promotion_repo_impl.dart';
import '../../domain/use_cases/delete_promotion_use_case.dart';
import '../../domain/use_cases/get_promotion_details_use_case.dart';
import '../bloc/get_promos_bloc.dart';
import '../bloc/promos_details_bloc.dart';
import '../bloc/update_promo_bloc.dart';
import 'assign_remove_service_screen.dart';

class DetailsEditPromoScreen extends StatefulWidget {
  static const routeName = 'details_edit_promo_screen';
  final int id;
  const DetailsEditPromoScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<DetailsEditPromoScreen> createState() => _DetailsEditPromoScreenState();
}

class _DetailsEditPromoScreenState extends State<DetailsEditPromoScreen> {
  var showEdit = false;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _detailsBloc(),
        ),
        BlocProvider(
          create: (context) => _updateBloc(),
        ),
        BlocProvider(
          create: (context) => _deletePromo(),
        )
      ],
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(showEdit
                ? AppLocalizations.of(context)!.edit
                : AppLocalizations.of(context)!.details),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: MultiBlocListener(
                listeners: [
                  BlocListener<DeletePromoBloc, DeletePromoState>(
                    listener: (context, state) {
                      _listenerRemove(state, context);
                    },
                  ),
                  BlocListener<UpdatePromoBloc, UpdatePromoState>(
                    listener: (context, state) {
                      _updateListener(state, context);
                    },
                  ),
                ],
                child: BlocBuilder<PromosDetailsBloc, PromosDetailsState>(
                  builder: (context, state) {
                    if (state is LoadingPromosDetails) {
                      return _buildLoadingState();
                    } else if (state is PromosDetailsOfflineState) {
                      return _buildNoConnectionState(context);
                    } else if (state is PromosDetailsErrorState) {
                      return _buildNetworkErrorState(state, context);
                    } else if (state is LoadedPromosDetails) {
                      return _buildBody(context, state);
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

  void _updateListener(UpdatePromoState state, BuildContext context) {
    if (state is UpdatePromoOfflineState) {
      ToastUtils.showErrorToastMessage('No interent connection');
    } else if (state is UpdatePromoErrorState) {
      ToastUtils.showErrorToastMessage(
          'Erro has occured,\n try again\n ${state.message}');
    } else if (state is LoadedUpdatePromo) {
      Navigator.pop(context);
      ToastUtils.showSusToastMessage('Updated Successfully');
      BlocProvider.of<GetPromosBloc>(context).add(LoadPromosEvent());
    }
  }

  void _listenerRemove(DeletePromoState state, BuildContext context) {
    if (state is LoadingDeletePromo) {
      showLoadingDialog(context, text: 'deleting...');
    } else if (state is DeletePromoOfflineState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage('No interent connection');
    } else if (state is DeletePromoErrorState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage(
          'Erro has occured,\n try again\n ${state.message}');
    } else if (state is LoadedDeletePromo) {
      Navigator.pop(context);
      Navigator.pop(context);
      ToastUtils.showSusToastMessage('Deleted Successfully');
      BlocProvider.of<GetPromosBloc>(context).add(LoadPromosEvent());
    }
  }

  DeletePromoBloc _deletePromo() {
    return DeletePromoBloc(
        deletePromotionUseCase: DeletlePromotionUseCase(
      promotionRepo: PromotionRepoImpl(
        promotionDataSource: PromotionDataSourceWithHttp(
          client: NetworkServiceHttp(),
        ),
      ),
    ));
  }

  PromosDetailsBloc _detailsBloc() {
    return PromosDetailsBloc(
        getPromotionDetailsUseCase: GetPromotionDetailsUseCase(
      promotionRepo: PromotionRepoImpl(
        promotionDataSource: PromotionDataSourceWithHttp(
          client: NetworkServiceHttp(),
        ),
      ),
    ))
      ..add(
        LoadPromosDetailsEvent(
          id: widget.id,
        ),
      );
  }

  UpdatePromoBloc _updateBloc() {
    return UpdatePromoBloc(
      updatePromotionUseCase: UpdatePromotionUseCase(
        promotionRepo: PromotionRepoImpl(
          promotionDataSource: PromotionDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    );
  }

  NetworkErrorWidget _buildNetworkErrorState(
      PromosDetailsErrorState state, BuildContext context) {
    return NetworkErrorWidget(
      message: state.message,
      onPressed: () {
        BlocProvider.of<PromosDetailsBloc>(context).add(
          LoadPromosDetailsEvent(
            id: widget.id,
          ),
        );
      },
    );
  }

  NoConnectionWidget _buildNoConnectionState(BuildContext context) {
    return NoConnectionWidget(
      onPressed: () {
        BlocProvider.of<PromosDetailsBloc>(context).add(
          LoadPromosDetailsEvent(
            id: widget.id,
          ),
        );
      },
    );
  }

  LoadingWidget _buildLoadingState() {
    return const LoadingWidget();
  }

  Widget _buildBody(BuildContext context, LoadedPromosDetails state) {
    return showEdit ? _buildEdit(state) : _buildDetails(context, state);
  }

  EditPromoWidget _buildEdit(LoadedPromosDetails state) {
    return EditPromoWidget(
      id: state.data.id,
      promo: state.data.promo,
      discount: state.data.discount,
      expire: state.data.expiration,
      servicePromotionEntity: state.data.services,
    );
  }

  Widget _buildDetails(BuildContext c, LoadedPromosDetails state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(AppLocalizations.of(context)!.promoCode),
            Text(
              state.data.promo,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(AppLocalizations.of(context)!.status),
            Text(
              state.data.status,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(AppLocalizations.of(context)!.discount),
            Text(
              '${state.data.discount}%',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(AppLocalizations.of(context)!.expiration),
            Text(
              '${state.data.expiration.year}/${state.data.expiration.month}/${state.data.expiration.day}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(AppLocalizations.of(context)!.servicesPromo),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: state.data.services.map((e) {
                if (e.isAssigned) {
                  return Text(
                    e.name,
                    style: const TextStyle(color: Colors.grey),
                  );
                } else {
                  return Container();
                }
              }).toList(),
            )
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        if (!showEdit)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () {
                  setState(() {
                    showEdit = true;
                  });
                },
                icon: const Icon(Icons.edit),
                label: Text(
                  AppLocalizations.of(context)!.edit,
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return BlocProvider.value(
                        value: c.read<GetPromosBloc>(),
                        child: AssignRemovePromoServiceScreen(data: state.data),
                      );
                    },
                  ));
                },
                icon: const Icon(Icons.home_repair_service),
                label: Text(
                  'Services',
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (dialogContext) {
                      return BlocProvider.value(
                        value: c.read<DeletePromoBloc>(),
                        child: DialogItem(
                          title:
                              AppLocalizations.of(context)!.delete_confirmation,
                          paragraph: AppLocalizations.of(context)!
                              .are_you_sure_you_want_to_delete_this_promo,
                          cancelButtonText:
                              AppLocalizations.of(context)!.cancel,
                          cancelButtonFunction: () {
                            Navigator.pop(context);
                          },
                          nextButtonText: AppLocalizations.of(context)!.delete,
                          nextButtonFunction: () {
                            Navigator.pop(context);
                            BlocProvider.of<DeletePromoBloc>(c)
                                .add(DeleteEvent(id: state.data.id));
                          },
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.delete),
                label: Text(
                  AppLocalizations.of(context)!.delete,
                ),
              )
            ],
          )
      ],
    );
  }
}
