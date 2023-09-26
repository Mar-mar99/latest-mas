part of 'promos_details_bloc.dart';

abstract class PromosDetailsState extends Equatable {
  const PromosDetailsState();

  @override
  List<Object> get props => [];
}

class PromosDetailsInitial extends PromosDetailsState {}

class LoadingPromosDetails extends PromosDetailsState {}

class LoadedPromosDetails extends PromosDetailsState {
final PromotionEntity data;
  LoadedPromosDetails({
    required this.data,
  });
}

class PromosDetailsOfflineState extends PromosDetailsState {}

class PromosDetailsErrorState extends PromosDetailsState {
  final String message;
  const PromosDetailsErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
