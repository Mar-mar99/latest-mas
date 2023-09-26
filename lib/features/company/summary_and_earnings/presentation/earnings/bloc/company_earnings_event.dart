// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'company_earnings_bloc.dart';

abstract class CompanyEarningsEvent extends Equatable {
  const CompanyEarningsEvent();

  @override
  List<Object> get props => [];
}
class GetEarningsDataWithoutProviders extends CompanyEarningsEvent {
  final String? providerId;
  GetEarningsDataWithoutProviders({
    this.providerId,
  });
}

class GetEarningsDataWithProviders extends CompanyEarningsEvent {

}
