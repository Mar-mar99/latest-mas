import 'package:equatable/equatable.dart';
import '../../domain/entities/favorite_provider_entity.dart';

class FavoriteProviderModel extends FavoriteProviderEntity {
  FavoriteProviderModel({
    required super.id,
    required super.name,
    required super.rating,
    required super.fixedPrice,
    required super.hourlyPrice,
    required super.distance,
    required super.completedRequest,
    required super.isExpertOnline,
    required super.isExpertActive,
    required super.companyId,
    required super.stateId,
    required super.attrs,
    required super.cancellationFee, required super.isBusy,
  });
  factory FavoriteProviderModel.fromJson(Map<String, dynamic> json) {
    return FavoriteProviderModel(
      id: json['id'],
      name: json['name'],
      rating: json['rating'],
      fixedPrice: json['fixed_price'].toString(),
      hourlyPrice: json['hourly_price'].toString(),
      distance: json['Distance'],
      completedRequest: json['CompletedRequests'],
      isExpertOnline: json['expertOnline']=='No'?false:true,
      isExpertActive: json['expertActive']=='No'?false:true,
      isBusy: json['isBusy']==0?false:true,
      companyId: json['company_id'],
      stateId: json['state_id'],
      cancellationFee: (json['cancelation_fees']==0 || json['cancelation_fees']=='0.00' )?'0': json['cancelation_fees'],
      attrs: List.from(
          (json['attrs'] as List).map((e) => AttributeModel.fromJson(e))),
    );
  }
}

class AttributeModel extends AttributeEntity {
  AttributeModel({
    required super.name,
    required super.value,
  });

  factory AttributeModel.fromJson(Map<String, dynamic> json) {
    return AttributeModel(name: json['name'], value: json['value']);
  }
}
