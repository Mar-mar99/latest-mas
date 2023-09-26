// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:masbar/core/ui/widgets/app_dialog.dart';
import '../../../../../../core/api_service/network_service_http.dart';
import '../../../../../../core/ui/dialogs/cancel_reason_dialog.dart';
import '../../../../../../core/ui/dialogs/loading_dialog.dart';
import '../../../../../../core/ui/widgets/app_button.dart';
import '../../../../../../core/ui/widgets/app_text.dart';
import '../../../../../../core/ui/widgets/custom_map.dart';
import '../../../../../../core/ui/widgets/error_widget.dart';
import '../../../../../../core/ui/widgets/image_item.dart';
import '../../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../../core/ui/widgets/no_connection_widget.dart';
import '../../../../../../core/utils/helpers/show_custom_bottom_sheet.dart';
import '../../../../../../core/utils/helpers/toast_utils.dart';
import '../../../data/data_source/explore_services_data_source.dart';
import '../../../data/repositories/explore_services_repo_impl.dart';
import '../../../domain/entities/request_details_entity.dart';
import '../../../domain/use_cases/accept_provider_schdule_use_case.dart';
import '../../../domain/use_cases/cancel_request_use_case.dart';
import '../../../domain/use_cases/get_request_details_use_case.dart';
import '../../../domain/use_cases/request_offline_provider_use_case.dart';
import '../../service_details.dart/bloc/cancel_user_request_bloc.dart';
import '../../service_details.dart/bloc/request_details_bloc.dart';
import '../bloc/accept_schedule_bloc.dart';
import '../bloc/reschedule_request_bloc.dart';
import '../widgets/reschedule_request_sheet.dart';

