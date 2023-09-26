import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masbar/core/api_service/network_service_http.dart';
import 'package:masbar/core/ui/dialogs/loading_dialog.dart';
import 'package:masbar/core/ui/widgets/app_text.dart';
import 'package:masbar/core/utils/helpers/helpers.dart';
import 'package:masbar/core/utils/helpers/toast_utils.dart';
import 'package:masbar/features/provider/homepage/presentation/active_request/bloc/arrived_bloc.dart';

import '../../../../../../core/ui/dialogs/cancel_reason_dialog.dart';
import '../../../../../../core/ui/widgets/app_button.dart';
import '../../../../../../core/ui/widgets/app_dialog.dart';
import '../../../../../../core/ui/widgets/app_textfield.dart';
import '../../../../../../core/ui/widgets/image_item.dart';
import '../../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../../core/ui/widgets/profile/mini_avatar.dart';
import '../../../../../../core/ui/widgets/small_button.dart';
import '../../../../../../core/utils/helpers/launching_map.dart';
import '../../../../../navigation/screens/provider_screen.dart';
import '../../../data/date_source/provider_data_source.dart';
import '../../../data/repositories/provider_repo_impl.dart';
import '../../../domain/entities/request_provider_entity.dart';
import '../../../../../../core/ui/widgets/custom_map.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/use_cases/arrived_use_case.dart';
import '../../../domain/use_cases/cancel_after_request_use_case.dart';
import '../../../domain/use_cases/get_current_request_use_case.dart';
import '../../../domain/use_cases/get_provider_request_details.dart';
import '../../../domain/use_cases/start_working_use_case.dart';
import '../bloc/cancel_after_accept_bloc.dart';
import '../bloc/current_request_bloc.dart';
import '../bloc/start_bloc.dart';
import '../widgets/timer_widget.dart';
import 'attachments_end_service_screen.dart';

class ActiveRequestScreen extends StatefulWidget {
  final int requestId;
  const ActiveRequestScreen({
    super.key,
    required this.requestId,
  });

  @override
  State<ActiveRequestScreen> createState() => _ActiveRequestScreenState();
}

class _ActiveRequestScreenState extends State<ActiveRequestScreen> {
  final GetProviderRequestDetailsUseCase getProviderRequestDetailsUseCase =
      GetProviderRequestDetailsUseCase(
    providerRepo: ProviderRepoImpl(
      providerDataSource: ProviderDataSourceWithHttp(
        client: NetworkServiceHttp(),
      ),
    ),
  );
  RequestProviderEntity? oldData;

  Future<RequestProviderEntity> getData() async {
    final data = await getProviderRequestDetailsUseCase.call(
      requestId: widget.requestId,
    );
    return data.fold(
      (failure) {
        return oldData!;
      },
      (data) {
        oldData = data;
        return data;
      },
    );
  }

