// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import 'package:masbar/core/ui/widgets/app_dialog.dart';

import 'package:masbar/features/user/services/presentation/service_details.dart/screen/user_invoice_request_screen.dart';

import '../../../../../../core/api_service/network_service_http.dart';
import '../../../../../../core/ui/dialogs/cancel_reason_dialog.dart';
import '../../../../../../core/ui/dialogs/cancellation_fee_dialog.dart';
import '../../../../../../core/ui/invoice/invoice_screen.dart';
import '../../../../../../core/ui/widgets/app_button.dart';
import '../../../../../../core/ui/widgets/app_text.dart';

import '../../../../../../core/ui/widgets/detail_request_item.dart';
import '../../../../../../core/ui/widgets/image_item.dart';
import '../../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../../core/utils/helpers/toast_utils.dart';
import '../../../../../navigation/screens/user_screen.dart';
import '../../../data/data_source/explore_services_data_source.dart';
import '../../../data/repositories/explore_services_repo_impl.dart';
import '../../../domain/entities/request_details_entity.dart';
import '../../../domain/use_cases/cancel_request_use_case.dart';
import '../../../domain/use_cases/get_request_details_use_case.dart';
import '../bloc/cancel_user_request_bloc.dart';
import '../widgets/custom_timer.dart';
import 'active_request_map.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final int requestId;
  static const routeName = 'service_details_screen';
  ServiceDetailsScreen({
    Key? key,
    required this.requestId,
  }) : super(key: key);

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  final GetRequestDetailsUseCase getRequestDetailsUseCase =
      GetRequestDetailsUseCase(
    exploreServicesRepo: ExploreServicesRepoImpl(
      exploreServicesDataSource: ExploreServicesDataSourceWithHttp(
        client: NetworkServiceHttp(),
      ),
    ),
  );

  RequestDetailsEntity? oldData;
  bool showAcceptDialog = false;
  bool showArriveDialog = false;
  bool showStartDialog = false;
  bool showFinishDialog = false;
  bool showCancelFeeDialog = true;
  final acceptRing = AssetSource("tones/accepted.mp3");
  final arriveRing = AssetSource("tones/arrived.mp3");
  final startRing = AssetSource("tones/started.wav");
  final finishRing = AssetSource("tones/finished.mp3");
  final playerAccepted = AudioPlayer();
  final playerArrived = AudioPlayer();
  final playerStarted = AudioPlayer();
  final playerFinished = AudioPlayer();

  Future<RequestDetailsEntity> getData() async {
    final data = await getRequestDetailsUseCase.call(id: widget.requestId);
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

  late StreamController<RequestDetailsEntity> dataStreamController;
  late double mapHeight;
  late Timer timer;
  @override
  void initState() {
    super.initState();
    dataStreamController = StreamController<RequestDetailsEntity>.broadcast();
    timer = Timer.periodic(
      const Duration(seconds: 2),
      (timer) async {
        RequestDetailsEntity data = await getData();

        if (showCancelFeeDialog && data.cancelationFees != '0') {
          setState(() {
            showCancelFeeDialog = false;
          });
          _showFeeDialog(data.cancelationFees!);
        }

        if (data.status == 'ACCEPTED' && !showAcceptDialog) {
          playerAccepted
              .play(
            acceptRing,
            volume: 1,
          )
              .catchError((onError) {
            print("Error: $onError");
          });

          // playerAccepted.onPlayerComplete.listen((event) {
          //   playerAccepted.play(
          //     acceptRing,
          //     volume: 1,
          //   );
          // });
          setState(() {
            showAcceptDialog = true;
          });
          if (context.mounted) {
            _showAcceptDialog(data);
          }
        } else if (data.status == 'ARRIVED' && !showArriveDialog) {
          playerArrived
              .play(
            arriveRing,
            volume: 1,
          )
              .catchError((onError) {
            print("Error: $onError");
          });

          // playerArrived.onPlayerComplete.listen((event) {
          //   playerArrived.play(
          //     arriveRing,
          //     volume: 1,
          //   );
          // });
          setState(() {
            showArriveDialog = true;
          });
          if (context.mounted) {
            _showArrivedDialog(data);
          }
        } else if (data.status == 'STARTED' && !showStartDialog) {
          playerStarted
              .play(
            startRing,
            volume: 1,
          )
              .catchError((onError) {
            print("Error: $onError");
          });

          // playerStarted.onPlayerComplete.listen((event) {
          //   playerStarted.play(
          //     startRing,
          //     volume: 1,
          //   );
          // });
          setState(() {
            showStartDialog = true;
          });
          if (context.mounted) {
            _showStartedDialog();
          }
        } else if (data.status == 'COMPLETED' && !showFinishDialog) {
          playerFinished
              .play(
            finishRing,
            volume: 1,
          )
              .catchError((onError) {
            print("Error: $onError");
          });

          // playerFinished.onPlayerComplete.listen((event) {
          //   playerFinished.play(
          //     finishRing,
          //     volume: 1,
          //   );
          // });
          setState(() {
            showFinishDialog = true;
          });
          if (context.mounted) {
            _showCompleteDialog();
          }
        }
        if (!dataStreamController.isClosed) dataStreamController.add(data);
      },
    );
  }

  void _showCompleteDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return DialogItem(
          icon: Lottie.asset('assets/lottie/finished.json',
              height: 150, width: 150),
          title: 'Completed!',
          paragraph: 'Your request has been completed successfully',
          nextButtonText: 'ok',
          nextButtonFunction: () {
            playerFinished.stop();
            playerFinished.release();

            Navigator.pop(context);
          },
        );
      },
    );
  }

  void _showStartedDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return DialogItem(
          icon: Lottie.asset('assets/lottie/started.json',
              height: 150, width: 150),
          title: 'Started!',
          paragraph: 'Your request has been started successfully',
          nextButtonText: 'ok',
          nextButtonFunction: () {
            playerStarted.stop();
            playerStarted.release();

            Navigator.pop(context);
          },
        );
      },
    );
  }

  void _showArrivedDialog(RequestDetailsEntity data) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return DialogItem(
          icon: Lottie.asset('assets/lottie/arrived.json',
              height: 150, width: 150),
          title: 'Provider Arrived!',
          paragraph:
              '${data.provider!.firstName} ${data.provider!.lastName} has arrived successfully.',
          nextButtonText: 'ok',
          nextButtonFunction: () {
            playerArrived.stop();
            playerArrived.release();

            Navigator.pop(context);
          },
        );
      },
    );
  }

  void _showAcceptDialog(RequestDetailsEntity data) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return DialogItem(
          icon: Lottie.asset('assets/lottie/accepted.json'),
          title: 'Accepted!',
          paragraph:
              'Your request has been accepted by ${data.provider!.firstName} ${data.provider!.lastName}',
          nextButtonText: 'ok',
          nextButtonFunction: () {
            playerAccepted.stop();
            playerAccepted.release();

            Navigator.pop(context);
          },
        );
      },
    );
  }

  void _showFeeDialog(String amount) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return CancellationFee(
          amount: amount,
          cancelHandler: () {
            Navigator.pop(context);
          },
          okHandler: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
    dataStreamController.close();

    playerAccepted.dispose();
    playerArrived.dispose();
    playerStarted.dispose();
    playerFinished.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    mapHeight = ((MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top) -
            56) *
        0.75;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _getCancelBloc(),
      child: Builder(builder: (context) {
        return BlocListener<CancelUserRequestBloc, CancelUserRequestState>(
          listener: (context, state) {
            _buildCancelListener(state, context);
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            body: StreamBuilder<RequestDetailsEntity>(
                stream: dataStreamController.stream.asBroadcastStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const LoadingWidget();
                  } else if (snapshot.hasData) {
                    RequestDetailsEntity data = snapshot.data!;
                    final mapWidget = ActiveRequestMap(
                      requestDetailsEntity: data,
                      dataStream: dataStreamController,
                    );
                    return Scaffold(
                      appBar: _buildAppBar(context, data),
                      body: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AnimatedContainer(
                                  duration: const Duration(seconds: 1),
                                  height: mapHeight,
                                  child: mapWidget),
                              ExpansionTile(
                                  leading: const Icon(
                                    Icons.document_scanner_outlined,
                                    color: Colors.grey,
                                  ),
                                  collapsedIconColor: Colors.grey,
                                  onExpansionChanged: (isExpanded) {
                                    setState(() {
                                      if (isExpanded) {
                                        mapHeight = ((MediaQuery.of(context)
                                                        .size
                                                        .height -
                                                    MediaQuery.of(context)
                                                        .padding
                                                        .top) -
                                                56) *
                                            0.1;
                                      } else {
                                        mapHeight = ((MediaQuery.of(context)
                                                        .size
                                                        .height -
                                                    MediaQuery.of(context)
                                                        .padding
                                                        .top) -
                                                56) *
                                            0.75;
                                      }
                                    });
                                  },
                                  title: Text(
                                      AppLocalizations.of(context)!.details),
                                  children: [
                                    _buildInfo(
                                      data,
                                      context,
                                    ),
                                  ])
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const LoadingWidget();
                  }
                }),
          ),
        );
      }),
    );
  }

  Container _buildInfo(RequestDetailsEntity data, BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
              border: Border.all(
                width: 0.2,
                color: Colors.grey,
              ),
            ),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (data.payment?.total != null)
                    ..._buildTotal(context, data),
                  const SizedBox(
                    height: 10,
                  ),
                  if (data.status != null) _buildStatus(context, data),
                  const SizedBox(
                    height: 10,
                  ),
                  if (data.status == 'STARTED')
                    CustomTimer(
                      startedAt: DateTime.parse(data.startedAt!),
                    ),
                  if (data.serviceType != null &&
                      data.serviceType!.name != null)
                    _buildServiceTypeName(context, data),
                  if (data.paymentMode != null)
                    _buildPaymentMode(context, data),
                  if (data.startedAt != null) _buildData(context, data),
                  if (data.sAddress != null) _buildLocation(context, data),
                  if (data.afterComment != null && data.afterComment != '')
                    _buildProviderComment(context, data),
                  if (data.afterImage != null && data.afterImage!.isNotEmpty)
                    _buildAfterImageList(context, data),
                  if (data.notes.isNotEmpty) ...[
                      const SizedBox(
          height: 10,
        ),
                     const Divider(),

                    _buildNoteMode(context, data),],
                  if (data.beforeImage != null && data.beforeImage!.isNotEmpty)
                    _buildBeforeImageList(context, data),
                  const SizedBox(
                    height: 16,
                  ),
                  _buildBottomSheet(data, context)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheet(RequestDetailsEntity data, BuildContext context) {
    switch (data.status) {
      case "COMPLETED":
        return _viewInvoiceBtn(context, data);
      case "SEARCHING":
      case "ACCEPTED":
      case "SCHEDULED":
      case "ARRIVED":
        return _buildCancelBtn(context, data, widget.requestId);
      default:
        return Container();
    }
  }

  AppBar _buildAppBar(BuildContext context, RequestDetailsEntity data) {
    return AppBar(
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              UserScreen.routName,
              (route) => false,
              arguments: {
                'showExploreScreen': true,
              },
            );
          },
          style: TextButton.styleFrom(foregroundColor: Colors.white),
          child: Text(
            AppLocalizations.of(context)!.services,
          ),
        )
      ],
      title: Text(AppLocalizations.of(context)!.detailsServiceLabel),
    );
  }

  void _buildCancelListener(
      CancelUserRequestState state, BuildContext context) {
    if (state is CancelUserRequestOfflineState) {
      ToastUtils.showErrorToastMessage('No internet Connection');
    } else if (state is CancelUserRequestErrorState) {
      ToastUtils.showErrorToastMessage('An error has ocurred, try again');
    } else if (state is DoneCancelUserRequest) {
      ToastUtils.showSusToastMessage(
          'The request has been cancelled successfully');
      Navigator.pushNamedAndRemoveUntil(
          context, UserScreen.routName, (route) => false,
          arguments: {'showExploreScreen': null, 'requestId': null});
    }
  }

  CancelUserRequestBloc _getCancelBloc() {
    return CancelUserRequestBloc(
      cancelRequestUseCase: CancelRequestUseCase(
        exploreServicesRepo: ExploreServicesRepoImpl(
          exploreServicesDataSource: ExploreServicesDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTotal(BuildContext context, RequestDetailsEntity data) {
    return [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            AppLocalizations.of(context)?.priceLabel ?? "",
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          const Spacer(),
          AppText(
            '${data.payment?.total} ${AppLocalizations.of(context)?.uadLabel ?? ""}',
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),

    ];
  }

  DetailRequestItem _buildStatus(
      BuildContext context, RequestDetailsEntity data) {
    return DetailRequestItem(
      title: AppLocalizations.of(context)?.statusLabel ?? "",
      subTitle: '${data.status}',
    );
  }

  DetailRequestItem _buildProviderComment(
      BuildContext context, RequestDetailsEntity data) {
    return DetailRequestItem(
      title: AppLocalizations.of(context)?.provider_comment ?? "",
      subTitle: '${data.afterComment}',
    );
  }

  DetailRequestItem _buildServiceTypeName(
      BuildContext context, RequestDetailsEntity data) {
    return DetailRequestItem(
      title: AppLocalizations.of(context)!.typeOfService,
      subTitle: data.serviceType?.name ?? "",
    );
  }

  DetailRequestItem _buildPaymentMode(
      BuildContext context, RequestDetailsEntity data) {
    return DetailRequestItem(
      title: AppLocalizations.of(context)!.paymentMethod,
      subTitle: data.paymentMode ?? "",
    );
  }

  Widget _buildNoteMode(
      BuildContext context, RequestDetailsEntity data) {
    return DetailRequestItem(
      title: 'Your Notes',
      subTitle: data.notes,
    );
  }

  DetailRequestItem _buildData(
      BuildContext context, RequestDetailsEntity data) {
    return DetailRequestItem(
      title: AppLocalizations.of(context)?.serviceDate ?? "",
      subTitle: data.startedAt ?? "",
    );
  }

  DetailRequestItem _buildLocation(
      BuildContext context, RequestDetailsEntity data) {
    return DetailRequestItem(
        title: AppLocalizations.of(context)!.serviceLocation,
        subTitle: data.sAddress ?? "",
        isLast: false);
  }

  Widget _buildBeforeImageList(
      BuildContext context, RequestDetailsEntity data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        AppText(
          AppLocalizations.of(context)?.attachmentsLabel ?? "",
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: 200.0,
            child: Row(children: [
              ...List.generate(data.beforeImage!.length, (index) {
                dynamic item = data.beforeImage![index];

                return Row(
                  children: [
                    ImageItem(
                      isFile: false,
                      image: item,
                    ),
                    const SizedBox(width: 8),
                  ],
                );
              }),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildAfterImageList(BuildContext context, RequestDetailsEntity data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        AppText(
          AppLocalizations.of(context)?.images_from_provider ?? "",
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: 200.0,
            child: Row(
              children: List.generate(data.afterImage!.length, (index) {
                dynamic item = data.afterImage![index];

                return Row(
                  children: [
                    ImageItem(
                      isFile: false,
                      image: item,
                    ),
                    const SizedBox(width: 8),
                  ],
                );
              }),
            ),
          ),
        ),

      ],
    );
  }

  Container _viewInvoiceBtn(BuildContext context, RequestDetailsEntity data) {
    return Container(
      height: 50,
      child: AppButton(
        title: AppLocalizations.of(context)?.invoiceDetailsLabel ?? "",
        onTap: () {
          Navigator.pushNamed(context, UserInvoiceRequestScreen.routeName,
              arguments: {
                'data': data,
              });
        },
      ),
    );
  }

  Widget _buildCancelBtn(
      BuildContext context, RequestDetailsEntity data, int id) {
    return Container(
      height: 50,
      child: BlocBuilder<CancelUserRequestBloc, CancelUserRequestState>(
        builder: (context, state) {
          return AppButton(
            isLoading: state is LoadingCancelUserRequest,
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return CancelReasonDialog(handler: (value) async {
                    BlocProvider.of<CancelUserRequestBloc>(context)
                        .add(CancelUserRequest(id: id, reason: value));
                  });
                },
              );
            },
            title: AppLocalizations.of(context)?.cancel ?? "",
          );
        },
      ),
    );
  }
}
