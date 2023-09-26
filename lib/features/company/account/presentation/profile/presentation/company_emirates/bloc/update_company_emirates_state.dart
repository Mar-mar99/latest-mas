part of 'update_company_emirates_bloc.dart';

abstract class UpdateCompanyEmiratesState extends Equatable {
  const UpdateCompanyEmiratesState();

  @override
  List<Object> get props => [];
}

class UpdateCompanyEmiratesInitial extends UpdateCompanyEmiratesState {}

class LoadingUpdateCompanyEmirates extends UpdateCompanyEmiratesState{}
class LoadedUpdateCompanyEmirates extends UpdateCompanyEmiratesState {
}


class UpdateCompanyEmiratesOfflineState extends UpdateCompanyEmiratesState{}

class UpdateCompanyEmiratesErrorState extends UpdateCompanyEmiratesState {
  final String message;
  const UpdateCompanyEmiratesErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

