import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masbar/core/errors/failures.dart';
import 'package:masbar/core/utils/enums/enums.dart';
import 'package:masbar/features/auth/accounts/domain/entities/social_user_entity.dart';

import 'package:masbar/features/auth/accounts/domain/use%20cases/fetch_social_user_usecase.dart';
import 'package:masbar/features/user_emirate/domain/use%20cases/fetch_uae_states_usecase.dart';

import '../../domain/use cases/social_login_usecase.dart';

part 'social_login_event.dart';
part 'social_login_state.dart';

class SocialLoginBloc extends Bloc<SocialLoginEvent, SocialLoginState> {
  final FetchSocialUserUseCase fetchSocialUserUseCase;

  final SocialLoginUseCase socialLoginUseCase;
  SocialLoginBloc({
    required this.fetchSocialUserUseCase,
    required this.socialLoginUseCase,
  }) : super(SocialLoginState.empty()) {
    on<FetchSocialUserEvent>((event, emit) async {
      emit(
        state.copyWith(
          socialLoginCurrentState: SocialLoginCurrentState.loadingUserInfo,
        ),
      );
      final res = await fetchSocialUserUseCase.call(
        socialLoginType: event.socialLoginType,
      );
      res.fold(
        (l) => _mapFailureToState,
        (socialUserEntity) async {
          emit(
            state.copyWith(
              socialUserEntity: socialUserEntity,
              socialLoginType: event.socialLoginType,
              socialLoginCurrentState:
                  SocialLoginCurrentState.fetchedUserInfoSuccessfuly,
            ),
          );
        },
      );
    });

    on<SocialSubmitEvent>((event, emit) async {
      emit(
        state.copyWith(
          socialLoginCurrentState: SocialLoginCurrentState.loadingLogin,
        ),
      );
      final res = await socialLoginUseCase.call(
          socialLoginType: state.socialLoginType,
          socialUserEntity: state.socialUserEntity,
          state: event.state);
      res.fold(
        (l) {
          print('fails');
          emit(
            state.copyWith(
              socialLoginCurrentState: _mapFailureToState(l),
            ),
          );
        },
        (socialUserEntity) async {
          print('succ');
          emit(

            state.copyWith(
              socialLoginCurrentState:
                  SocialLoginCurrentState.loggedSuccessfuly,
            ),
          );
        },
      );
    });
  }

  SocialLoginCurrentState _mapFailureToState(Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        return SocialLoginCurrentState.offline;

      case NetworkErrorFailure:
        return SocialLoginCurrentState.error;

      default:
        return SocialLoginCurrentState.error;
    }
  }
}
