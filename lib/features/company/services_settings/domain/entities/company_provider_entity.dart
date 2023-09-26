import 'package:equatable/equatable.dart';

class CompanyProviderEntity extends Equatable {
  final int id;
  final String name;
  const CompanyProviderEntity({
    required this.id,
    required this.name,
  });
  factory CompanyProviderEntity.empty() {
    return CompanyProviderEntity(id: -1, name: '');
  }

  @override
  List<Object?> get props => [id, name];
}
