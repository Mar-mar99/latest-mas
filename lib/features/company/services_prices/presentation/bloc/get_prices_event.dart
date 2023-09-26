// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'get_prices_bloc.dart';

abstract class GetPricesEvent extends Equatable {
  const GetPricesEvent();

  @override
  List<Object> get props => [];
}
class GetServicesAndPricesPricesEvent extends GetPricesEvent{}
class LoadPricesEvent extends GetPricesEvent {
  final CompanyServiceEntity? companyServiceEntity;
  LoadPricesEvent({
    required this.companyServiceEntity,
  });
}
