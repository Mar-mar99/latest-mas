// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../domain/use_cases/delete_document_use_case.dart';
import '../../domain/use_cases/reupload_document_use_case.dart';
import '../../domain/use_cases/upload_documents_use_case.dart';

part 'add_update_delete_event.dart';
part 'add_update_delete_state.dart';

class AddUpdateDeleteBloc
    extends Bloc<AddUpdateDeleteEvent, AddUpdateDeleteState> {
  final UploadDocumentUsecase uploadDocumentUsecase;
  final ReUploadDocumentUsecase reUploadDocumentUsecase;
  final DeleteDocumentUsecase deleteDocumentUsecase;

  AddUpdateDeleteBloc({
    required this.uploadDocumentUsecase,
    required this.reUploadDocumentUsecase,
    required this.deleteDocumentUsecase,
  }) : super(AddUpdateDeleteInitial()) {
    on<AddDocumentEvent>((event, emit) async {
      emit(LoadingAddUpdateDeleteState());

      final res = await uploadDocumentUsecase.call(
        file: event.file,
      );
      res.fold(
        (f) {
          _mapFailureToState(emit, f);
        },
        (documents) => emit(
          DoneAddUpdateDeleteState(),
        ),
      );
    });

    on<UpdateDocumentEvent>((event, emit) async {
      emit(LoadingAddUpdateDeleteState());

      final res = await reUploadDocumentUsecase.call(
     file: event.file,id: event.id
      );
      res.fold(
        (f) {
          _mapFailureToState(emit, f);
        },
        (documents) => emit(
          DoneAddUpdateDeleteState(),
        ),
      );
    });

     on<DeleteDocumentEvent>((event, emit) async {
      emit(LoadingAddUpdateDeleteState());

      final res = await deleteDocumentUsecase.call(
    id: event.id
      );
      res.fold(
        (f) {
          _mapFailureToState(emit, f);
        },
        (documents) => emit(
          DoneAddUpdateDeleteState(),
        ),
      );
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(AddUpdateDeleteOfflineState());
        break;

      case NetworkErrorFailure:
        emit(AddUpdateDeleteErrorState(
            message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(const AddUpdateDeleteErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}
