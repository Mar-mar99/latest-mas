// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'assign_service_code_bloc.dart';

abstract class AssignServiceCodeEvent extends Equatable {
  const AssignServiceCodeEvent();

  @override
  List<Object> get props => [];
}
class AssignServiceToPromo extends AssignServiceCodeEvent {
  final int promoId;
  final int serviceId;
  AssignServiceToPromo({
    required this.promoId,
    required this.serviceId,
  });
}
