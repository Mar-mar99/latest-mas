class ServiceAttributeEntity {
   final int id;
  final String name;
  final String value;
  final List<String> autoComplete;
  ServiceAttributeEntity({
    required this.id,
    required this.name,
    required this.value,
    required this.autoComplete,
  });
}
