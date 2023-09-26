// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'accepting_rejecting_bloc.dart';

abstract class AcceptingRejectingState extends Equatable {
  const AcceptingRejectingState();

  @override
  List<Object> get props => [];
}

class AcceptingRejectingInitial extends AcceptingRejectingState {

}

class LoadingAcceptingRejecting extends AcceptingRejectingState {

}

class LoadedAcceptingRejecting extends AcceptingRejectingState {
   final bool isAccepted;
  LoadedAcceptingRejecting({
    required this.isAccepted,
  });
}

class AcceptingRejectingOfflineState extends AcceptingRejectingState {}

class AcceptingRejectingErrorState extends AcceptingRejectingState {
  final String message;
  const AcceptingRejectingErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
