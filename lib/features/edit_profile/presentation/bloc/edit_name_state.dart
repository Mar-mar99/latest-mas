// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'edit_name_bloc.dart';

abstract class EditNameState extends Equatable {

  @override
  List<Object> get props => [

      ];


}
class InitEditNameState extends EditNameState {}

class LoadingEditNameState extends EditNameState {}

class DoneEditNameState extends EditNameState {}

class EditNameOfflineState extends EditNameState {}

class EditNameErrorState extends EditNameState {
  final String message;
  EditNameErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
