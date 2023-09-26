part of 'get_company_sevices_bloc.dart';

abstract class GetCompanySevicesState extends Equatable {
  const GetCompanySevicesState();

  @override
  List<Object> get props => [];
}

class GetCompanySevicesInitial extends GetCompanySevicesState {}


class LoadingGetCompanySevices extends GetCompanySevicesState{}
class LoadedGetCompanySevices extends GetCompanySevicesState {
  final List<CompanyServiceEntity> data;
  LoadedGetCompanySevices({
    required this.data,
  });
  @override

  List<Object> get props => [data];
}


class GetCompanySevicesOfflineState extends GetCompanySevicesState{}

class GetCompanySevicesErrorState extends GetCompanySevicesState {
  final String message;
  const GetCompanySevicesErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

