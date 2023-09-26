import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:masbar/core/network/check_internet.dart';
import 'package:masbar/core/ui/widgets/error_widget.dart';
import 'package:masbar/core/ui/widgets/loading_widget.dart';
import 'package:masbar/core/ui/widgets/no_connection_widget.dart';
import 'package:masbar/core/utils/helpers/snackbar.dart';
import 'package:masbar/features/auth/accounts/domain/repositories/auth_repo.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../core/ui/widgets/app_button.dart';
import '../../../../../core/ui/widgets/app_dialog.dart';
import '../../../../../core/ui/widgets/app_text.dart';
import '../../../../../core/ui/dialogs/loading_dialog.dart';
import '../../../../../core/utils/helpers/helpers.dart';
import '../../../../../core/utils/helpers/pick_file.dart';
import '../../data/data_source/documents_data_source.dart';
import '../../data/repositories/documents_repo_impl.dart';
import '../../domain/entities/document_entity.dart';
import '../../domain/use_cases/delete_document_use_case.dart';
import '../../domain/use_cases/get_documents_use_case.dart';
import '../../domain/use_cases/reupload_document_use_case.dart';
import '../../domain/use_cases/upload_documents_use_case.dart';
import '../bloc/add_update_delete_bloc.dart';
import '../bloc/get_documents_bloc.dart';
import '../widgets/document_company_item.dart';

class DocumentsScreen extends StatelessWidget {
  static const routeName = 'documents_screen';
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _getBloc(context),
        ),
        BlocProvider(
          create: (context) => _getAddUploadDeleteBloc(context),
        ),
      ],
      child: Builder(builder: (context) {
        return BlocListener<AddUpdateDeleteBloc, AddUpdateDeleteState>(
          listener: (context, state) {
            _buildListener(state, context);
          },
          child: BlocBuilder<GetDocumentsBloc, GetDocumentsState>(
            builder: (c, state) {
              if (state is LoadingGetDocumentsState) {
                return Scaffold(
                    appBar: AppBar(
                      title:
                          Text(AppLocalizations.of(c)?.documents ?? ""),
                    ),
                    body: const LoadingWidget());
              } else if (state is GetDocumentsOfflineState) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(AppLocalizations.of(c)?.documents ?? ""),
                  ),
                  body: NoConnectionWidget(
                    onPressed: () {
                      BlocProvider.of<GetDocumentsBloc>(c)
                          .add(LoadDocumentsEvent());
                    },
                  ),
                );
              } else if (state is GetDocumentsErrorState) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(AppLocalizations.of(c)?.documents ?? ""),
                  ),
                  body: NetworkErrorWidget(
                    message: state.message,
                    onPressed: () {
                      BlocProvider.of<GetDocumentsBloc>(c)
                          .add(LoadDocumentsEvent());
                    },
                  ),
                );
              } else if (state is LoadedDocumentsState) {
                return Scaffold(
                    appBar: AppBar(
                      title:
                          Text(AppLocalizations.of(c)?.documents ?? ""),
                    ),
                    body: SingleChildScrollView(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 20),
                          child: Column(
                            children: [
                              _buildImage(),
                              const SizedBox(
                                height: 10,
                              ),
                              _buildTitle(c),
                              const SizedBox(
                                height: 15,
                              ),
                              ...state.documents.map((e) {
                                return DocumentCompanyItem(
                                  documentEntity: e,
                                );
                              }),
                              const SizedBox(
                                height: 80,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    bottomSheet: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: AppButton(
                        onTap: () async {
                          File? file = await getPickedFile();
                          if (file != null) {
                            // ignore: use_build_context_synchronously
                            showDialog(
                              context: c,
                              builder: (BuildContext context) {
                                return DialogItem(
                                  title:
                                      AppLocalizations.of(context)?.saveFile ??
                                          "",
                                  paragraph: AppLocalizations.of(context)
                                          ?.doYouWantToSaveTheFile ??
                                      "",
                                  cancelButtonText:
                                      AppLocalizations.of(context)?.cancel ??
                                          "",
                                  nextButtonText:
                                      AppLocalizations.of(context)?.save ?? "",
                                  nextButtonFunction: () async {
                                    BlocProvider.of<AddUpdateDeleteBloc>(
                                            c)
                                        .add(
                                      AddDocumentEvent(file: file),
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
                        title: AppLocalizations.of(c)?.addDocument ?? "",
                      ),
                    ));
              } else {
                return Container();
              }
            },
          ),
        );
      }),
    );
  }

  void _buildListener(AddUpdateDeleteState state, BuildContext context) {
    if (state is AddUpdateDeleteOfflineState) {
           Navigator.pop(context);
      showSnackbar(context, 'No internet connection');
    } else if (state is AddUpdateDeleteErrorState) {
           Navigator.pop(context);
      showSnackbar(context,
          'An error occurred while sending, please try again \n ${state.message}');
    } else if (state is LoadingAddUpdateDeleteState) {

      showLoadingDialog(context);
    } else if (state is DoneAddUpdateDeleteState) {
      Navigator.pop(context);
      BlocProvider.of<GetDocumentsBloc>(context).add(LoadDocumentsEvent());
    }
  }

  AddUpdateDeleteBloc _getAddUploadDeleteBloc(BuildContext context) {
    return AddUpdateDeleteBloc(
      deleteDocumentUsecase: DeleteDocumentUsecase(
        authRepo: context.read<AuthRepo>(),
        documentsRepo: DocumentsRepoImpl(
          documentsDataSource: DocumentsDataSourceWithHttp(client: Client()),
          networkInfo: NetworkInfoImpl(
            internetConnectionChecker: InternetConnectionChecker(),
          ),
        ),
      ),
      reUploadDocumentUsecase: ReUploadDocumentUsecase(
        authRepo: context.read<AuthRepo>(),
        documentsRepo: DocumentsRepoImpl(
          documentsDataSource: DocumentsDataSourceWithHttp(client: Client()),
          networkInfo: NetworkInfoImpl(
            internetConnectionChecker: InternetConnectionChecker(),
          ),
        ),
      ),
      uploadDocumentUsecase: UploadDocumentUsecase(
        authRepo: context.read<AuthRepo>(),
        documentsRepo: DocumentsRepoImpl(
          documentsDataSource: DocumentsDataSourceWithHttp(client: Client()),
          networkInfo: NetworkInfoImpl(
            internetConnectionChecker: InternetConnectionChecker(),
          ),
        ),
      ),
    );
  }

  GetDocumentsBloc _getBloc(BuildContext context) {
    return GetDocumentsBloc(
      getDocumentsUsecase: GetDocumentsUsecase(
        authRepo: context.read<AuthRepo>(),
        documentsRepo: DocumentsRepoImpl(
          documentsDataSource: DocumentsDataSourceWithHttp(client: Client()),
          networkInfo: NetworkInfoImpl(
            internetConnectionChecker: InternetConnectionChecker(),
          ),
        ),
      ),
    )..add(LoadDocumentsEvent());
  }

  AppText _buildTitle(BuildContext context) {
    return AppText(
      AppLocalizations.of(context)?.yourDocument ?? "",
      color: Colors.black,
      bold: true,
      fontSize: 20,
    );
  }

  Container _buildImage() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Image.asset(
        'assets/images/logo.jpg',
        height: 95,
      ),
    );
  }
}
