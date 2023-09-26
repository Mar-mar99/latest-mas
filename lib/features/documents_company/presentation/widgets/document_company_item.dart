import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/ui/widgets/app_dialog.dart';
import '../../../../../core/ui/widgets/app_text.dart';
import '../../../../../core/utils/helpers/helpers.dart';
import '../../../../../core/utils/helpers/pick_file.dart';
import '../../domain/entities/document_entity.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../bloc/add_update_delete_bloc.dart';

class DocumentCompanyItem extends StatelessWidget {
  final DocumentEntity documentEntity;
  const DocumentCompanyItem({
    super.key,
    required this.documentEntity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white70),
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).dividerColor),
      child: Row(
        children: [
          _buildImage(),
          const SizedBox(
            width: 15,
          ),
          const SizedBox(
            width: 15,
          ),
          _builsStatusText(),
      //    if (documentEntity.status! != 'ACTIVE') _buildEditIcon(context,documentEntity),
          if (documentEntity.status! != 'ACTIVE')
            const SizedBox(
              width: 15,
            ),
          if (documentEntity.status! != 'ACTIVE') _buildCancelBtn(context,documentEntity)
        ],
      ),
    );
  }

  InkWell _buildCancelBtn(BuildContext c, DocumentEntity documentEntity) {
    return InkWell(
      onTap: () {
        showDialog(
          context: c,
          builder: (BuildContext context) {
            return DialogItem(
              title: AppLocalizations.of(context)?.deleteFile ?? "",
              paragraph:
                  AppLocalizations.of(context)?.doYouWantToDeleteTheFile ?? "",
              cancelButtonText: AppLocalizations.of(context)?.cancel ?? "",
              nextButtonText: AppLocalizations.of(context)?.delete ?? "",
              nextButtonFunction: () async {
                BlocProvider.of<AddUpdateDeleteBloc>(c).add(
                  DeleteDocumentEvent(id: documentEntity.id!),
                );

                Navigator.pop(context);
              },
              cancelButtonFunction: () {
                Navigator.pop(context);
              },
            );
          },
        );
      },
      child: Icon(
        Icons.cancel,
        color: Theme.of(c).primaryColor,
      ),
    );
  }

  InkWell _buildEditIcon(BuildContext c, DocumentEntity documentEntity) {
    return InkWell(
      onTap: () async {

        File? file = await getPickedFile();
        if (file != null) {
          // ignore: use_build_context_synchronously
          showDialog(
          context: c,
          builder: (BuildContext context) {
            return DialogItem(
              title: AppLocalizations.of(context)?.editFile ?? "",
              paragraph:
                  AppLocalizations.of(context)?.doYouWantToModifyTheFile ?? "",
              cancelButtonText: AppLocalizations.of(context)?.cancel ?? "",
              nextButtonText: AppLocalizations.of(context)?.edit ?? "",
              nextButtonFunction: () async {
                BlocProvider.of<AddUpdateDeleteBloc>(c).add(
                 UpdateDocumentEvent(id: documentEntity.id!,file: file),
                );
                Navigator.pop(context);
              },
              cancelButtonFunction: () {
                Navigator.pop(context);
              },
            );
          },
        );
        }
      },
      child: Icon(
        Icons.edit,
        color: Theme.of(c).primaryColor,
      ),
    );
  }

  Widget _buildImage() {
    return   SizedBox(
          height: 50,
          width:50,
          child: Image.network(Helpers.getImage(documentEntity.url),fit: BoxFit.cover,));
  }

  Expanded _builsStatusText() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            documentEntity.status!,
            color:
                documentEntity.status! == 'ACTIVE' ? Colors.green : Colors.red,
            fontSize: 12,
          ),
          AppText(Helpers.getExtension(documentEntity.url!)),
        ],
      ),
    );
  }
}
