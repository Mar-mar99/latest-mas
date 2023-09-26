import '../../domain/entities/cancellation_entity.dart';

class CancellationModel extends CancellationEntity {
  CancellationModel(
      {required super.serviceId,
      required super.hasCancellationFees,
      required super.fees});

  factory CancellationModel.fromJson(Map<String, dynamic> json) {
    return CancellationModel(
      fees: json['cancelation_fees'],
      hasCancellationFees: json['has_cancelation_fees'],
      serviceId: json['service_id'],
    );
  }
}
