import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:image_picker/image_picker.dart';
import 'package:masbar/features/user/services/presentation/request_service/user_choosen/widgets/step4/user_schedule_service.dart';

import '../../../../../../../../core/ui/widgets/app_button.dart';
import '../../../../../../../../core/ui/widgets/app_switch.dart';
import '../../../../../../../../core/ui/widgets/app_text.dart';
import '../../../../../../../../core/ui/widgets/app_textfield.dart';
import '../../../../../../../../core/ui/widgets/image_item.dart';
import '../../../../../../../../core/utils/helpers/form_submission_state.dart';
import '../../../../../../../../core/utils/helpers/pick_image.dart';
import '../../../../../../../../core/utils/helpers/toast_utils.dart';
import '../../bloc/user_create_request_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BusyStep4 extends StatelessWidget {
  final Function changeCurrentTab;
  const BusyStep4({
    Key? key,
    required this.changeCurrentTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
       return    BlocListener<UserCreateRequestBloc, UserCreateRequestState>(
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
                 // _buildScheduleRow(context),
                    Text('Schedule Date'),
                  const SizedBox(
                    height: 14,
                  ),
                  _buildSelecteDateTime(context),
                  const SizedBox(height: 18.0),
                  AppText(
                    AppLocalizations.of(context)?.attachmentsLabel ?? "",
                    // color: Theme.of(context).primaryColor,
                    bold: true,
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
                  _buildNotes(context),   ],

              ),
            ),
          ),
        ),
        bottomNavigationBar: _buildCreateRequestBtn(context),
      ),
    );
  }

  void _buildListener(UserCreateRequestState state) async {
    if (state.formSubmissionState is FormNoInternetState) {
      ToastUtils.showErrorToastMessage('No internnet Connection');
    } else if (state.formSubmissionState is FormNetworkErrorState) {
      ToastUtils.showErrorToastMessage(
        (state.formSubmissionState as FormNetworkErrorState).message,
      );
    } else if (state.formSubmissionState is FormSuccesfulState) {
      changeCurrentTab(4
      );
    }
  }

  Widget _buildCreateRequestBtn(BuildContext context) {
    return BlocBuilder<UserCreateRequestBloc, UserCreateRequestState>(
      builder: (context, state) {
        return Padding(
              padding: const EdgeInsets.all(16.0),
              child: AppButton(
                isLoading: state.formSubmissionState is FormSubmittingState,
                onTap: () async {
                  if (state.isSchedule && state.scheduleDate == null) {
                    ToastUtils.showErrorToastMessage(
                        AppLocalizations.of(context)?.theLaterServiceError ??
                            "");
                  } else {
                    BlocProvider.of<UserCreateRequestBloc>(context)
                    .add(RequestBusyProviderEvent());
                  }
                },
                title: AppLocalizations.of(context)?.requestAServiceLabel ?? "",
              ),
            );
          },

    );
  }

  Row _buildScheduleRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: AppText(
            AppLocalizations.of(context)?.laterServiceMessage ?? "",
          ),
        ),
        _buildIsIsScheduleSwitch(context),
      ],
    );
  }

  Widget _buildSelecteDateTime(BuildContext context) {
    return BlocBuilder<UserCreateRequestBloc, UserCreateRequestState>(
      builder: (context, state) {
        return state.isSchedule ? const UserScheduleService() : Container();
      },
    );
  }

  Widget _buildIsIsScheduleSwitch(BuildContext context) {
    return BlocBuilder<UserCreateRequestBloc, UserCreateRequestState>(
      builder: (context, state) {
        return CustomSwitch(
          value: state.isSchedule,
          onChanged: () async {
            BlocProvider.of<UserCreateRequestBloc>(context)
                .add(IsScheduleChangedEvent());
          },
          inactiveColor: Colors.grey[300],
          activeColor: Theme.of(context).primaryColor,
        );
      },
    );
  }

  Widget _buildImageList(BuildContext context) {
    return BlocBuilder<UserCreateRequestBloc, UserCreateRequestState>(
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
                      BlocProvider.of<UserCreateRequestBloc>(context).add(
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
                BlocProvider.of<UserCreateRequestBloc>(context)
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
                BlocProvider.of<UserCreateRequestBloc>(context)
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
      child: BlocBuilder<UserCreateRequestBloc, UserCreateRequestState>(
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
   Widget _buildNotes(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText(
          'Notes - (Optional)',
          // color: Theme.of(context).primaryColor,
          bold: true,
        ),
        BlocBuilder<UserCreateRequestBloc, UserCreateRequestState>(
          builder: (context, state) => AppTextField(
            minLines: 3,
            maxLines: 5,
            hintText: 'Enter your notes',
              initialValue: state.note,
            onChanged: (value) {
              BlocProvider.of<UserCreateRequestBloc>(context)
                  .add(NoteChangedEvent(note: value));
            },
          ),
        ),
      ],
    );
  }


 
}
