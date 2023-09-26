import 'package:equatable/equatable.dart';
class MyLocationsEntity extends Equatable{
  final int id;
  final double lat;
  final double lng;
  final String address;
  final String name;
  MyLocationsEntity({
    required this.id,
    required this.lat,
    required this.lng,
    required this.address,
    required this.name,
  });

  @override

  List<Object?> get props =>[
    id,
    lat,
    lng,
    address,
    name,
  ];
}
