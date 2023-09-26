// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'company_navigation_cubit.dart';

class CompanyNavigationState extends Equatable {
  final NavigationCompany navigationCompany;
  final int index;
  const CompanyNavigationState({
    required this.navigationCompany,
    required this.index,
  });

  @override
  List<Object> get props => [navigationCompany,index];
}


