part of 'suggest_time_bloc.dart';

abstract class SuggestTimeState extends Equatable {
  const SuggestTimeState();

  @override
  List<Object> get props => [];
}

class SuggestTimeInitial extends SuggestTimeState {}

class LoadingSuggestTime extends SuggestTimeState {

}

class LoadedSuggestTime extends SuggestTimeState {

}

class SuggestTimeOfflineState extends SuggestTimeState {}

class SuggestTimeErrorState extends SuggestTimeState {
  final String message;
  const SuggestTimeErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
