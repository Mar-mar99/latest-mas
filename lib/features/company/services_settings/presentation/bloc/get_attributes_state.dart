// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'get_attributes_bloc.dart';

enum AttributesStates { init, loaded, loading, offline, error }

class GetAttributesState extends Equatable {
  final CompanyServiceEntity service;
  final CompanyProviderEntity provider;
  final List<ServiceAttributeEntity> attributes;
  final AttributesStates attributesStates;
  const GetAttributesState({
    required this.service,
    required this.provider,
    required this.attributes,
    required this.attributesStates,
  });
  factory GetAttributesState.empty() {
    return  GetAttributesState(
      service:CompanyServiceEntity.empty() ,
      provider: CompanyProviderEntity.empty(),
      attributes: [],
      attributesStates: AttributesStates.init,
    );
  }
  @override
  List<Object> get props => [
       service,
        attributesStates,
        provider,
        attributes,
      ];


  GetAttributesState copyWith({
    CompanyServiceEntity? service,
    CompanyProviderEntity? provider,
    List<ServiceAttributeEntity>? attributes,
    AttributesStates? attributesStates,
  }) {
    return GetAttributesState(
      service: service ?? this.service,
      provider: provider ?? this.provider,
      attributes: attributes ?? this.attributes,
      attributesStates: attributesStates ?? this.attributesStates,
    );
  }
}
