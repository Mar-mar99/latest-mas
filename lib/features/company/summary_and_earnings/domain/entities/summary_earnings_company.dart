import 'package:equatable/equatable.dart';

class SummaryEarningsCompanyEntity extends Equatable {
  final CompletedCompanyEntity? completed;
  final int? canceled;
  final int? scheduled;

  SummaryEarningsCompanyEntity({
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

class CompletedCompanyEntity extends Equatable{
 final int? count;
 final String? revenue;
 final String? charity;
 final String? localCompanyDiscount;
 final String? discount;
 final String? commision;
 final String? wallet;
 final String? cash;

  CompletedCompanyEntity(
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
