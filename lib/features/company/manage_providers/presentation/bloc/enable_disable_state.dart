part of 'enable_disable_bloc.dart';

abstract class EnableDisableState extends Equatable {
  const EnableDisableState();

  @override
  List<Object> get props => [];
}

class EnableDisableInitial extends EnableDisableState {}
class LoadingEnableDisableState extends EnableDisableState{}
class DoneEnableDisableState extends EnableDisableState {

}


class EnableDisableOfflineState extends EnableDisableState{}

class EnableDisableStateErrorState extends EnableDisableState {
  final String message;
  const EnableDisableStateErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}


