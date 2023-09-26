// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'update_company_emirates_bloc.dart';

abstract class UpdateCompanyEmiratesEvent extends Equatable {
  const UpdateCompanyEmiratesEvent();

  @override
  List<Object> get props => [];
}
class UpdateEmiratesEvent extends UpdateCompanyEmiratesEvent {
  final List<bool> states;
  final int headState;
  UpdateEmiratesEvent({
    required this.states,
    required this.headState,
  });
}
