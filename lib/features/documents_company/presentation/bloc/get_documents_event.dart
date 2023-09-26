part of 'get_documents_bloc.dart';

abstract class GetDocumentsEvent extends Equatable {
  const GetDocumentsEvent();

  @override
  List<Object> get props => [];
}

class LoadDocumentsEvent extends GetDocumentsEvent{}
