// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masbar/core/ui/dialogs/loading_dialog.dart';
import 'package:masbar/features/company/manage_promotion/presentation/bloc/get_promos_bloc.dart';

import '../../../../../core/api_service/network_service_http.dart';
import '../../../../../core/utils/helpers/toast_utils.dart';
import '../../data/data_source/promotion_data_source.dart';
import '../../data/repositories/promotion_repo_impl.dart';
import '../../domain/entities/promotion_entity.dart';
import '../../domain/use_cases/assign_service_use_case.dart';
import '../../domain/use_cases/remove_service_use_case.dart';
import '../bloc/assign_service_code_bloc.dart';
import '../bloc/remove_service_code_bloc.dart';

class AssignRemovePromoServiceScreen extends StatefulWidget {
  static const routeName = 'assign_remove_promo_service_screen';

  final PromotionEntity data;
  const AssignRemovePromoServiceScreen({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<AssignRemovePromoServiceScreen> createState() =>
      _AssignRemovePromoServiceScreenState();
}

class _AssignRemovePromoServiceScreenState
    extends State<AssignRemovePromoServiceScreen> {
  List<ServicePromotionEntity> services = [];
  Map<int, bool> assignedData = {};
  @override
  void initState() {
    super.initState();
    services = widget.data.services;
    for (var element in services) {
      assignedData[element.id] = element.isAssigned;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _getAssignBloc(),
        ),
        BlocProvider(
          create: (context) => _getRemoveBLOC(),
        ),
      ],
      child: Builder(builder: (context) {
        return MultiBlocListener(
          listeners: [
            BlocListener<AssignServiceCodeBloc, AssignServiceCodeState>(
              listener: (context, state) {
                _buildAddingListener(state, context);
              },
            ),
            BlocListener<RemoveServiceCodeBloc, RemoveServiceCodeState>(
              listener: (context, state) {
                _buildRemoveListener(state, context);
              },
            ),
          ],
          child: WillPopScope(
            onWillPop: () {
              BlocProvider.of<GetPromosBloc>(context).add(LoadPromosEvent());
              Navigator.pop(context);
              Navigator.pop(context);
              return Future.value(false);
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text('Services - ${widget.data.promo}'),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: _buildAssign(
                    context,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  RemoveServiceCodeBloc _getRemoveBLOC() {
    return RemoveServiceCodeBloc(
        removeServiceUseCase: RemoveServiceUseCase(
      promotionRepo: PromotionRepoImpl(
        promotionDataSource: PromotionDataSourceWithHttp(
          client: NetworkServiceHttp(),
        ),
      ),
    ));
  }

  AssignServiceCodeBloc _getAssignBloc() {
    return AssignServiceCodeBloc(
        assignServiceUseCase: AssignServiceUseCase(
      promotionRepo: PromotionRepoImpl(
        promotionDataSource: PromotionDataSourceWithHttp(
          client: NetworkServiceHttp(),
        ),
      ),
    ));
  }

  void _buildAddingListener(
      AssignServiceCodeState state, BuildContext context) {
    if (state is LoadingAssignService) {
      showLoadingDialog(context, text: 'Assigning...');
    } else if (state is AssignServiceOfflineState) {
      ToastUtils.showErrorToastMessage('No interent connection');
    } else if (state is AssignServiceErrorState) {
      ToastUtils.showErrorToastMessage(
          'Erro has occured,\n try again\n ////${state.message}');
    } else if (state is LoadedAssignService) {
      ToastUtils.showSusToastMessage('Added Successfully');
      setState(() {
        assignedData[state.serviveId] = true;
      });
      Navigator.pop(context);
    }
  }

  void _buildRemoveListener(
      RemoveServiceCodeState state, BuildContext context) {
    if (state is LoadingRemoveServiceCode) {
      showLoadingDialog(context, text: 'Removing...');
    } else if (state is RemoveServiceCodeOfflineState) {
      ToastUtils.showErrorToastMessage('No interent connection');
    } else if (state is RemoveServiceCodeErrorState) {
      ToastUtils.showErrorToastMessage(
          'Erro has occured,\n try again\n ////${state.message}');
    } else if (state is LoadedRemoveServiceCode) {
      ToastUtils.showSusToastMessage('Removed Successfully');
      setState(() {
        assignedData[state.serviveId] = false;
      });
      Navigator.pop(context);
    }
  }

  Widget _buildAssign(BuildContext context) {
    return Column(
        children: services.map(
      (e) {
        return Theme(
          data: ThemeData(primaryColor: Colors.red),
          child: CheckboxListTile(
            title: Text(e.name),
            value: assignedData[e.id],
            onChanged: (value) {
              if (!assignedData[e.id]!) {
                BlocProvider.of<AssignServiceCodeBloc>(context).add(
                  AssignServiceToPromo(
                    promoId: widget.data.id,
                    serviceId: e.id,
                  ),
                );
              } else {
                BlocProvider.of<RemoveServiceCodeBloc>(context).add(
                  RemoveServicePromo(
                    promoId: widget.data.id,
                    serviceId: e.id,
                  ),
                );
              }
            },
          ),
        );
      },
    ).toList());
  }
}
