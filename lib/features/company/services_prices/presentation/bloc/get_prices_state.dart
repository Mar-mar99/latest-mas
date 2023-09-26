// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'get_prices_bloc.dart';

enum GetPricesStatus {
  init,
  loadingForServices,
  loadingForPrices,
  loaded,
  offline,
  error,
}

class GetPricesState extends Equatable {
  final List<CompanyServiceEntity> services;
  final List<ServicePriceEntity> prices;
   final CompanyServiceEntity selectedService;
  final GetPricesStatus status;
  final String errorMessage;

  const GetPricesState({
    required this.services,
    required this.prices,
    required this.status,
    required this.selectedService,
    required this.errorMessage,
  });
  factory GetPricesState.empty() {
    return  GetPricesState(
        errorMessage: '',
        selectedService: CompanyServiceEntity(id: 1, name: ''),
        prices: [],
        services: [],
        status: GetPricesStatus.init);
  }
  @override
  List<Object> get props => [
    services,
    prices,
    status,
    //selectedService,
    errorMessage,
  ];



  GetPricesState copyWith({
    List<CompanyServiceEntity>? services,
    List<ServicePriceEntity>? prices,
    CompanyServiceEntity? selectedService,
    GetPricesStatus? status,
    String? errorMessage,
  }) {
    return GetPricesState(
      services: services ?? this.services,
      prices: prices ?? this.prices,
      selectedService: selectedService ?? this.selectedService,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
