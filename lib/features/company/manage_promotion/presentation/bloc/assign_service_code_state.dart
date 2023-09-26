// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'assign_service_code_bloc.dart';

abstract class AssignServiceCodeState extends Equatable {
  const AssignServiceCodeState();

  @override
  List<Object> get props => [];
}

class AssignServiceCodeInitial extends AssignServiceCodeState {}

class LoadingAssignService extends AssignServiceCodeState {}

class LoadedAssignService extends AssignServiceCodeState {
final int serviveId;
  LoadedAssignService({
    required this.serviveId,
  });
}

class AssignServiceOfflineState extends AssignServiceCodeState {}

class AssignServiceErrorState extends AssignServiceCodeState {
  final String message;
  const AssignServiceErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
