import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:masbar/core/utils/enums/enums.dart';
import '../../../../../core/utils/helpers/helpers.dart';
import '../../../../../core/utils/services/shared_preferences.dart';
import '../../../../provider/homepage/domain/use_cases/submit_provider_location_use_case.dart';
import '../../domain/repositories/auth_repo.dart';

import '../../domain/use cases/get_user_data_usecase.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final SubmitProviderLocationUseCaase submitProviderLocationUseCase;
  final GetUserDataUseCase getUserDataUseCase;
  final AuthRepo authRepository;

  AuthenticationBloc(
      {required this.authRepository,
      required this.getUserDataUseCase,
      required this.submitProviderLocationUseCase})
      : super(AuthenticationInitial()) {
    on<AppStarted>((event, emit) async {
      await _appStarted(emit);
    });

    on<LogInUserEvent>((event, emit) async {
      await _logIn(emit, event);
    });
    on<LogOutUserEvent>((event, emit) async {
      await _logOut(emit);
    });
  }

  Future<void> _appStarted(Emitter<AuthenticationState> emit) async {
    await decideState(
      emit,
    );
  }

  Future<void> _logOut(Emitter<AuthenticationState> emit) async {
    print('deleting token');
    await authRepository.deleteToken();
    print('deleting user Data');
    await authRepository.deleteUserData();
    if (await PreferenceUtils.hasValue("isWorking")) {
      await PreferenceUtils.removeValue(
        "isWorking",
      );
    }
    print('unauth bloc');
    emit(UnauthenticatedState());
  }

  Future<void> _logIn(
      Emitter<AuthenticationState> emit, LogInUserEvent event) async {
    await decideState(emit);
  }

  decideState(Emitter<AuthenticationState> emit) async {
    final hasData = await authRepository.hasUserData();
    if (!hasData) {
      emit(UnauthenticatedState());
      return;
    } else if (hasData) {
      final res = await getUserDataUseCase(
        typeAuth: Helpers.getUserTypeEnum(
          authRepository.getUserData()!.type!,
        ),
      );

      await res.fold((f) {}, (userData) async {
        await authRepository.saveUserData(userData);
      });

      final userData = authRepository.getUserData();

      if (userData!.status != null && userData.status == 'onboarding') {
        emit(OnBoardingState());
      } else if (userData.verified != null && userData.verified == 0) {
        emit(VerificataionState());
      } else if (userData.verified != null && userData.verified == 1) {
        emit(AuthenticatedState());
      }
    }
  }
}
