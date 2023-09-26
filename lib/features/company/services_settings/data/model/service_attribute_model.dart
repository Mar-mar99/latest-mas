import '../../domain/entities/service_attribute_entity.dart';

class ServiceAttributeModel extends ServiceAttributeEntity {
  ServiceAttributeModel(
      {required super.id,
      required super.name,
      required super.value,
      required super.autoComplete});

        Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'value': value,
      'autoComplete': autoComplete,
    };
  }

  factory ServiceAttributeModel.fromJson(Map<String, dynamic> map) {
    return ServiceAttributeModel(
      id: map['attr_id'] as int,
      name: map['attr_name'] as String,
      value: map['attr_value']  ??'',
      autoComplete: List<String>.from((map['auto_complete'] as List<dynamic>),
    ),);
  }
}
