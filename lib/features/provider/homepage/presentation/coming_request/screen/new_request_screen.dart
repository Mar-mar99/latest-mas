// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:masbar/features/provider/homepage/presentation/coming_request/screen/provider_schedule_request.dart';

import '../../../../../../core/api_service/network_service_http.dart';
import '../../../../../../core/ui/dialogs/loading_dialog.dart';
import '../../../../../../core/ui/widgets/app_button.dart';
import '../../../../../../core/ui/widgets/app_dialog.dart';
import '../../../../../../core/ui/widgets/app_text.dart';
import '../../../../../../core/ui/widgets/custom_map.dart';
import '../../../../../../core/ui/widgets/error_widget.dart';
import '../../../../../../core/ui/widgets/gallery.dart';
import '../../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../../core/ui/widgets/no_connection_widget.dart';
import '../../../../../../core/ui/widgets/profile/mini_avatar.dart';
import '../../../../../../core/ui/widgets/small_button.dart';
import '../../../../../../core/utils/enums/enums.dart';
import '../../../../../../core/utils/helpers/launching_map.dart';
import '../../../../../../core/utils/helpers/show_custom_bottom_sheet.dart';
import '../../../../../../core/utils/helpers/toast_utils.dart';
import '../../../../../navigation/screens/provider_screen.dart';
import '../../../data/date_source/provider_data_source.dart';
import '../../../data/repositories/provider_repo_impl.dart';
import '../../../domain/use_cases/accept_request_use_case.dart';
import '../../../domain/use_cases/get_incoming_request_details_use_case.dart';
import '../../../domain/use_cases/reject_request_use_case.dart';
import '../../../domain/use_cases/suggest_time_use_case.dart';
import '../../working_state/screens/homepage_provider_screen.dart';
import '../bloc/accepting_rejecting_bloc.dart';
import '../bloc/get_incoming_request_details_bloc.dart';
import '../bloc/suggest_time_bloc.dart';

class NewRequestScreen extends StatefulWidget {
  static const routeName = 'request_order_screen';
  final int id;
  final ProviderStatus requestType;
  const NewRequestScreen({
    Key? key,
    required this.id,
    required this.requestType,
  }) : super(key: key);

  @override
  State<NewRequestScreen> createState() => _NewRequestScreenState();
}

