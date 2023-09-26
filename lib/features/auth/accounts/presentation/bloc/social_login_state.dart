// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'social_login_bloc.dart';

enum SocialLoginCurrentState {
  init,
  loadingUserInfo,
  fetchedUserInfoSuccessfuly,
  loadingLogin,
  loggedSuccessfuly,
  offline,
  error
}

class SocialLoginState extends Equatable {
  final SocialLoginType socialLoginType;
  final SocialUserEntity socialUserEntity;
  final int state;
  final SocialLoginCurrentState socialLoginCurrentState;
  const SocialLoginState({
    required this.socialLoginType,
    required this.socialUserEntity,
    required this.state,
    required this.socialLoginCurrentState,
  });
  factory SocialLoginState.empty() {
    return SocialLoginState(
        socialLoginCurrentState: SocialLoginCurrentState.init,
        socialLoginType: SocialLoginType.google,
        socialUserEntity: SocialUserEntity.empty(),
        state: 0);
  }

  @override
  List<Object> get props => [
        socialUserEntity,
        state,
        socialLoginCurrentState,
        socialLoginType,
      ];

  SocialLoginState copyWith({
    SocialLoginType? socialLoginType,
    SocialUserEntity? socialUserEntity,
    int? state,
    SocialLoginCurrentState? socialLoginCurrentState,
  }) {
    return SocialLoginState(
      socialLoginType: socialLoginType ?? this.socialLoginType,
      socialUserEntity: socialUserEntity ?? this.socialUserEntity,
      state: state ?? this.state,
      socialLoginCurrentState:
          socialLoginCurrentState ?? this.socialLoginCurrentState,
    );
  }
}
