
import 'package:equatable/equatable.dart';

class CancellationEntity extends Equatable {
  final int serviceId;
  final bool hasCancellationFees;
  final num fees;
  CancellationEntity({
    required this.serviceId,
    required this.hasCancellationFees,
    required this.fees,
  });

  @override

  List<Object?> get props => [
    serviceId,
    hasCancellationFees,
    fees,
  ];
}