class _NewRequestScreenState extends State<NewRequestScreen>
    with AutomaticKeepAliveClientMixin {
  Timer? timer;
  DateTime d = DateTime.now();
  int time = 1;
  final player = AudioPlayer();
  @override
  void initState() {
    super.initState();
    _setAudioFile();
    _startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    player.release();
  }

  void _startTimer() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (mounted) {
          if (time == 180) {
            timer.cancel();
            player.stop();
            Navigator.pop(context);
          }
          setState(() {
            time = DateTime.now().difference(d).inSeconds;
          });
        }
      },
    );
  }

  void _setAudioFile() async {
    try {
      player
          .play(
        AssetSource("ring_60Sec.mp3"),
        volume: 1,
      )
          .catchError((onError) {
        print("Error: $onError");
      });
    } catch (e) {
      print("Error: $e");
    }
    player.onPlayerComplete.listen((event) {
      player.play(
        AssetSource("ring_60Sec.mp3"),
        volume: 1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _getBloc(),
        ),
        BlocProvider(
          create: (context) => _getAcceptRejectBloc(),
        ),
        BlocProvider(
          create: (context) => _getSuggestTimeBloc(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return MultiBlocListener(
              listeners: [
                BlocListener<AcceptingRejectingBloc, AcceptingRejectingState>(
                    listener: (context, state) {
                  _buildListener(state, context);
                }),
                BlocListener<SuggestTimeBloc, SuggestTimeState>(
                  listener: (context, state) {
                    _buildSuggestListener(state, context);
                  },
                ),
              ],
              child: BlocBuilder<GetIncomingRequestDetailsBloc,
                  GetIncomingRequestDetailsState>(
                builder: (context, state) {
                  if (state is LoadingGetRequestDetails) {
                    return _buildLoading(context);
                  } else if (state is GetRequestDetailsOfflineState) {
                    return _buildOffline(context);
                  } else if (state is GetRequestDetailsErrorState) {
                    return _buildError(context, state);
                  } else if (state is LoadedGetRequestDetails) {
                    return _buildData(
                      context,
                      state,
                    );
                  } else {
                    return Container();
                  }
                },
              ));
        },
      ),
    );
  }

  void _buildSuggestListener(SuggestTimeState state, BuildContext context) {
    if (state is LoadingSuggestTime) {
      showLoadingDialog(context, showText: false);
    } else if (state is SuggestTimeOfflineState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage('No internet Connection');
    } else if (state is SuggestTimeErrorState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage('error (${state.message})');
    } else if (state is LoadedSuggestTime) {
      Navigator.pop(context);
      Navigator.pop(context);
      ToastUtils.showSusToastMessage(
        'The suggested time has been set successfully',
      );
      Navigator.pushNamedAndRemoveUntil(
        context,
        ProviderScreen.routeName,
        (route) => false,
      );
    }
  }

  formatedTime() {
    int sec = time % 60;
    int min = (time / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute : $second";
  }

  Scaffold _buildData(BuildContext context, LoadedGetRequestDetails state) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.requestOrderLabel),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: CustomMap(
                  lat: state.data.sLatitude!,
                  lng: state.data.sLongitude!,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                50.0,
                              ),
                            ),
                          ),
                          child: Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: CircularProgressIndicator(
                                    color: Theme.of(context).primaryColor,
                                    backgroundColor: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.1),
                                    strokeWidth: 4,
                                    value: 1 / 180 * time,
                                  ),
                                ),
                                Center(
                                  child: AppText(
                                    '${formatedTime()}',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        _buildDirectionBtn(context, state),
                        const SizedBox(
                          width: 20,
                        ),
                        if (state.data.beforeImage!.isNotEmpty)
                          _buildImageBtn(context, state),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    _buildLocation(state),
                    const SizedBox(
                      height: 20,
                    ),
                    if (state.data.scheduleAt != null) ...[
                      _buildScheduleAt(context, state),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                    const Divider(height: 4),
                    const SizedBox(
                      height: 14,
                    ),
                    _buildServiceType(context, state),
                    const SizedBox(
                      height: 14,
                    ),
                    const Divider(height: 4),
                    const SizedBox(
                      height: 14,
                    ),
                    _buildNamePictureUser(state),
                    const SizedBox(
                      height: 80,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomSheet: _buildBottomBtn(context, state));
  }

  Text _buildNotes(LoadedGetRequestDetails state) => Text(
      state.data.notes!,
      style: const TextStyle(fontWeight: FontWeight.normal));

  SizedBox _buildBottomBtn(
      BuildContext context, LoadedGetRequestDetails state) {
    return SizedBox(
      height: 80,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: (state.data.status != 'USER_PICK') ||
                (state.data.status == 'USER_PICK' &&
                    widget.requestType == ProviderStatus.online)
            ? _buildAcceptAndReject(context)
            : (state.data.status == 'USER_PICK' &&
                    widget.requestType == ProviderStatus.busy)
                ? _buildAcceptAndRejectAndSuggest(context)
                : Container(),
      ),
    );
  }

  Row _buildAcceptAndRejectAndSuggest(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildRejectBtn(context)),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: _buildSuggestAnotherTimeBtn(context),
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: _buildAcceptBtn(context),
        ),
      ],
    );
  }

  Row _buildAcceptAndReject(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildRejectBtn(context)),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: _buildAcceptBtn(context),
        ),
      ],
    );
  }

  Row _buildScheduleAt(BuildContext context, LoadedGetRequestDetails state) {
    return Row(
      children: [
        const Icon(Icons.calendar_month, color: Colors.green),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            AppLocalizations.of(context)!.custom_date_time(
              DateTime.parse(
                state.data.scheduleAt!,
              ),
            ),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  Scaffold _buildError(
      BuildContext context, GetRequestDetailsErrorState state) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.requestOrderLabel),
      ),
      body: Center(
        child: NetworkErrorWidget(
            message: state.message,
            onPressed: () {
              BlocProvider.of<GetIncomingRequestDetailsBloc>(context)
                  .add(GetDetailsEvent(id: widget.id));
            }),
      ),
    );
  }

  Scaffold _buildOffline(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.requestOrderLabel),
      ),
      body: Center(
        child: NoConnectionWidget(onPressed: () {
          BlocProvider.of<GetIncomingRequestDetailsBloc>(context)
              .add(GetDetailsEvent(id: widget.id));
        }),
      ),
    );
  }

  Scaffold _buildLoading(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.requestOrderLabel),
        ),
        body: Center(child: const LoadingWidget()));
  }

  SmallButton _buildImageBtn(
      BuildContext context, LoadedGetRequestDetails state) {
    return SmallButton(
      color: Theme.of(context).primaryColor.withOpacity(0.2),
      textColor: Theme.of(context).primaryColor,
      onTap: () {
        Navigator.pushNamed(
          context,
          Gallery.routeName,
          arguments: {'images': state.data.beforeImage},
        );
      },
      title: AppLocalizations.of(context)?.viewImage ?? "",
    );
  }

  void _buildListener(AcceptingRejectingState state, BuildContext context) {
    if (state is LoadingAcceptingRejecting) {
      showLoadingDialog(context, showText: false);
    } else if (state is AcceptingRejectingOfflineState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage('No internet Connection');
    } else if (state is AcceptingRejectingErrorState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage('error (${state.message})');
    } else if (state is LoadedAcceptingRejecting) {
      player.stop();
      Navigator.pop(context);

      ToastUtils.showSusToastMessage(state.isAccepted
          ? 'Request has been accepted'
          : 'Request has been rejected');

      Navigator.pop(context);
    }
  }

  ElevatedButton _buildDirectionBtn(
      BuildContext context, LoadedGetRequestDetails state) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.send_rounded, color: Colors.white),
      label: Text(
        AppLocalizations.of(context)!.directions,
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      onPressed: () async {
        final lat = state.data.sLatitude!;
        final lng = state.data.sLongitude!;

        if (Platform.isAndroid) {
          await LaunchingMapHelper.showGoogleMap(lat, lng);
        } else if (Platform.isIOS) {
          await LaunchingMapHelper.showAppleMap(lat, lng);
        }
      },
    );
  }

  Widget _buildLocation(LoadedGetRequestDetails state) {
    return Row(
      children: [
        const Icon(Icons.location_pin),
        const SizedBox(width: 8),
        Flexible(
          child: AppText(
            '${state.data.sAddress}' ??
                '',
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildNamePictureUser(LoadedGetRequestDetails state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            MiniAvatar(
              url: state.data.user!.picture,
              name: '${state.data.user!.firstName}' ?? '',
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: AppText(
                '${state.data.user!.firstName!} ${state.data.user!.lastName!}',
                bold: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        if (state.data.notes!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: _buildNotes(state),
          ),
      ],
    );
  }

  Row _buildServiceType(BuildContext context, LoadedGetRequestDetails state) {
    return Row(
      children: [
        Text(AppLocalizations.of(context)!.serviceType,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
              '${state.data.serviceType!.name}' ??
                  '',
              style: const TextStyle(fontWeight: FontWeight.normal)),
        ),
      ],
    );
  }

  AppButton _buildSuggestAnotherTimeBtn(BuildContext context) {
    return AppButton(
      title: ("Suggest Another Time").toUpperCase(),
      buttonColor: ButtonColor.green,
      onTap: () {
        showCustomBottomSheet(
            context: context,
            child: BlocProvider.value(
              value: context.read<SuggestTimeBloc>(),
              child: ProviderScheduleRequest(requestId: widget.id),
            ));
      },
    );
  }

  AppButton _buildRejectBtn(BuildContext context) {
    return AppButton(
      title: (AppLocalizations.of(context)?.rejectLabel ?? "").toUpperCase(),
      buttonColor: ButtonColor.transparentBorderPrimary,
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext c) {
            return DialogItem(
              title: AppLocalizations.of(context)!.rejectTheRequest,
              paragraph: AppLocalizations.of(context)!.rejectTheRequestQuestion,
              cancelButtonText: AppLocalizations.of(context)!.cancelLabel,
              nextButtonText: AppLocalizations.of(context)!.rejectLabel,
              nextButtonFunction: () async {
                BlocProvider.of<AcceptingRejectingBloc>(context)
                    .add(RejectRequestEvent(id: widget.id));
                Navigator.pop(context);
              },
              cancelButtonFunction: () {
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  AppButton _buildAcceptBtn(BuildContext context) {
    return AppButton(
      title: (AppLocalizations.of(context)!.acceptLabel).toUpperCase(),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext c) {
            return DialogItem(
              title: AppLocalizations.of(context)?.acceptTheRequest ?? "",
              paragraph:
                  AppLocalizations.of(context)?.acceptTheRequestQuestion ?? "",
              cancelButtonText: AppLocalizations.of(context)?.cancelLabel ?? "",
              nextButtonText: AppLocalizations.of(context)?.acceptLabel ?? "",
              nextButtonFunction: () async {
                BlocProvider.of<AcceptingRejectingBloc>(context)
                    .add(AcceptRequestEvent(id: widget.id));
                Navigator.pop(context);
              },
              cancelButtonFunction: () {
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  AcceptingRejectingBloc _getAcceptRejectBloc() {
    return AcceptingRejectingBloc(
        acceptRequestUseCase: AcceptRequestUseCase(
          providerRepo: ProviderRepoImpl(
            providerDataSource: ProviderDataSourceWithHttp(
              client: NetworkServiceHttp(),
            ),
          ),
        ),
        rejectRequestUseCase: RejectRequestUseCase(
          providerRepo: ProviderRepoImpl(
            providerDataSource: ProviderDataSourceWithHttp(
              client: NetworkServiceHttp(),
            ),
          ),
        ));
  }

  GetIncomingRequestDetailsBloc _getBloc() {
    return GetIncomingRequestDetailsBloc(
      getRequestDetailsUseCase: GetIncomingRequestDetailsUseCase(
        providerRepo: ProviderRepoImpl(
          providerDataSource: ProviderDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    )..add(GetDetailsEvent(id: widget.id));
  }

  SuggestTimeBloc _getSuggestTimeBloc() {
    return SuggestTimeBloc(
        suggestTimeUseCase: SuggestTimeUseCase(
      providerRepo: ProviderRepoImpl(
        providerDataSource: ProviderDataSourceWithHttp(
          client: NetworkServiceHttp(),
        ),
      ),
    ));
  }

  @override
  bool get wantKeepAlive => true;
}
