// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';

import 'package:flutter/widgets.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../../../core/utils/helpers/pick_file.dart';
import '../widgets/document_item.dart';
import 'package:masbar/core/constants/api_constants.dart';
import 'package:masbar/core/utils/helpers/helpers.dart';
import 'package:masbar/features/auth/accounts/presentation/bloc/company_signup_bloc.dart';

import '../../../../../core/ui/widgets/app_button.dart';
import '../../../../../core/ui/widgets/app_text.dart';
import '../widgets/add_document_widget.dart';

import '../bloc/provider_signup_bloc.dart';

class AddDocumentProviderScreen extends StatelessWidget {
  static const routeName = 'add_document_provider_screen';
  final ProviderSignupBloc bloc;
  const AddDocumentProviderScreen({
    Key? key,
    required this.bloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: bloc,
        child: AddDocumentWidget(
          onAddDocumentBtn: () async {
            File? file = await getPickedFile();
            if (file != null) {
              bloc.add(ProviderAddDocumentEvent(document: file));
            }
          },
          onClickHereHandler: () async {
            try {
              if (Platform.isAndroid) {
                launchUrlString(ApiConstants.providerContract);
              } else {
                launchUrlString(ApiConstants.providerContract);
              }
            } catch (e) {
              if (kDebugMode) {
                print(e);
              }
            }
          },
          DocumentListWidget:
              BlocBuilder<ProviderSignupBloc, ProviderSignupState>(
            buildWhen: (previous, current) {
              print('previous ${previous.documents.length}');
              print('current ${current.documents.length}');
              if (previous.documents != current.documents) {
                return true;
              } else {
                return false;
              }
            },
            builder: (context, state) {
              return Column(
                children: state.documents.map(
                  (e) {
                    return DocumentItem(
                      image: e,
                      onRemoveHandler: () {
                        bloc.add(ProviderRemoveDocumentEvent(document: e));
                      },
                      name: Helpers.getExtension(e.path),
                    );
                  },
                ).toList(),
              );
            },
          ),
        ));
  }
}
