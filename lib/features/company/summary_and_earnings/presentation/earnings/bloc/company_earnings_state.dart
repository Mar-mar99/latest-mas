part of 'company_earnings_bloc.dart';
enum CompanyEarningsStatus { init, offline, error, successful, loadingProviders,loadingData }

 class CompanyEarningsState extends Equatable {
   final List<CompanyProviderEntity> providers;
  final SummaryEarningsCompanyEntity? data;
  final CompanyEarningsStatus status;
  final String errorMessage;
 const CompanyEarningsState({
    required this.providers,
    required this.data,
    required this.status,
    required this.errorMessage
  });
  factory CompanyEarningsState.empty() {
    return const CompanyEarningsState(
      data: null,
      providers: [],
      status: CompanyEarningsStatus.init,
      errorMessage: ''
    );
  }
  @override
  List<Object> get props => [
    providers,
    data.toString(),
    status,
    errorMessage
  ];


  CompanyEarningsState copyWith({
    List<CompanyProviderEntity>? providers,
    SummaryEarningsCompanyEntity? data,
    CompanyEarningsStatus? status,
    String? errorMessage,
  }) {
    return CompanyEarningsState(
      providers: providers ?? this.providers,
      data: data ?? this.data,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
