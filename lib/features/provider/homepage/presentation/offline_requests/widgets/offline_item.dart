// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/ui/widgets/app_dialog.dart';
import '../../../../../../core/utils/helpers/show_custom_bottom_sheet.dart';
import '../../../domain/entities/offline_request_entity.dart';
import '../../coming_request/bloc/accepting_rejecting_bloc.dart';
import '../../coming_request/bloc/suggest_time_bloc.dart';
import '../../coming_request/screen/provider_schedule_request.dart';
import '../../working_state/bloc/fetch_offline_requests_bloc.dart';
import '../screens/offline_request_provider_details.dart';

class OfflineItem extends StatelessWidget {
  final OfflineRequestEntity data;
  const OfflineItem({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (c) {
              return BlocProvider.value(
                  value: BlocProvider.of<FetchOfflineRequestsBloc>(context),
                  child: OfflineRequestProviderDetails(data: data));
            },
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildName(),
              const SizedBox(
                height: 12,
              ),
              if (data.scheduleAt != null) ...[
                _buildScheduleTime(context),
                const SizedBox(
                  height: 12,
                ),
              ],
              _buildAddress(),
              const SizedBox(
                height: 12,
              ),
              if (data.acceptenceRole != null && data.acceptenceRole == 'User')
                _buildWaitngUser(),
              if (data.acceptenceRole == null || data.acceptenceRole != 'User')
                _buildBtn(context)
            ],
          ),
        ),
      ),
    );
  }

  Row _buildBtn(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildRejectBtn(context, data.id!),
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: _buildSuggestAnotherTimeBtn(context, data.id!),
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: _buildAcceptBtn(context, data.id!),
        ),
      ],
    );
  }

  Row _buildWaitngUser() {
    return Row(
      children: [
         const Icon(Icons.timer_outlined, color: Colors.blue),

        const SizedBox(width: 4),
        Text(
          'Waiting user decision',
          maxLines: 1,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Row _buildAddress() {
    return Row(
      children: [
        const Icon(Icons.location_on, color: Colors.green),
        const SizedBox(width: 4),
        Text(
          data.sAddress!,
          maxLines: 1,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Row _buildScheduleTime(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.calendar_month),
        const SizedBox(width: 4),
        Text(
          AppLocalizations.of(context)!.custom_date_time(
            DateTime.parse(
              data.scheduleAt!,
            ),
          ),
          maxLines: 1,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Text _buildName() {
    return Text(
      '${data.bookingId!} - ${data.serviceName!}',
      maxLines: 1,
      style: const TextStyle(
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildSuggestAnotherTimeBtn(BuildContext context, int id) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
      ),
      onPressed: () {
        showCustomBottomSheet(
            context: context,
            child: BlocProvider.value(
              value: context.read<SuggestTimeBloc>(),
              child: ProviderScheduleRequest(requestId: id),
            ));
      },
      child: Text(
        'Suggest Another Time',
        maxLines: 1,
        style: const TextStyle(overflow: TextOverflow.ellipsis),
      ),
    );
  }

  Widget _buildRejectBtn(BuildContext context, int id) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
      onPressed: () {
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
                    .add(RejectRequestEvent(id: id));
                Navigator.pop(context);
              },
              cancelButtonFunction: () {
                Navigator.pop(context);
              },
            );
          },
        );
      },
      child: Text(AppLocalizations.of(context)!.rejectLabel,
          maxLines: 1, style: const TextStyle(overflow: TextOverflow.ellipsis)),
    );
  }

  Widget _buildAcceptBtn(BuildContext context, int id) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor),
      onPressed: () {
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
                    .add(AcceptRequestEvent(id: id));
                Navigator.pop(context);
              },
              cancelButtonFunction: () {
                Navigator.pop(context);
              },
            );
          },
        );
      },
      child: Text(AppLocalizations.of(context)!.acceptLabel,
          maxLines: 1, style: const TextStyle(overflow: TextOverflow.ellipsis)),
    );
  }
}
