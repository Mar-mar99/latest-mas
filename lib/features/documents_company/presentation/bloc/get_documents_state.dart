part of 'get_documents_bloc.dart';

abstract class GetDocumentsState extends Equatable {
  const GetDocumentsState();

  @override
  List<Object> get props => [];
}

class GetDocumentsInitial extends GetDocumentsState {}
class LoadingGetDocumentsState extends GetDocumentsState{}
class LoadedDocumentsState extends GetDocumentsState {
  final List<DocumentEntity> documents;
  LoadedDocumentsState({
    required this.documents,
  });
  @override

  List<Object> get props => [documents];
}


class GetDocumentsOfflineState extends GetDocumentsState{}

class GetDocumentsErrorState extends GetDocumentsState {
  final String message;
  const GetDocumentsErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