  Future<dynamic> showUserCancelDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (dialogContext) => DialogItem(
          title: 'Request is Cancelled',
          paragraph: 'The user has cancelled the request.',
          cancelButtonText: 'close',
          cancelButtonFunction: () {
            timer.cancel();
            dataStreamController.close();
            Navigator.pushNamedAndRemoveUntil(
              context,
              ProviderScreen.routeName,
              (route) => false,
            );
          }),
    );
  }

  late StreamController<RequestProviderEntity> dataStreamController;
  late Timer timer;
  bool isCancelDialogOpened = false;
  @override
  void initState() {
    super.initState();
    dataStreamController = StreamController<RequestProviderEntity>.broadcast();
    timer = Timer.periodic(
      const Duration(seconds: 2),
      (timer) async {
        RequestProviderEntity data = await getData();
        if (data.cancelledBy == 'USER' && !isCancelDialogOpened) {
          setState(() {
            isCancelDialogOpened = true;
          });
          showUserCancelDialog(context);
        }
        if (!dataStreamController.isClosed) dataStreamController.add(data);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
    dataStreamController.close();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _getArrivedBloc(),
        ),
        BlocProvider(
          create: (context) => _getCancelAfterAcceptBloc(),
        ),
        BlocProvider(
          create: (context) => _getStartBloc(),
        ),
      ],
      child: Builder(builder: (context) {
        return MultiBlocListener(
          listeners: [
            BlocListener<CancelAfterAcceptBloc, CancelAfterAcceptState>(
              listener: (context, state) {
                _buildCancellingAfterAcceptListener(state, context);
              },
            ),
            BlocListener<ArrivedBloc, ArrivedState>(
              listener: (context, state) {
                _buildArrivedListener(state, context);
              },
            ),
            BlocListener<StartBloc, StartState>(
              listener: (context, state) {
                _buildStartListener(state, context);
              },
            ),
          ],
          child: StreamBuilder<RequestProviderEntity>(
              stream: dataStreamController.stream.asBroadcastStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Scaffold(body:  Center(child: LoadingWidget()));
                } else if (snapshot.hasData) {
                  RequestProviderEntity data = snapshot.data!;
                  return _buildData(data, context);
                } else {
                  return const Scaffold(body:  Center(child: LoadingWidget()));
                }
              }),
        );
      }),
    );
  }

  Scaffold _buildData(RequestProviderEntity data, BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildMap(data),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            _buildDirectionsBtn(context, data),
                            const SizedBox(
                              width: 10,
                            ),
                            _buildCallBtn(context, data),
                          ],
                        ),
                      ),
                       if (data.status! == 'STARTED') ...[
                        const SizedBox(
                          height: 20,
                        ),
                        _buildTimer(context),
                           const SizedBox(
                        height: 20,
                      ),
                        Divider(),
                      ],

                        const SizedBox(
                        height: 8,
                      ),
                      _buildAddress(data),
                        const SizedBox(
                        height: 8,
                      ),
                      Divider(),
                      const SizedBox(
                        height: 8,
                      ),
                      _buildServiceType(context, data),
                       const SizedBox(
                        height: 8,
                      ),
                      Divider(),
                      const SizedBox(
                        height: 8,
                      ),
                      _buildCustomer(context, data),

                      const SizedBox(
                        height: 8,
                      ),
                      if (data.beforeImage!.isNotEmpty) ...[
                        _buildBeforeImageList(context, data),
                        const SizedBox(
                          height: 8,
                        )
                      ],

                      const SizedBox(
                        height: 80,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: _buildBottomSheet(context, data),
    );
  }

  Widget _buildNotes(RequestProviderEntity data) {
    return Text(
      data.notes!,
      style: const TextStyle(fontWeight: FontWeight.normal));
  }

  void _buildStartListener(StartState state, BuildContext context) {
    if (state is StartOfflineState) {
      ToastUtils.showErrorToastMessage('No internet Connection');
    } else if (state is StartErrorState) {
      ToastUtils.showErrorToastMessage('An error has ocurred, try again');
    } else if (state is DoneStart) {
      // BlocProvider.of<CurrentRequestBloc>(context).add(
      //   RefreshCurrentRequestEvent(),
      // );
      ToastUtils.showSusToastMessage('The service has been started succefully');
    }
  }

  Row _buildServiceType(BuildContext context, RequestProviderEntity data) {
    return Row(
      children: [
        Flexible(
          child: Text(
            AppLocalizations.of(context)!.serviceType,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(data.serviceType!.name!  ??'' ,
              style: const TextStyle(fontWeight: FontWeight.normal)),
        ),
      ],
    );
  }

  Widget _buildBeforeImageList(
      BuildContext context, RequestProviderEntity data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(
          height: 11,
        ),
        Text(
          'Attachments' ,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: 200.0,
            child: Row(
              children: List.generate(data.beforeImage!.length, (index) {
                dynamic item = data.beforeImage![index];

                return Row(
                  children: [
                    ImageItem(
                      isFile: false,
                      image: item,
                    ),
                     const SizedBox(width:8),
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  void _buildCancellingAfterAcceptListener(
      CancelAfterAcceptState state, BuildContext context) {
    if (state is LoadingCancel) {
      showLoadingDialog(context, text: 'Canceling...');
    } else if (state is CancelOfflineState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage('No internet Connection');
    } else if (state is CancelErrorState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage('An error has ocurred, try again');
    } else if (state is DoneCancel) {
      Navigator.pop(context);
      ToastUtils.showSusToastMessage(
          'The service has been cancelled succefully');
      Navigator.pushNamedAndRemoveUntil(
          context, ProviderScreen.routeName, (route) => false);
      // BlocProvider.of<CurrentRequestBloc>(context).add(
      //   RefreshCurrentRequestEvent(),
      // );
    }
  }

  void _buildArrivedListener(ArrivedState state, BuildContext context) {
    if (state is ArrivedOfflineState) {
      ToastUtils.showErrorToastMessage('No internet Connection');
    } else if (state is ArrivedErrorState) {
      ToastUtils.showErrorToastMessage('An error has ocurred, try again');
    } else if (state is DoneArrived) {
      ToastUtils.showSusToastMessage('You have arrived succefully');

      // BlocProvider.of<CurrentRequestBloc>(context).add(
      //   RefreshCurrentRequestEvent(),
      // );
    }
  }

  StartBloc _getStartBloc() {
    return StartBloc(
        startWorkingUseCase: StartWorkingUseCase(
      providerRepo: ProviderRepoImpl(
        providerDataSource: ProviderDataSourceWithHttp(
          client: NetworkServiceHttp(),
        ),
      ),
    ));
  }

  CancelAfterAcceptBloc _getCancelAfterAcceptBloc() {
    return CancelAfterAcceptBloc(
      cancelAfterRequestUseCase: CancelAfterRequestUseCase(
        providerRepo: ProviderRepoImpl(
          providerDataSource: ProviderDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    );
  }

  ArrivedBloc _getArrivedBloc() {
    return ArrivedBloc(
      arrivedUseCase: ArrivedUseCase(
        providerRepo: ProviderRepoImpl(
          providerDataSource: ProviderDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    );
  }

  CustomMap _buildMap(RequestProviderEntity data) {
    return CustomMap(
      lat: data.sLatitude!,
      lng: data.sLongitude!,
    );
  }

  SizedBox _buildBottomSheet(BuildContext context, RequestProviderEntity data) {
    return SizedBox(
      height: 80,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: data.status == 'COMPLETED' || data.status == 'CANCELLED'
            ? Container()
            : data.status! == 'ACCEPTED'
                ? Row(children: [
                    _buildCancelAfterAcceptedBtn(context, data.id!),
                    const SizedBox(
                      width: 15,
                    ),
                    _buildArrivedBtn(context, data.id!),
                  ])
                : data.status! == 'ARRIVED'
                    ? _buildStartBtn(context, data.id!)
                    : _buildEndButton(context, data),
      ),
    );
  }

  AppButton _buildEndButton(BuildContext context, RequestProviderEntity data) {
    return AppButton(
      title: AppLocalizations.of(context)?.endServiceLabel ?? "",
      onTap: () async {
        Navigator.pushNamed(context, AttachmentsEndServiceScreen.routeName,
            arguments: {'request': data});
      },
    );
  }

  Widget _buildStartBtn(BuildContext context, int id) {
    return BlocBuilder<StartBloc, StartState>(
      builder: (context, state) {
        var loading = false;
        if (state is LoadingStart) {
          loading = true;
        }
        return AppButton(
          isLoading: loading,
          title: AppLocalizations.of(context)?.startLabel ?? "",
          onTap: () async {
            BlocProvider.of<StartBloc>(context).add(StartRequestEvent(id: id));
          },
        );
      },
    );
  }

  Widget _buildArrivedBtn(BuildContext context, int id) {
    return BlocBuilder<ArrivedBloc, ArrivedState>(
      builder: (context, state) {
        var loading = false;
        if (state is LoadingArrived) {
          loading = true;
        }
        return Expanded(
          child: AppButton(
            title: AppLocalizations.of(context)?.arrivedLabel ?? "",
            isLoading: loading,
            onTap: () async {
              BlocProvider.of<ArrivedBloc>(context)
                  .add(ArrivedToLocationEvent(id: id));
            },
          ),
        );
      },
    );
  }

  Widget _buildCancelAfterAcceptedBtn(BuildContext context, int id) {
    return Expanded(
      child: AppButton(
        title: AppLocalizations.of(context)?.cancelLabel ?? "",
        buttonColor: ButtonColor.transparentBorderPrimary,
        onTap: () async {
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return CancelReasonDialog(
                handler: (value) {
                  BlocProvider.of<CancelAfterAcceptBloc>(context)
                      .add(CancelRequest(id: id, reason: value));
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTimer(BuildContext context) {
    return TimerWidget();
  }

  Widget _buildCustomer(BuildContext context, RequestProviderEntity data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            MiniAvatar(
              url: data.user!.picture,
              name: '${data.user!.firstName}' ?? '',
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: AppText(
                '${data.user!.firstName!} ${data.user!.lastName!}',
                bold: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        if (data.notes!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: _buildNotes(data),
          ),
      ],
    );

  }

  Widget _buildAddress(RequestProviderEntity data) {
    return Row(
      children: [
        const Icon(Icons.location_pin, color: Colors.green),
        Flexible(
          child: AppText(
            data.sAddress!,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }

  Widget _buildDirectionsBtn(BuildContext context, RequestProviderEntity data) {
    return ElevatedButton.icon(
        icon: const Icon(Icons.send_rounded, color: Colors.white),
        label: Text(
          AppLocalizations.of(context)!.directions,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
        ),
        onPressed: () async {
          await LaunchingMapHelper.launchMap(
            data.sLatitude!,
            data.sLongitude!,
            'user',
          );
        });
  }

  SmallButton _buildCallBtn(BuildContext context, RequestProviderEntity data) {
    return SmallButton(
      icon: Icons.call,
      width: 110,
      color: Theme.of(context).primaryColor.withOpacity(0.2),
      textColor: Theme.of(context).primaryColor,
      onTap: () async {
        Helpers.launchPhone(data.user!.mobile!);
      },
      title: AppLocalizations.of(context)?.call ?? "",
    );
  }
}
