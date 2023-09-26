// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'get_promos_bloc.dart';

abstract class GetPromosState extends Equatable {
  const GetPromosState();

  @override
  List<Object> get props => [];
}

class GetPromosInitial extends GetPromosState {}

class LoadingGetPromos extends GetPromosState {}

class LoadedGetPromos extends GetPromosState {
final List<PromotionEntity> data;
  LoadedGetPromos({
    required this.data,
  });
}

class GetPromosOfflineState extends GetPromosState {}

class GetPromosErrorState extends GetPromosState {
  final String message;
  const GetPromosErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
