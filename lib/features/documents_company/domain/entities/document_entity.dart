import 'package:equatable/equatable.dart';

class DocumentEntity extends Equatable {
  int? id;
  String? url;
  String? status;

  DocumentEntity({
    required this.id,
    required this.url,
    required this.status,
  });

  @override
  List<Object?> get props => [id, url, status];
}
