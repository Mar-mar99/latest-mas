// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:feather_icons/feather_icons.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masbar/core/constants/api_constants.dart';

import 'package:masbar/core/utils/helpers/form_submission_state.dart';
import 'package:masbar/features/user/services/presentation/request_service/masbar_choosen/bloc/create_request_bloc.dart';
import 'package:masbar/features/user/services/presentation/request_service/masbar_choosen/widgets/step3/schedule_service.dart';

import '../../../../../../../../core/ui/widgets/app_button.dart';
import '../../../../../../../../core/ui/widgets/app_drop_down.dart';
import '../../../../../../../../core/ui/widgets/app_text.dart';
import '../../../../../../../../core/ui/widgets/app_switch.dart';
import '../../../../../../../../core/ui/widgets/app_textfield.dart';
import '../../../../../../../../core/ui/widgets/image_item.dart';
import '../../../../../../../../core/utils/helpers/pick_image.dart';
import '../../../../../../../../core/utils/helpers/show_custom_bottom_sheet.dart';
import '../../../../../../../../core/utils/helpers/toast_utils.dart';
import 'package:http/http.dart' as http;

import '../../../../../domain/entities/created_request_result_entity.dart';

class Step3 extends StatelessWidget {
  final Function changeCurrentTab;
   Step3({
    Key? key,
    required this.changeCurrentTab,
  }) : super(key: key);
final noteController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateRequestBloc, CreateRequestState>(
      listener: (context, state) async {
        _buildListener(state);
      },
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Icon(Icons.calendar_today),
                      const SizedBox(
                        width: 8,
                      ),
                      AppText(
                        AppLocalizations.of(context)!.schedule_service,
                        bold: true,
                      ),
                    ],
                  ),
                  _buildScheduleRow(context),
                  const SizedBox(
                    height: 4,
                  ),
                  _buildSelecteDateTime(context),
                  const SizedBox(
                    height: 8.0,
                  ),
                  const Divider(
                    height: 16,
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    children: [
                      Icon(Icons.attach_file),
                      const SizedBox(
                        width: 8,
                      ),
                      AppText(
                        AppLocalizations.of(context)?.attachmentsLabel ?? "",
                        // color: Theme.of(context).primaryColor,
                        bold: true,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4.0,
                  ),
                  AppText(
                    AppLocalizations.of(context)?.attachmentsMessage ?? "",
                    color: Colors.grey[700],
                  ),
                  const SizedBox(height: 18.0),
                  _buildAddImageRow(context),
                  const SizedBox(height: 18.0),
                  _buildRestrictonImageNumberText(context),
                  const SizedBox(height: 18.0),
                  _buildImageList(context),
                  const SizedBox(
                    height: 8.0,
                  ),
                  const Divider(
                    height: 16,
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  _buildNotes(context),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: _buildCreateRequestBtn(context),
      ),
    );
  }

  Widget _buildNotes(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(Icons.note_add_outlined),
            const SizedBox(
              width: 8,
            ),
            AppText(
              'Notes - (Optional)',
              // color: Theme.of(context).primaryColor,
              bold: true,
            ),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        BlocBuilder<CreateRequestBloc, CreateRequestState>(
          builder: (context, state) => AppTextField(
            autofocus: false,
            minLines: 3,
            maxLines: 5,
            hintText: 'Enter your notes',
            focusNode: FocusNode(canRequestFocus: false),
            initialValue: state.note,
            onChanged: (value) {
              BlocProvider.of<CreateRequestBloc>(context)
                  .add(NoteChangedEvent(note: value));
            },
          ),
        ),
      ],
    );
  }

  void _buildListener(CreateRequestState state) async {
    if (state.formSubmissionState is FormNoInternetState) {
      ToastUtils.showErrorToastMessage('No internnet Connection');
    } else if (state.formSubmissionState is FormNetworkErrorState) {
      ToastUtils.showErrorToastMessage(
        (state.formSubmissionState as FormNetworkErrorState).message,
      );
    } else if (state.formSubmissionState is FormSuccesfulState) {
      //  await sendNotificationToProvider(state.createdRequestResultEntity);
      changeCurrentTab(4);
    }
  }

  Widget _buildCreateRequestBtn(BuildContext context) {
    return BlocBuilder<CreateRequestBloc, CreateRequestState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: AppButton(
            isLoading: state.formSubmissionState is FormSubmittingState,
            onTap: () async {
              if (state.isSchedule && state.scheduleDate == null) {
                ToastUtils.showErrorToastMessage(
                    AppLocalizations.of(context)?.theLaterServiceError ?? "");
              } else {
                BlocProvider.of<CreateRequestBloc>(context)
                    .add(SubmitRequestEvent());
              }
            },
            title: AppLocalizations.of(context)?.requestAServiceLabel ?? "",
          ),
        );
      },
    );
  }

  Widget _buildScheduleRow(BuildContext context) {
    return BlocBuilder<CreateRequestBloc, CreateRequestState>(
        builder: (context, state) {
      return ListTile(
        contentPadding: EdgeInsets.zero,
        onTap: () {
          BlocProvider.of<CreateRequestBloc>(context)
              .add(IsScheduleChangedEvent());
        },
        title: AppText(
          AppLocalizations.of(context)?.laterServiceMessage ?? "",
          color: state.isSchedule ? Colors.black : Colors.grey,
        ),
        trailing: IconButton(
            icon: Icon(
              Icons.check_circle,
              size: 24,
            ),
            onPressed: () {
              BlocProvider.of<CreateRequestBloc>(context)
                  .add(IsScheduleChangedEvent());
            },
            color: state.isSchedule ? Colors.green : Colors.grey.shade400),
      );
    });

    // Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   children: <Widget>[
    //     Flexible(
    //       child: AppText(
    //         AppLocalizations.of(context)?.laterServiceMessage ?? "",
    //       ),
    //     ),
    //     _buildIsIsScheduleSwitch(context),
    //   ],
    // );
  }

  Widget _buildSelecteDateTime(BuildContext context) {
    return BlocBuilder<CreateRequestBloc, CreateRequestState>(
      builder: (context, state) {
        return state.isSchedule ? const ScheduleService() : Container();
      },
    );
  }

  Widget _buildIsIsScheduleSwitch(BuildContext context) {
    return BlocBuilder<CreateRequestBloc, CreateRequestState>(
      builder: (context, state) {
        return CustomSwitch(
          value: state.isSchedule,
          onChanged: () async {
            BlocProvider.of<CreateRequestBloc>(context)
                .add(IsScheduleChangedEvent());
          },
          inactiveColor: Colors.grey[300],
          activeColor: Theme.of(context).primaryColor,
        );
      },
    );
  }

  Widget _buildImageList(BuildContext context) {
    return BlocBuilder<CreateRequestBloc, CreateRequestState>(
      builder: (context, state) {
        return Wrap(
            runSpacing: 4,
            spacing: 8,
            children: state.images
                .map((image) => ImageItem(
                    isFile: true,
                    fileImage: image,
                    showCancel: true,
                    handler: () async {
                      BlocProvider.of<CreateRequestBloc>(context).add(
                        RemoveImageChanged(
                          image: image,
                        ),
                      );
                    }))
                .toList());
      },
    );
  }

  SizedBox _buildAddImageRow(BuildContext context) {
    return SizedBox(
      height: 100.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildAddImageItem(
            context,
            AppLocalizations.of(context)!.galleryLabel,
            FeatherIcons.image,
            () async {
              File? image = await pickImage(context, ImageSource.gallery);
              if (image != null) {
                BlocProvider.of<CreateRequestBloc>(context)
                    .add(AddImageChanged(image: image));
              }
            },
          ),
          const SizedBox(width: 5.0),
          _buildAddImageItem(
            context,
            AppLocalizations.of(context)!.cameraLabel,
            FeatherIcons.camera,
            () async {
              File? image = await pickImage(context, ImageSource.camera);
              if (image != null) {
                BlocProvider.of<CreateRequestBloc>(context)
                    .add(AddImageChanged(image: image));
              }
            },
          ),
        ],
      ),
    );
  }

  Row _buildRestrictonImageNumberText(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 1.0),
            child: Icon(
              EvaIcons.infoOutline,
              size: 14.0,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(width: 18.0),
          Expanded(
            child: AppText(
              AppLocalizations.of(context)?.uploadImageMessage ?? "",
              color: Colors.grey[700],
            ),
          ),
        ]);
  }

  Widget _buildAddImageItem(
      BuildContext context, String title, IconData icon, Function handler) {
    return Expanded(
      child: BlocBuilder<CreateRequestBloc, CreateRequestState>(
        builder: (context, state) {
          return InkWell(
            onTap: state.images.length == 4
                ? null
                : () async {
                    handler();
                  },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: const Color.fromRGBO(244, 244, 244, 1.0),
                    width: 3.0),
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(icon,
                      size: 30.0,
                      color: state.images.length == 4
                          ? Colors.grey[600]
                          : Theme.of(context).primaryColor),
                  const SizedBox(height: 8.0),
                  AppText(
                    title,
                    color: Colors.grey[600],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // sendNotificationToProvider(
  //   CreatedRequestResultEntity? createdRequestResultEntity,
  // ) async {
  //   if (createdRequestResultEntity!.providerToken != '0') {
  //     var data = {
  //       'to': createdRequestResultEntity.providerToken,
  //       'notification': {
  //         'title': 'Masbar',
  //         'body': 'New Request',
  //         "content_available": true,
  //         "priority": "high"
  //       },
  //       "priority": "high",
  //       'data': {
  //         'TYPE': 'NEW REQUEST',
  //         'request_id': createdRequestResultEntity.requestId,
  //         "content_available": true,
  //         "priority": "high"
  //       }
  //     };

  //     await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //         body: jsonEncode(data),
  //         headers: {
  //           'Content-Type': 'application/json; charset=UTF-8',
  //           'Authorization': 'key=${dotenv.env['serverKey']!}'
  //         }).then(
  //       (value) {
  //         if (kDebugMode) {
  //           print('res ${value.body.toString()}');
  //         }
  //       },
  //     ).onError(
  //       (error, stackTrace) {
  //         if (kDebugMode) {
  //           print(error);
  //         }
  //       },
  //     );
  //   }
  // }
}
