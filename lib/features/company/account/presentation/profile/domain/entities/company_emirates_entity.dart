// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class CompanyEmiratesEntity extends Equatable {
  final int id;
  final String name;
  final bool isChecked;
  final bool isMainBranch;
  CompanyEmiratesEntity({
    required this.id,
    required this.name,
    required this.isChecked,
    required this.isMainBranch,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    isChecked,
    isMainBranch,];
}
