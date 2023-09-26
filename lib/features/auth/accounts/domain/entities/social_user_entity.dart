// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class SocialUserEntity extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final String photo;
  final String id;
  SocialUserEntity({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.photo,
    required this.id,
  });
  factory SocialUserEntity.empty() {
    return SocialUserEntity(
      firstName: '',
      lastName: '',
      email: '',
      photo: '',
      id: '',
    );
  }

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        email,
        photo,
        id,
      ];

  @override
  bool get stringify => true;
}
