import '../../domain/entities/my_location_entity.dart';

class MyLocationsModel extends MyLocationsEntity {
  MyLocationsModel(
      {required super.id,
      required super.lat,
      required super.lng,
      required super.address,
      required super.name});
  factory MyLocationsModel.fromJson(Map<String, dynamic> json) {
    return MyLocationsModel(
        address: json['address'],
        id: json['id'],
        lat: double.parse(json['latitude']),
        lng: double.parse(json['longitude']),
        name: json['location_name']);
  }
  Map<String, dynamic> toJson() {
    return {
      "latitude": lat,
      "longitude": lng,
      "address": address,
      "location_name": name
    };
  }
}
