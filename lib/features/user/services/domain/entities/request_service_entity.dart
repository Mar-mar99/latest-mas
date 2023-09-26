import 'dart:io';
import 'package:equatable/equatable.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../promo_code/domain/entities/promo_code_entity.dart';

class RequestServiceEntity extends Equatable {
  final double latitude;
  final double longitude;
  final String address;
  final int serviceType;
  final ServicePaymentType paymentStatus;
  final PaymentMethod? paymentMethod;
  final PromoCodeEntity? promoCode;
  final List<File>? images;
  final int distance;
  final DateTime? scheduleTime;
  final DateTime? scheduleDate;
  final int stateId;
  final String? note;
  final List<SelectedAttributeEntity> selectedAttributes;
  RequestServiceEntity({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.serviceType,
    required this.paymentStatus,
    this.paymentMethod,
    this.promoCode,
    this.images,
    required this.distance,
    this.scheduleTime,
    this.scheduleDate,
    required this.stateId,
    this.note,
    required this.selectedAttributes,
  });

  @override
  List<Object?> get props => [
        latitude,
        longitude,
        address,
        serviceType,
        paymentStatus,
        paymentMethod,
        promoCode,
        images,
        distance,
        scheduleTime,
        scheduleDate,
        stateId,
        note,
        selectedAttributes,
      ];

}

class SelectedAttributeEntity extends Equatable {
  final int attributeId;
  final String attributeValue;
  SelectedAttributeEntity({
    required this.attributeId,
    required this.attributeValue,
  });


  @override
  List<Object?> get props => [attributeId, attributeValue];
}
