// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'social_login_bloc.dart';

abstract class SocialLoginEvent extends Equatable {
  const SocialLoginEvent();

  @override
  List<Object> get props => [];
}

class FetchSocialUserEvent extends SocialLoginEvent {
  final SocialLoginType socialLoginType;
  FetchSocialUserEvent({
    required this.socialLoginType,
  });

  @override
  List<Object> get props => [socialLoginType];
}

class SocialSubmitEvent extends SocialLoginEvent {

  final int state;

  SocialSubmitEvent({
    required this.state,
  });

  @override
  List<Object> get props => [
        state,
      ];
}
