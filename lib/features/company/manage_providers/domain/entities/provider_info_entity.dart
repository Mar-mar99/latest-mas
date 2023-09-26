// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:masbar/features/company/manage_providers/domain/entities/provider_entity.dart';

class ProviderInfoEntity  extends Equatable{
  final int?allowedExperts;
  final int?activeExperts;
  final int?disabledExperts;
  final List<ProviderEntity> ?providers;
  ProviderInfoEntity({
     this.allowedExperts,
     this.activeExperts,
     this.disabledExperts,
     this.providers
  });
  @override

  List<Object?> get props => [
     allowedExperts,
     activeExperts,
     disabledExperts,
     providers
  ];
}
