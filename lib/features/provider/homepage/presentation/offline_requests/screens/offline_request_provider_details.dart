import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../../core/api_service/network_service_http.dart';
import '../../../../../../core/ui/dialogs/loading_dialog.dart';
import '../../../../../../core/ui/widgets/app_button.dart';
import '../../../../../../core/ui/widgets/app_dialog.dart';
import '../../../../../../core/ui/widgets/app_text.dart';
import '../../../../../../core/ui/widgets/custom_map.dart';
import '../../../../../../core/ui/widgets/gallery.dart';
import '../../../../../../core/ui/widgets/profile/mini_avatar.dart';
import '../../../../../../core/ui/widgets/small_button.dart';
import '../../../../../../core/utils/helpers/launching_map.dart';
import '../../../../../../core/utils/helpers/show_custom_bottom_sheet.dart';
import '../../../../../../core/utils/helpers/toast_utils.dart';
import '../../../../../navigation/screens/provider_screen.dart';
import '../../../data/date_source/provider_data_source.dart';
import '../../../data/repositories/provider_repo_impl.dart';
import '../../../domain/entities/offline_request_entity.dart';
import '../../../domain/use_cases/accept_request_use_case.dart';
import '../../../domain/use_cases/reject_request_use_case.dart';
import '../../../domain/use_cases/suggest_time_use_case.dart';
import '../../coming_request/bloc/accepting_rejecting_bloc.dart';
import '../../coming_request/bloc/suggest_time_bloc.dart';
import '../../coming_request/screen/provider_schedule_request.dart';
import '../../working_state/bloc/fetch_offline_requests_bloc.dart';

class OfflineRequestProviderDetails extends StatelessWidget {
  static const routeName = 'offline_request_provider_details';
  final OfflineRequestEntity data;
  const OfflineRequestProviderDetails({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
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
                _buildAcceptingRejctingListener(state, context);
              }),
              BlocListener<SuggestTimeBloc, SuggestTimeState>(
                listener: (context, state) {
                  _buildSuggestListener(state, context);
                },
              ),
            ],
            child: _buildData(context),
          );
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
       Navigator.pop(context);
      ToastUtils.showSusToastMessage(
        'The suggested time has been set successfully',
      );
      BlocProvider.of<FetchOfflineRequestsBloc>(context).add(
        GetOfflineRequestsEvent(),
      );
    }
  }

  Scaffold _buildData(
    BuildContext context,
  ) {
    return Scaffold(
        appBar: AppBar(
          title: Text(data.bookingId!),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildMap(context),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildDirectionBtn(
                          context,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        if (data.beforeImage!.isNotEmpty)
                          _buildImageBtn(
                            context,
                          ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    _buildLocation(),
                    const SizedBox(
                      height: 20,
                    ),
                    if (data.scheduleAt != null) ...[
                      _buildScheduleAt(
                        context,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                    const Divider(height: 4),
                    const SizedBox(
                      height: 14,
                    ),
                    _buildServiceType(
                      context,
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    const Divider(height: 4),
                    const SizedBox(
                      height: 14,
                    ),
                    if (data.notes != null) _buildNotes(),
                    const SizedBox(
                      height: 80,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomSheet: _buildBottomBtn(context,),);
  }

  SizedBox _buildMap(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: CustomMap(
        lat: data.sLatitude!,
        lng: data.sLongitude!,
      ),
    );
  }

  Text _buildNotes() => Text(data.notes!,
      style: const TextStyle(
        fontWeight: FontWeight.normal,
      ));

  SizedBox _buildBottomBtn(
    BuildContext context,
  ) {
    return SizedBox(
      height: 80,
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: _buildAcceptAndRejectAndSuggest(context,),),
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

  Row _buildScheduleAt(
    BuildContext context,
  ) {
    return Row(
      children: [
        const Icon(Icons.calendar_month, color: Colors.green),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            AppLocalizations.of(context)!.custom_date_time(
              DateTime.parse(
                data.scheduleAt!,
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

  SmallButton _buildImageBtn(
    BuildContext context,
  ) {
    return SmallButton(
      color: Theme.of(context).primaryColor.withOpacity(0.2),
      textColor: Theme.of(context).primaryColor,
      onTap: () {
        Navigator.pushNamed(
          context,
          Gallery.routeName,
          arguments: {'images': data.beforeImage},
        );
      },
      title: AppLocalizations.of(context)?.viewImage ?? "",
    );
  }

  void _buildAcceptingRejctingListener(
      AcceptingRejectingState state, BuildContext context) {
    if (state is LoadingAcceptingRejecting) {
      showLoadingDialog(context, showText: false);
    } else if (state is AcceptingRejectingOfflineState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage('No internet Connection');
    } else if (state is AcceptingRejectingErrorState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage('error (${state.message})');
    } else if (state is LoadedAcceptingRejecting) {
      Navigator.pop(context);
      Navigator.pop(context);
      ToastUtils.showSusToastMessage(state.isAccepted
          ? 'Request has been accepted'
          : 'Request has been rejected');

      BlocProvider.of<FetchOfflineRequestsBloc>(context)
          .add(GetOfflineRequestsEvent());
    }
  }

  ElevatedButton _buildDirectionBtn(
    BuildContext context,
  ) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.send_rounded, color: Colors.white),
      label: Text(
        AppLocalizations.of(context)!.directions,
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      onPressed: () async {
        final lat = data.sLatitude!;
        final lng = data.sLongitude!;

        if (Platform.isAndroid) {
          await LaunchingMapHelper.showGoogleMap(lat, lng);
        } else if (Platform.isIOS) {
          await LaunchingMapHelper.showAppleMap(lat, lng);
        }
      },
    );
  }

  Widget _buildLocation() {
    return Row(
      children: [
        const Icon(Icons.location_pin),
        const SizedBox(width: 8),
        Flexible(
          child: AppText(
            '${data.sAddress}' ?? '',
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  // Widget _buildNamePictureUser() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.stretch,
  //     children: [
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         children: [
  //           MiniAvatar(
  //             url: data.user!.picture,
  //             name: '${data.user!.firstName}' ?? '',
  //           ),
  //           const SizedBox(
  //             width: 10,
  //           ),
  //           Flexible(
  //             child: AppText(
  //               '${data.user!.firstName!} ${data.user!.lastName!}',
  //               bold: true,
  //             ),
  //           ),
  //         ],
  //       ),
  //       const SizedBox(height: 4),
  //       if (data.notes!.isNotEmpty)
  //         Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 50),
  //           child: _buildNotes(),
  //         ),
  //     ],
  //   );
  // }

  Row _buildServiceType(
    BuildContext context,
  ) {
    return Row(
      children: [
        Text(AppLocalizations.of(context)!.serviceType,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text('${data.serviceName}' ?? '',
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
              child: ProviderScheduleRequest(requestId: data.id!),
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
                    .add(RejectRequestEvent(id: data.id!));
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
                    .add(AcceptRequestEvent(id: data.id!));
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
}
