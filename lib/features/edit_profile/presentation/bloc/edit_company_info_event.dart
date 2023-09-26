// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'edit_company_info_bloc.dart';

abstract class EditCompanyInfoEvent extends Equatable {
  const EditCompanyInfoEvent();

  @override
  List<Object> get props => [];
}
class EditCompanyEvent extends EditCompanyInfoEvent {
    final int isCitizen;
  final String companyName;
  final String address;
  final int state;
  EditCompanyEvent({
    required this.isCitizen,
    required this.companyName,
    required this.address,
    required this.state
  });
}
