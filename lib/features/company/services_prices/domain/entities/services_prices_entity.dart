// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class ServicePriceEntity extends Equatable {
final int stateid;
  final String stateName;
  final num fixedPrice;
  final num hourlyPrice;
  ServicePriceEntity({
    required this.stateid,
    required this.stateName,
    required this.fixedPrice,
    required this.hourlyPrice,
  });

  @override

  List<Object?> get props => [
    stateid,
    stateName,
    fixedPrice,
    hourlyPrice,
  ];


}
