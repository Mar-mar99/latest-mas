import '../../domain/entities/request_service_entity.dart';
import 'package:masbar/core/utils/extensions/extensions.dart';

import '../../../../../core/utils/enums/enums.dart';
import '../../../promo_code/domain/entities/promo_code_entity.dart';
import 'package:intl/intl.dart';

class RequestServiceModel extends RequestServiceEntity {
  RequestServiceModel({
    required super.latitude,
    required super.longitude,
    required super.address,
    required super.serviceType,
    required super.paymentStatus,
    super.paymentMethod,
    super.promoCode,
    super.images,
    required super.distance,
    super.scheduleTime,
    super.scheduleDate,
    required super.stateId,
    super.note,
    required super.selectedAttributes,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      's_latitude': latitude,
      's_longitude': longitude,
      's_address': address,
      'service_type': serviceType,
      'payment_mode': (paymentStatus == ServicePaymentType.paid)
          ? paymentMethod!.getText().toUpperCase()
          : "FREE",
      'use_wallet': (paymentStatus == ServicePaymentType.paid &&
              paymentMethod == PaymentMethod.wallet)
          ? 1
          : 0,
      'distance': distance,
      if (scheduleDate != null)
        'schedule_date': DateFormat('yyyy-MM-dd').format(scheduleDate!),
      if (scheduleTime != null)
        'schedule_time': DateFormat('kk:mm').format(scheduleTime!),
      'state_id': stateId,
      // 'attributez': List.from(
      //   selectedAttributes
      //       .map((e) =>
      //           {"attr_id": e.attributeId, "attr_value": e.attributeValue})
      //       .toList(),
      // ),
      //  'images[]': docsFile,
      if (promoCode != null) 'promo_code': promoCode?.promoCodeId,
      if (note != null) 'notes': note
    };
    for (int i = 0; i < selectedAttributes.length; i++) {
      data.addAll(
          {"attributez[$i][attr_id]": selectedAttributes[i].attributeId});
      data.addAll({
        "attributez[$i][attr_value]": selectedAttributes[i].attributeValue
      });
    }
    return data;
  }
}

class SelectedAttributeModel extends SelectedAttributeEntity {
  SelectedAttributeModel({
    required super.attributeId,
    required super.attributeValue,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'attr_id': attributeId,
      'attr_value': attributeValue,
    };
  }

  factory SelectedAttributeModel.fromJson(Map<String, dynamic> map) {
    return SelectedAttributeModel(
      attributeId: map['attr_id'] as int,
      attributeValue: map['attr_value'] as String,
    );
  }

  @override
  List<Object?> get props => [attributeId, attributeValue];
}
