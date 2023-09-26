import 'package:masbar/features/auth/accounts/domain/entities/user_entity.dart';

import '../../domain/entities/company_provider_entity.dart';

class ComapnyProviderModel extends CompanyProviderEntity {
  ComapnyProviderModel({
    required super.id,
    required super.name,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory ComapnyProviderModel.fromJson(Map<String, dynamic> map) {
    return ComapnyProviderModel(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }
}
