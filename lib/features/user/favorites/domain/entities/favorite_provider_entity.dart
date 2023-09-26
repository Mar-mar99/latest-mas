// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class FavoriteProviderEntity extends Equatable {
 final int id;
 final String name;
 final String rating;
 final String fixedPrice;
 final String hourlyPrice;
 final num distance;
 final int completedRequest;
 final bool isExpertOnline;
 final bool isExpertActive;
 final bool isBusy;
 final int companyId;
 final int stateId;
 final List<AttributeEntity> attrs;
 final String cancellationFee;
  FavoriteProviderEntity({
    required this.id,
    required this.name,
    required this.rating,
    required this.fixedPrice,
    required this.hourlyPrice,
    required this.distance,
    required this.completedRequest,
    required this.isExpertOnline,
    required this.isExpertActive,
   required this.isBusy,
    required this.companyId,
    required this.stateId,
    required this.attrs,
    required this.cancellationFee,
  });

  @override

  List<Object?> get props => [
    id,
    name,
    rating,
    fixedPrice,
    hourlyPrice,
    distance,
    completedRequest,
    isExpertOnline,
    isExpertActive,
isBusy,
    companyId,
    stateId,
    attrs,
    cancellationFee
  ];

}

class AttributeEntity extends Equatable {
final String name;
final String value;
  AttributeEntity({
    required this.name,
    required this.value,
  });

  @override

  List<Object?> get props => [
    name,
    value,
  ];
}
