import '../../domain/entities/document_entity.dart';

class DocumentModel extends DocumentEntity {
  DocumentModel({
    required super.id,
    required super.url,
    required super.status,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'],
      url: json['url'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['url'] = url;
    data['status'] = status;
    return data;
  }
}
