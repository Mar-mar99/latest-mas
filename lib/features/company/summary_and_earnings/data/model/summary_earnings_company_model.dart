
import '../../domain/entities/summary_earnings_company.dart';

class SummaryEarningsCompanyModel extends SummaryEarningsCompanyEntity {
  SummaryEarningsCompanyModel({
    super.completed,
    super.canceled,
    super.scheduled,
  });

  factory SummaryEarningsCompanyModel.fromJson(Map<String, dynamic> json) {
    return SummaryEarningsCompanyModel(
      completed: json['Completed'] != null
          ? CompletedCompanyModel.fromJson(json['Completed'])
          : null,
      canceled: json['Canceled'],
      scheduled: json['Scheduled'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (completed != null) {
      data['Completed'] = (completed as CompletedCompanyModel).toJson();
    }
    data['Canceled'] = canceled;
    data['Scheduled'] = scheduled;
    return data;
  }
}

class CompletedCompanyModel extends CompletedCompanyEntity {
  CompletedCompanyModel(
      {super.count,
      super.revenue,
      super.charity,
      super.localCompanyDiscount,
      super.discount,
      super.commision,
      super.wallet,
      super.cash});

  factory CompletedCompanyModel.fromJson(Map<String, dynamic> json) {
    return CompletedCompanyModel(
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
