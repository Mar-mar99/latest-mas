import 'package:equatable/equatable.dart';

class SummaryEarningsProviderEntity extends Equatable {
  final CompletedProviderEntity? completed;
  final int? canceled;
  final int? scheduled;

  SummaryEarningsProviderEntity({
    this.completed,
    this.canceled,
    this.scheduled,
  });



  @override

  List<Object?> get props => [
    completed,
    canceled,
    scheduled,
  ];
}

class CompletedProviderEntity extends Equatable{
  int? count;
  String? revenue;
  String? charity;
  String? localCompanyDiscount;
  String? discount;
  String? commision;
  String? wallet;
  String? cash;

  CompletedProviderEntity(
      {this.count,
      this.revenue,
      this.charity,
      this.localCompanyDiscount,
      this.discount,
      this.commision,
      this.wallet,
      this.cash});

 
  @override

  List<Object?> get props => [
      count,
      revenue,
      charity,
      localCompanyDiscount,
      discount,
      commision,
      wallet,
      cash
  ];
}
