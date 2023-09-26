// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'check_for_service_bloc.dart';

abstract class CheckForServiceState extends Equatable {
  const CheckForServiceState();

  @override
  List<Object> get props => [];
}

class CheckForServiceInitial extends CheckForServiceState {}
class LoadingCheckServiceState extends CheckForServiceState{}
class ActiveServiceState extends CheckForServiceState {
  final int id;
  ActiveServiceState({
    required this.id,
  });
}
class NoActiveServiceState extends CheckForServiceState{}
