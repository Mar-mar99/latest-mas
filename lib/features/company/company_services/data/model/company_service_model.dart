import '../../domain/entities/company_service_entity.dart';

class CompanyServiceModel extends CompanyServiceEntity {
  CompanyServiceModel({
    required super.id,
    required super.name,
  });
  factory CompanyServiceModel.fromJson(Map<String, dynamic> json) {
    return CompanyServiceModel(
      id: json['id'],
      name: json['name'],
    );
  }
}
