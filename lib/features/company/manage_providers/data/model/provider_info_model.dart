import 'package:masbar/features/company/manage_providers/data/model/provider_model.dart';

import '../../domain/entities/provider_info_entity.dart';

class ProviderInfoModel extends ProviderInfoEntity {
  ProviderInfoModel(
      {required super.allowedExperts,
      required super.activeExperts,
      required super.disabledExperts,
      required super.providers});

  factory ProviderInfoModel.fromJson(Map<String, dynamic> json) {
    return ProviderInfoModel(
      allowedExperts: json['AllowedExperts'],
      activeExperts: json['ActiveExperts'],
      disabledExperts: json['DisabledExperts'],
      providers:List.from((json['Experts'] as List<dynamic>).map((e) => ProviderModel.fromJson(e))) ,
    );
  }
}
