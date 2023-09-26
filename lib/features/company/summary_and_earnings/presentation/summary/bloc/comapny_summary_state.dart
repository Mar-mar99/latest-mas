// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'comapny_summary_bloc.dart';

enum ComapnySummaryStatus { init, offline, error, successful, loadingProviders,loadingData }

class ComapnySummaryState extends Equatable {
  final List<CompanyProviderEntity> providers;
  final SummaryEarningsCompanyEntity? data;
  final ComapnySummaryStatus status;
  final String errorMessage;

  const ComapnySummaryState({
    required this.providers,
    required this.data,
    required this.status,
    required this.errorMessage
  });
  factory ComapnySummaryState.empty() {
    return const ComapnySummaryState(
      data: null,
      providers: [],
      status: ComapnySummaryStatus.init,
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


  ComapnySummaryState copyWith({
    List<CompanyProviderEntity>? providers,
    SummaryEarningsCompanyEntity? data,
    ComapnySummaryStatus? status,
    String? errorMessage,
  }) {
    return ComapnySummaryState(
      providers: providers ?? this.providers,
      data: data ?? this.data,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
