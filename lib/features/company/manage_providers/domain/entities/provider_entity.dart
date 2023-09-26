import 'package:equatable/equatable.dart';

class ProviderEntity extends Equatable {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneCode;
  final String? mobile;
  final String? active;
  final String? image;
  final String? expertMobile;
  final int? type;

  ProviderEntity(
      {
      this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.phoneCode,
      this.mobile,
      this.active,
      this.image,
      this.expertMobile,
      this.type});

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        phoneCode,
        mobile,
        active,
        image,
        expertMobile,
        type
      ];
}
