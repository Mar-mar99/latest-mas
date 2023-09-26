part of 'get_company_emirates_bloc.dart';

abstract class GetCompanyEmiratesState extends Equatable {
  const GetCompanyEmiratesState();

  @override
  List<Object> get props => [];
}

class GetCompanyEmiratesInitial extends GetCompanyEmiratesState {}
class LoadingGetCompanyEmirates extends GetCompanyEmiratesState{}
class LoadedGetCompanyEmirates extends GetCompanyEmiratesState {
  final List<CompanyEmiratesEntity> data;
  LoadedGetCompanyEmirates({
    required this.data,
  });
  @override

  List<Object> get props => [data];
}


class GetCompanyEmiratesOfflineState extends GetCompanyEmiratesState{}

class GetCompanyEmiratesErrorState extends GetCompanyEmiratesState {
  final String message;
  const GetCompanyEmiratesErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

