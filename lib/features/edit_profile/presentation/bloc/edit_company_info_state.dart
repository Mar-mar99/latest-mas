// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'edit_company_info_bloc.dart';

abstract class EditCompanyInfoState extends Equatable {
  @override
  List<Object> get props => [];
}
class InitEditCompany extends EditCompanyInfoState {}

class LoadingEditCompany extends EditCompanyInfoState {}

class DoneEditCompany extends EditCompanyInfoState {}

class EditCompanyOfflineState extends EditCompanyInfoState {}

class EditCompanyErrorState extends EditCompanyInfoState {
  final String message;
  EditCompanyErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
