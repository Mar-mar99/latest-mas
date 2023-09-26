part of 'get_promos_bloc.dart';

abstract class GetPromosEvent extends Equatable {
  const GetPromosEvent();

  @override
  List<Object> get props => [];
}
class LoadPromosEvent extends GetPromosEvent{}
