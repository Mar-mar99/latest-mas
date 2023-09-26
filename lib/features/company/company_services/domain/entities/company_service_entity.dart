// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class CompanyServiceEntity extends Equatable {
  final int id;
  final String name;
  CompanyServiceEntity({
    required this.id,
    required this.name,
  });
  factory CompanyServiceEntity.empty() {
    return CompanyServiceEntity(id: -1, name: '');
  }
  @override
  List<Object?> get props => [
        id,
        name,
      ];
}
