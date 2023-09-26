import 'package:equatable/equatable.dart';

import '../../domain/entities/payment_method_entity.dart';

class PaymentsMethodModel extends PaymentsMethodEntity {
  PaymentsMethodModel({
    super.id,
    super.lastFour,
    super.brand,
    super.isDefault,
    super.cardId
  });

  PaymentsMethodModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lastFour = json['last_four'];
    brand = json['brand'];
    isDefault = json['is_default'];
    cardId=json['card_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['last_four'] = lastFour;
    data['brand'] = brand;
    data['is_default'] = isDefault;
    return data;
  }
}
