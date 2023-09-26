import '../../domain/entities/social_user_entity.dart';

class SocialUserModel extends SocialUserEntity {
  SocialUserModel(
      {required super.firstName,
      required super.lastName,
      required super.email,
      required super.photo,
      required super.id});
}
