import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../domain/use_cases/update_company_profile_use_case.dart';
import '../../domain/use_cases/update_provider_profile_use_case.dart';
import '../../domain/use_cases/update_user_profile_use_case.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final UpdateUserProfileUseCase updateUserProfileUseCase;
  final UpdateCompanyProfileUseCase updateCompanyProfileUseCase;
  final UpdateProviderProfileUseCase updateProviderProfileUseCase;
  EditProfileBloc({
    required this.updateUserProfileUseCase,
    required this.updateCompanyProfileUseCase,
    required this.updateProviderProfileUseCase,
  }) : super(EditProfileInitial()) {
    on<SubmitUserProfileImageEvent>((event, emit) async {
      emit(LoadingEditProfile());
      final res = await updateUserProfileUseCase(
          firstName: event.firstName,
          lastName: event.lastName,
          state: event.stateId,
          avatar: event.avatar);
      res.fold(
        (failure) {
          emit(_mapFailureToState(failure));
        },
        (u) => emit(DoneEditProfile()),
      );
    });

    on<SubmitCompanyProfileImageEvent>((event, emit) async {
      emit(LoadingEditProfile());
      final res = await updateCompanyProfileUseCase(
          address: event.address,
          firstName: event.firstName,
          local: event.local,
          state: event.state,
          avatar: event.avatar);
      res.fold(
        (failure) {
          emit(_mapFailureToState(failure));
        },
        (u) => emit(DoneEditProfile()),
      );
    });
    on<SubmitProviderProfileImageEvent>((event, emit) async {
      emit(LoadingEditProfile());
      final res = await updateProviderProfileUseCase(
        firstName: event.firstName,
        lastName: event.lastName,
        state: event.stateId,
        avatar: event.avatar,
      );
      res.fold(
        (failure) {
          emit(_mapFailureToState(failure));
        },
        (u) => emit(DoneEditProfile()),
      );
    });
  }
  EditProfileState _mapFailureToState(Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        return EditProfileOfflineState();

      case NetworkErrorFailure:
        return EditProfileErrorState(
          message: (f as NetworkErrorFailure).message,
        );

      default:
        return const EditProfileErrorState(
          message: 'Error',
        );
    }
  }
}
