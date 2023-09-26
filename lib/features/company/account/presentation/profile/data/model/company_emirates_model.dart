import '../../domain/entities/company_emirates_entity.dart';

class CompanyEmiratesModel extends CompanyEmiratesEntity {
  CompanyEmiratesModel(
      {required super.id,
      required super.name,
      required super.isChecked,
      required super.isMainBranch});

  factory CompanyEmiratesModel.fromJson(Map<String, dynamic> json) {
    return CompanyEmiratesModel(
      id: json['id'],
      name: json['name'],
      isChecked: json['checked'],
      isMainBranch: json['isMainBranch'],
    );
  }
  Map<String, dynamic> toJson(){
    return {
      'id':id,
      'name':name,
      'checked':isChecked,
      "isMainBranch":isMainBranch
    };
  }

}
