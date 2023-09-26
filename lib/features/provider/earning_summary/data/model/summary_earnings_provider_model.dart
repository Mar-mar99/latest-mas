import 'package:equatable/equatable.dart';

import '../../domain/entities/summary_earnings_provider.dart';

class SummaryEarningsProviderModel extends SummaryEarningsProviderEntity {
  final CompletedProviderEntity? completed;
  final int? canceled;
  final int? scheduled;

  SummaryEarningsProviderModel({
    this.completed,
    this.canceled,
    this.scheduled,
  });

  factory SummaryEarningsProviderModel.fromJson(Map<String, dynamic> json) {
    return SummaryEarningsProviderModel(
      completed: json['Completed'] != null
          ? CompletedProviderModel.fromJson(json['Completed'])
          : null,
      canceled: json['Canceled'],
      scheduled: json['Scheduled'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (completed != null) {
      data['Completed'] = (completed as CompletedProviderModel).toJson();
    }
    data['Canceled'] = canceled;
    data['Scheduled'] = scheduled;
    return data;
  }
}

class CompletedProviderModel extends CompletedProviderEntity {
  CompletedProviderModel(
      {super.count,
      super.revenue,
      super.charity,
      super.localCompanyDiscount,
      super.discount,
      super.commision,
      super.wallet,
      super.cash});

  factory CompletedProviderModel.fromJson(Map<String, dynamic> json) {
    return CompletedProviderModel(
      count: json['Count'],
      revenue: json['Revenue'],
      charity: json['Charity'],
      localCompanyDiscount: json['LocalCompanyDiscount'],
      discount: json['Discount'],
      commision: json['Commision'],
      wallet: json['Wallet'],
      cash: json['Cash'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Count'] = count;
    data['Revenue'] = revenue;
    data['Charity'] = charity;
    data['LocalCompanyDiscount'] = localCompanyDiscount;
    data['Discount'] = discount;
    data['Commision'] = commision;
    data['Wallet'] = wallet;
    data['Cash'] = cash;
    return data;
  }
}
