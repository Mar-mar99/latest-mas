import '../../domain/entities/created_request_result_entity.dart';

class CreatedRequestResultModel extends CreatedRequestResultEntity {
  CreatedRequestResultModel(
      {required super.requestId, });

  factory CreatedRequestResultModel.fromJson(Map<String, dynamic> json) {
    return CreatedRequestResultModel(
      
        requestId: json['request_id']);
  }
}