class NewScheduleScreen extends StatelessWidget {
  final int id;
  const NewScheduleScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _buildDetailsBloc(),
        ),
        BlocProvider(
          create: (context) => _buildAcceptBloc(),
        ),
        BlocProvider(
          create: (context) => _getCancelBloc(),
        ),
        BlocProvider(create: (context) => _getRescheduleBloc()),
      ],
      child: Builder(builder: (context) {
        return MultiBlocListener(
          listeners: [
            BlocListener<AcceptScheduleBloc, AcceptScheduleState>(
              listener: (context, state) {
                _acceptListener(state, context);
              },
            ),
            BlocListener<CancelUserRequestBloc, CancelUserRequestState>(
                listener: (context, state) {
              _buildCancelListener(state, context);
            }),
            BlocListener<RescheduleRequestBloc, RescheduleRequestState>(
                listener: (context, state) {
              _buildRescheduleListener(state, context);
            }),
          ],
          child: BlocBuilder<RequestDetailsBloc, RequestDetailsState>(
            builder: (context, state) {
              if (state is LoadingRequestDetails) {
                return _buildLoading();
              } else if (state is RequestDetailsOfflineState) {
                return _buildOffline(context);
              } else if (state is RequestDetailsErrorState) {
                return _buildNetworkError(state, context);
              } else if (state is LoadedRequestDetails) {
                return _buildData(state, context);
              } else {
                return Container();
              }
            },
          ),
        );
      }),
    );
  }

  void _buildRescheduleListener(RescheduleRequestState state, BuildContext context) {
    if (state is LoadingRescheduleRequest) {
      showLoadingDialog(context, text: 'Rescheduling...');
    } else if (state is RescheduleRequestOfflineState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage('No internet Connection');
    } else if (state is RescheduleRequestErrorState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage(
          'An error has ocurred, try again');
    } else if (state is LoadedRescheduleRequest) {
      Navigator.pop(context);
      Navigator.pop(context);
      ToastUtils.showSusToastMessage(
        'The request has been rescheduled successfully',
      );
    }
  }

  RescheduleRequestBloc _getRescheduleBloc() {
    return RescheduleRequestBloc(
      requestOfflineProviderUseCase: RequestOfflineProviderUseCase(
        exploreServicesRepo: ExploreServicesRepoImpl(
          exploreServicesDataSource: ExploreServicesDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    );
  }

  void _buildCancelListener(
      CancelUserRequestState state, BuildContext context) {
    if (state is LoadingCancelUserRequest) {
      showLoadingDialog(context, text: 'Rejecting...');
    } else if (state is CancelUserRequestOfflineState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage('No internet Connection');
    } else if (state is CancelUserRequestErrorState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage('An error has ocurred, try again');
    } else if (state is DoneCancelUserRequest) {
      Navigator.pop(context);
      Navigator.pop(context);
      ToastUtils.showSusToastMessage(
        'The request has been cancelled successfully',
      );
    }
  }

  RequestDetailsBloc _buildDetailsBloc() {
    return RequestDetailsBloc(
        getRequestDetailsUseCase: GetRequestDetailsUseCase(
      exploreServicesRepo: ExploreServicesRepoImpl(
        exploreServicesDataSource: ExploreServicesDataSourceWithHttp(
          client: NetworkServiceHttp(),
        ),
      ),
    ))
      ..add(LoadRequestDetails(id: id));
  }

  AcceptScheduleBloc _buildAcceptBloc() {
    return AcceptScheduleBloc(
        acceptProviderScheduleUseCase: AcceptProviderScheduleUseCase(
      exploreServicesRepo: ExploreServicesRepoImpl(
        exploreServicesDataSource: ExploreServicesDataSourceWithHttp(
          client: NetworkServiceHttp(),
        ),
      ),
    ));
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

  void _acceptListener(AcceptScheduleState state, BuildContext context) {
    if (state is LoadingAcceptSchedule) {
      showLoadingDialog(context, text: 'Accepting...');
    } else if (state is AcceptScheduleOfflineState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage('No internet Connection');
    } else if (state is AcceptScheduleErrorState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage('error (${state.message})');
    } else if (state is LoadedAcceptSchedule) {
      Navigator.pop(context);
      Navigator.pop(context);

      ToastUtils.showSusToastMessage(
        'Accepted Successfully',
      );
    }
  }

  Scaffold _buildData(LoadedRequestDetails state, BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          state.data.bookingId!,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (state.data.sLatitude != null && state.data.sLongitude != null)
              _buildMap(context, state.data),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildLocation(state.data.sAddress ?? ''),
                  const SizedBox(
                    height: 14,
                  ),
                  const Divider(height: 4),
                  const SizedBox(
                    height: 14,
                  ),
                  if (state.data.scheduleAt != null) ...[
                    _buildScheduleAt(context, state.data),
                    const SizedBox(
                      height: 14,
                    ),
                  ],
                  const Divider(height: 4),
                  const SizedBox(
                    height: 14,
                  ),
                  _buildServiceType(context, state.data),
                  const SizedBox(
                    height: 14,
                  ),
                  const Divider(height: 4),
                  const SizedBox(
                    height: 14,
                  ),
                  if (state.data.beforeImage!.isNotEmpty)
                    _buildBeforeImageList(context, state.data),
                  const SizedBox(
                    height: 14,
                  ),
                  _buildNotes(state.data),
                  const SizedBox(
                    height: 80,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: _buildBottomBtn(context, state.data),
    );
  }

  Scaffold _buildNetworkError(
      RequestDetailsErrorState state, BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: NetworkErrorWidget(
          message: state.message,
          onPressed: () {
            BlocProvider.of<RequestDetailsBloc>(context)
                .add(LoadRequestDetails(id: id));
          },
        ),
      ),
    );
  }

  Scaffold _buildOffline(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: NoConnectionWidget(
          onPressed: () {
            BlocProvider.of<RequestDetailsBloc>(context)
                .add(LoadRequestDetails(id: id));
          },
        ),
      ),
    );
  }

  Scaffold _buildLoading() {
    return Scaffold(appBar: AppBar(title: Text('')), body: LoadingWidget());
  }

  Widget _buildBeforeImageList(
      BuildContext context, RequestDetailsEntity data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Attachments',
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

  SizedBox _buildMap(BuildContext context, RequestDetailsEntity data) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: CustomMap(
        lat: data.sLatitude!,
        lng: data.sLongitude!,
      ),
    );
  }

  Text _buildNotes(RequestDetailsEntity data) => Text(data.notes,
      style: const TextStyle(
        fontWeight: FontWeight.normal,
      ));

  SizedBox _buildBottomBtn(BuildContext context, RequestDetailsEntity data) {
    return SizedBox(
      height: 80,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: _buildAcceptAndRejectAndSuggest(context, data),
      ),
    );
  }

  Row _buildAcceptAndRejectAndSuggest(
      BuildContext context, RequestDetailsEntity data) {
    return Row(
      children: [
        Expanded(child: _buildRejectBtn(context)),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: _buildSuggestAnotherTimeBtn(context,data),
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: _buildAcceptBtn(context, data),
        ),
      ],
    );
  }

  Widget _buildScheduleAt(BuildContext context, RequestDetailsEntity data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Provider Suggested Time:'),
        const SizedBox(height: 8),
        Row(
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
        ),
      ],
    );
  }

  Widget _buildLocation(String sAddress) {
    return Row(
      children: [
        const Icon(Icons.location_pin),
        const SizedBox(width: 8),
        Flexible(
          child: AppText(
            '${sAddress}',
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Row _buildServiceType(BuildContext context, RequestDetailsEntity data) {
    return Row(
      children: [
        Text(AppLocalizations.of(context)!.serviceType,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
              data.serviceType == null ? '' : data.serviceType!.name ?? '',
              style: const TextStyle(fontWeight: FontWeight.normal)),
        ),
      ],
    );
  }

  AppButton _buildSuggestAnotherTimeBtn(
      BuildContext context, RequestDetailsEntity data) {
    return AppButton(
      title: ("Suggest Another Time").toUpperCase(),
      buttonColor: ButtonColor.green,
      onTap: () {
        showCustomBottomSheet(
          context: context,
          child: ReschuleRequestSheet(
            handlerOk: (date) {
              BlocProvider.of<RescheduleRequestBloc>(context).add(
                RescheduleEvent(
                  scheduleDate: date,
                  scheduleTime: date,
                  requestId: id,
                  providerId: data.currentProviderId!,
                ),
              );
            },
          ),
        );
      },
    );
  }

  AppButton _buildRejectBtn(BuildContext context) {
    return AppButton(
      title: ("No, thanks").toUpperCase(),
      buttonColor: ButtonColor.transparentBorderPrimary,
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
    );
  }

  AppButton _buildAcceptBtn(BuildContext context, RequestDetailsEntity data) {
    return AppButton(
      title: (AppLocalizations.of(context)!.acceptLabel).toUpperCase(),
      onTap: () {
        BlocProvider.of<AcceptScheduleBloc>(context).add(
            AcceptEvent(requestId: id, providerId: data.currentProviderId!));
      },
    );
  }
}
