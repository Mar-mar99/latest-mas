// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masbar/core/utils/helpers/form_submission_state.dart';
import 'package:masbar/core/utils/helpers/toast_utils.dart';

import 'package:masbar/features/provider/homepage/presentation/active_request/bloc/end_bloc.dart';

import '../../../../../../core/api_service/network_service_http.dart';
import '../../../../../../core/ui/widgets/app_button.dart';
import '../../../../../../core/ui/widgets/app_text.dart';
import '../../../../../../core/ui/widgets/app_textfield.dart';
import '../../../../../../core/ui/widgets/image_item.dart';
import '../../../../../../core/utils/helpers/pick_image.dart';
import '../../../data/date_source/provider_data_source.dart';
import '../../../data/repositories/provider_repo_impl.dart';
import '../../../domain/entities/request_provider_entity.dart';
import '../../../domain/use_cases/finish_working_use_case.dart';
import 'provider_invoice_request_screen.dart';

class AttachmentsEndServiceScreen extends StatelessWidget {
  static const routeName = 'attachments_end_service_screen';
  final RequestProviderEntity requestProviderEntity;
  const AttachmentsEndServiceScreen({
    Key? key,
    required this.requestProviderEntity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _getEndServiceBloc(),
      child: Builder(builder: (context) {
        return BlocListener<EndBloc, EndState>(
          listener: (context, state) {
            _buildEndListener(state, context);
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                AppLocalizations.of(context)!.completeServiceLabel,
              ),
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildCommentSection(context, requestProviderEntity.id!),
                    const SizedBox(height: 18.0),
                    _buildAddImage(context),
                    const SizedBox(height: 18.0),
                    _buildUpTo4Images(context),
                    const SizedBox(height: 18.0),
                    _buildImageList(context),
                  ],
                ),
              ),
            ),
            bottomNavigationBar:
                _buildEndBtn(context, requestProviderEntity.id!),
          ),
        );
      }),
    );
  }

  void _buildEndListener(EndState state, BuildContext context) {
    if (state.formSubmissionState is FormNoInternetState) {
      ToastUtils.showErrorToastMessage('No Internet Connection');
    } else if (state.formSubmissionState is FormNetworkErrorState) {
      ToastUtils.showErrorToastMessage('An error has ocurred, try again later');
    } else if (state.formSubmissionState is FormSuccesfulState) {
      ToastUtils.showSusToastMessage('The service has ended successfully');
      Navigator.pushNamedAndRemoveUntil(
        context,
        ProviderInvoiceRequestScreen.routeName,
        (route) => false,
        arguments: {
          'lat': requestProviderEntity.sLatitude,
          'lng': requestProviderEntity.sLongitude,
          'invoice': state.invoiceEntity,
          'id': requestProviderEntity.id
        },
      );
    }
  }

  Widget _buildEndBtn(BuildContext context, int id) {
    return BlocBuilder<EndBloc, EndState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: AppButton(
            isLoading: state.formSubmissionState is FormSubmittingState,
            onTap: () async {
              BlocProvider.of<EndBloc>(context).add(EndServiceEvent(id: id));
            },
            title: AppLocalizations.of(context)?.endServiceLabel ?? "",
          ),
        );
      },
    );
  }

  Row _buildUpTo4Images(BuildContext context) {
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
              AppLocalizations.of(context)?.youCanUploadUpTo4items ?? "",
              color: Colors.grey[700],
            ),
          ),
        ]);
  }

  Widget _buildImageList(BuildContext context) {
    return BlocBuilder<EndBloc, EndState>(
      builder: (context, state) {
        print('images ${state.images.length}');
        return Wrap(
            runSpacing: 4,
            spacing: 8,
            children: state.images
                .map((image) => ImageItem(
                  isFile: true,
                    fileImage: image,
                    showCancel: true,
                    handler: () async {
                      BlocProvider.of<EndBloc>(context).add(
                        RemoveImageEndServiceEvent(
                          image: image,
                        ),
                      );
                    }))
                .toList());
      },
    );
  }

  Widget _buildCommentSection(BuildContext context, int id) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          AppLocalizations.of(context)!.commentOptionalLabel,
          color: Theme.of(context).primaryColor,
        ),
        AppTextField(
          controller: TextEditingController(),
          minLines: 3,
          maxLines: 5,
          hintText: AppLocalizations.of(context)!.hintOptionalLabel,
          onChanged: (value) {
            BlocProvider.of<EndBloc>(context)
                .add(CommentChangedEvent(comment: value));
          },
        ),
      ],
    );
  }

  Widget _buildAddImage(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          AppLocalizations.of(context)?.attachmentsOptionalLabel ?? "",
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(
          height: 12.0,
        ),
        AppText(
          AppLocalizations.of(context)!.addingPhotosAfterCompleteService,
          color: Colors.grey[700],
        ),
        SizedBox(
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
                    BlocProvider.of<EndBloc>(context)
                        .add(AddImageEndServiceEvent(image: image));
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
                    BlocProvider.of<EndBloc>(context)
                        .add(AddImageEndServiceEvent(image: image));
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddImageItem(
      BuildContext context, String title, IconData icon, Function handler) {
    return Expanded(
      child: BlocBuilder<EndBloc, EndState>(
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

  EndBloc _getEndServiceBloc() {
    return EndBloc(
      finishWorkingUseCase: FinishWorkingUseCase(
        providerRepo: ProviderRepoImpl(
          providerDataSource: ProviderDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    );
  }
}
