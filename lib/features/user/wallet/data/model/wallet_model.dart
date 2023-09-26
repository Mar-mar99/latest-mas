import '../../domain/entities/wallet_entity.dart';

class WalletModel extends WalletEntity{

  WalletModel(
      { super.id,
        super.type,
        super.amount,
        super.description,
        super.createdAt,
        super.receiptUrl});

  WalletModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    amount = json['amount'];
    description = json['description'];
    createdAt = json['created_at'];
    receiptUrl = json['receipt_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['amount'] = amount;
    data['description'] = description;
    data['created_at'] = createdAt;
    data['receipt_url'] = receiptUrl;
    return data;
  }
}
